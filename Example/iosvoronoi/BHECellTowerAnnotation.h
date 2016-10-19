//
//  BHECellTowerAnnotation.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BHEVoronoiCellTower.h"

@interface BHECellTowerAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSUUID *cellTowerID;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithLocation:(CLLocationCoordinate2D)coord;
- (instancetype)initWithTower:(BHEVoronoiCellTower *)cellTower;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
