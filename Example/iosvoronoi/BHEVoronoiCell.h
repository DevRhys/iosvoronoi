//
//  BHEVoronoiCell.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Cell.h"
#import "BHEVoronoiCellTower.h"


@interface BHEVoronoiCell : NSObject

@property (nonatomic, strong) Cell *cell;
@property (nonatomic, strong) BHEVoronoiCellTower *tower;
@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithCell:(Cell *)cell tower:(BHEVoronoiCellTower *)tower;

- (NSArray *)edges;
- (NSArray *)vertices;
- (MKPolygon *)overlay;


@end
