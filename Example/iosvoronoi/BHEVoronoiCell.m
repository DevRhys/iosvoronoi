//
//  BHEVoronoiCell.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEVoronoiCell.h"
#import "BHEUtilities.h"
#import "MKPolygon+MKPolygon_BHEExtensions.h"

@implementation BHEVoronoiCell

- (instancetype)initWithCell:(Cell *)cell tower:(BHEVoronoiCellTower *)tower {
    self = [super init];
    if (self) {
        _cell = cell;
        _tower = tower;
        _color = tower.color;
    }
    return self;
}

- (NSArray *)edges {
    return self.cell.halfedges;
}

- (NSArray *)vertices {
    return [BHEUtilities verticesFromCell:self.cell];
}

- (MKPolygon *)overlay {
    MKPolygon *overlay = [BHEUtilities overlayFromVertices:self.vertices];
    overlay.overlayColor = self.color;
    return overlay;
}

@end
