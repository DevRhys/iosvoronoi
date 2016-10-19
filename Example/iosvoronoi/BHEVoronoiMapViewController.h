//
//  BHEVoronoiMapViewController.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "BHEVoronoiMap.h"
#import "BHEVoronoiCellTower.h"
#import "BHEEditMapViewController.h"

@class BHEVoronoiMapViewController;

@interface BHEVoronoiMapViewController : UIViewController <MKMapViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) BHEVoronoiMap *vMap;
@property (strong, nonatomic) BHEVoronoiCellTower *currentlySelectedTower;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)done:(UIBarButtonItem *)sender;

@end
