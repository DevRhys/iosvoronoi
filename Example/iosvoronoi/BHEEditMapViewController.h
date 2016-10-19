//
//  BHEEditMapViewController.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHEVoronoiMap.h"

@class BHEEditMapViewController;

@protocol BHEEditMapViewControllerDelegate <NSObject>
@optional
@property (nonatomic, strong) BHEVoronoiMap *voronoiMap;
@required
- (void)editMapDidSave:(BHEEditMapViewController *)mapDetails;
- (void)editMapDidCancel:(BHEEditMapViewController *)mapDetails;
@end

@interface BHEEditMapViewController : UIViewController
@property (nonatomic, weak) id<BHEEditMapViewControllerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
- (IBAction)cancel:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;
@end
