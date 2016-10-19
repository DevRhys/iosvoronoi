//
//  BHEVoronoiCellTower.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "Site.h"
#import <MapKit/MapKit.h>

@interface BHEVoronoiCellTower : Site

@property (nonatomic, strong) CLLocation *location;
@property (copy, nonatomic) NSString *title;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithLocation:(CLLocation *)location;
- (instancetype)initWithLocation:(CLLocation *)location name:(NSString *)title;
- (CLLocationDistance)distanceFromCellTower:(BHEVoronoiCellTower *)cellTower;
- (CLLocationDistance)distanceFromLocation:(CLLocation *)location;


@end
