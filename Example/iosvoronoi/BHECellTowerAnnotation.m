//
//  BHECellTowerAnnotation.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHECellTowerAnnotation.h"

@implementation BHECellTowerAnnotation

@synthesize coordinate;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (instancetype)initWithTower:(BHEVoronoiCellTower *)cellTower {
    self = [super init];
    if (self) {
        _cellTowerID = cellTower.uuID;
        coordinate = cellTower.location.coordinate;
        _title = cellTower.title;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newLocation {
    coordinate = newLocation;
}

@end
