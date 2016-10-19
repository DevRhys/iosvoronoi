//
//  BHEVoronoiMapViewController.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEVoronoiMapViewController.h"
#import "BHEVoronoiCell.h"
#import "BHEVoronoiMapStore.h"
#import "BHECellTowerAnnotation.h"
#import "BHEConstants.h"
#import "MKPolygon+MKPolygon_BHEExtensions.h"

@interface BHEVoronoiMapViewController ()

@property (nonatomic, strong) BHEVoronoiCellTower *draggingTower;
@property (nonatomic, strong) NSMutableDictionary *towersToRender;

@end

@implementation BHEVoronoiMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MKMap
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
    [self.mapView addAnnotations: [self.vMap annotations]];
    
    // Gestures
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.mapView addGestureRecognizer:longPress];

}

- (void)viewWillAppear:(BOOL)animated {
    
    // Update the annotations on the mapView
    
    NSMutableArray *annotationsToRemove = [self.mapView.annotations mutableCopy];
    [self.mapView removeAnnotations: annotationsToRemove];
    [self.mapView addAnnotations: [self.vMap annotations]];
    
    // Remove all overlays before (re)drawing the view
    NSMutableArray *overlaysToRemove = [self.mapView.overlays mutableCopy];
    [self.mapView removeOverlays: overlaysToRemove];
    
    // Ask the map to generate a tessellation
    for (BHEVoronoiCell *cell in [self.vMap voronoiCells]) {
        [self.mapView addOverlay:[cell overlay]];
    }
    
    // Navigation Bar Setup
    self.navigationItem.title = self.vMap.title;
    
    // Navigation Controller
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Map Actions
// TO DO: Fix crash when zoomed out fully and Find Location button is pushed
// by calculating the maximum possible span of the map and making sure the
// new region does not exceed that maximum. Improvement: if the user location
// is actually on screen, don't zoom out at all but smoothly zoom in. Improvement:
// if zoomed out past a certain point (say, the continental United States), no further
// zoom is necessary, simply an animated recentering (this would fix the above crash)

#pragma mark- Gestures

- (void)handleLongPress:(UIGestureRecognizer *)gesture
{
    if (gesture.state ==  UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [gesture locationInView:self.mapView];
        CLLocationCoordinate2D touchPointCoordinates =  [self.mapView convertPoint:touchPoint
                                                              toCoordinateFromView:self.mapView];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:touchPointCoordinates.latitude
                                                          longitude:touchPointCoordinates.longitude];
        
        BHEVoronoiCellTower *cellTower = [[BHEVoronoiCellTower alloc] initWithLocation:location];
        cellTower.title = [self.vMap generateCellTowerTitle];
        [self.vMap.cellTowers setObject:cellTower forKey:cellTower.uuID];
        [[BHEVoronoiMapStore sharedStore] saveVoronoiMap:self.vMap];
        [self.mapView addAnnotation:[[BHECellTowerAnnotation alloc] initWithTower:cellTower]];
        
        [self renderOverlays];
    }
}

#pragma mark- MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // Leave the user location annotation alone
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[BHECellTowerAnnotation class]]) {
        MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kReuseIdentifierCellTowerAnnotation];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kReuseIdentifierCellTowerAnnotation];
            annotationView.image = [UIImage imageNamed:@"selected pin.png"];
            annotationView.canShowCallout = YES;
            
            // Right button
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.tag = kRightCalloutButtonTag;
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
            
            // Left button
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            leftButton.tag = kLeftCalloutButtonTag;
            [leftButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [leftButton setBackgroundImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
            leftButton.frame = CGRectMake(0, 0, 30, 30);
            annotationView.leftCalloutAccessoryView = leftButton;
            
            annotationView.draggable = YES;
            
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    BHECellTowerAnnotation *cellTowerAnnotation = (BHECellTowerAnnotation *)view.annotation;
    self.currentlySelectedTower = [self.vMap.cellTowers objectForKey:cellTowerAnnotation.cellTowerID];
    
    // This is strange. The buttons added to the MKAnnotationView in mapView:viewForAnnotation
    // all go through this callback when touched. While a selector can be set on the button, it
    // can pass no information to that selector (such as which annotation is being dealt with)
    // making selectors useless in this case. Apple's sample code makes this clear. And so we
    // can only try to distinguish between which control was tapped by asking the button for its
    // type (thus assuming that only one button of each type is present in the callout, or that
    // no buttons are of the same type), or we can tag the buttons in mapView:viewForAnnotation
    // and use those tags to sort out which button was pressed.
    
    if (control.tag == kLeftCalloutButtonTag){
        // TO DO: alert the user with a verification prompt
        [self.vMap.cellTowers removeObjectForKey:cellTowerAnnotation.cellTowerID];
        [self.mapView removeAnnotation:cellTowerAnnotation];
        [[BHEVoronoiMapStore sharedStore] saveVoronoiMap:self.vMap];
    } else if (control.tag == kRightCalloutButtonTag) {
        [self performSegueWithIdentifier:kSegueCellTowerDetail sender:self];
    } else {
        NSLog(@"Unknown control selected in callout view.");
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    BHECellTowerAnnotation *cellTowerAnnotation = (BHECellTowerAnnotation *)view.annotation;
    BHEVoronoiCellTower *cellTower =  [self.vMap.cellTowers objectForKey:cellTowerAnnotation.cellTowerID];
    
    if (newState == MKAnnotationViewDragStateStarting) {
        // Observation for annotation dragging
        [view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
        self.draggingTower = cellTower;
        self.towersToRender = [[self.vMap cellTowers] mutableCopy];
    }
    
    if ((newState == MKAnnotationViewDragStateCanceling) || (newState == MKAnnotationViewDragStateEnding)) {
        
        // Inform the view that the drag is finished
        [view setDragState:MKAnnotationViewDragStateNone animated:YES];
        
        // update the beacon location
        cellTower.location = [[CLLocation alloc] initWithLatitude:cellTowerAnnotation.coordinate.latitude longitude:cellTowerAnnotation.coordinate.longitude];
        
        // save the changes to the map, save the map to the store
        [self.vMap.cellTowers setObject:cellTower forKey:cellTower.uuID];
        [[BHEVoronoiMapStore sharedStore] saveVoronoiMap:self.vMap];
        
        // Recalculate the voronoi tesselation and redraw all overlays
        NSMutableArray *overlaysToRemove = [self.mapView.overlays mutableCopy];
        [self.mapView removeOverlays: overlaysToRemove];
        
        // Peform a Voronoi tessellation
        NSArray *voronoiCells = [self.vMap voronoiCells];
        
        for (BHEVoronoiCell *cell in voronoiCells) {
            [self.mapView addOverlay:[cell overlay]];
        }
        
        // remove observation
        [view removeObserver:self forKeyPath:@"center"];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        
        MKPolygon *polygonOverlay = (MKPolygon *)overlay;
        MKPolygonRenderer* aRenderer = [[MKPolygonRenderer alloc] initWithPolygon:(MKPolygon*)overlay];
        CGFloat lineWidth = 0.1;
        aRenderer.fillColor = [polygonOverlay.overlayColor colorWithAlphaComponent:kFillColor];
        aRenderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aRenderer.lineWidth = lineWidth;
        
        return aRenderer;
    }
    
    return nil;
}

#pragma mark- Utility Functions

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    static int renderingPass = kVoronoiStartRendering;
    
    if (renderingPass == kVoronoiStartRendering) {
        MKAnnotationView *annotationView = (MKAnnotationView *)object;
        CLLocationCoordinate2D coordinate =  [self.mapView convertPoint:annotationView.center toCoordinateFromView:self.mapView];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        // Remove the dragging tower from the towers to render
        [self.towersToRender removeObjectForKey:self.draggingTower.uuID];
        // update the dragging beacon location
        self.draggingTower.location = newLocation;
        // Add the updated dragging beacon
        [self.towersToRender setObject:self.draggingTower forKey:self.draggingTower.uuID];
        
        // Remove the old tessellation
        [self removeOverlays];
        
        NSArray *voronoiCells = [BHEVoronoiMap voronoiCellsFromTowers:self.towersToRender];
        
        for (BHEVoronoiCell *vCell in voronoiCells) {
            [self.mapView addOverlay:vCell.overlay];
        }
    }
    renderingPass++;
    if (renderingPass == kVoronoiRenderingDelay) {
        renderingPass = kVoronoiStartRendering;
    }
}

- (void)renderOverlays {
    // Recalculate the voronoi tesselation and redraw all overlays
    NSMutableArray *overlaysToRemove = [self.mapView.overlays mutableCopy];
    [self.mapView removeOverlays: overlaysToRemove];
    
    // Peform a Voronoi tessellation
    NSArray *voronoiCells = [self.vMap voronoiCells];
    
    for (BHEVoronoiCell *cell in voronoiCells) {
        [self.mapView addOverlay:[cell overlay]];
    }
}

- (void)removeOverlays {
    NSMutableArray *overlaysToRemove = [self.mapView.overlays mutableCopy];
    [self.mapView removeOverlays: overlaysToRemove];
}

- (IBAction)done:(UIBarButtonItem *)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
