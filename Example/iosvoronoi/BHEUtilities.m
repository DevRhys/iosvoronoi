//
//  BHEUtilities.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHEUtilities.h"
#import "Vertex.h"
#import "Halfedge.h"
#import "MKPolygon+MKPolygon_BHEExtensions.h"

@implementation BHEUtilities

+ (NSArray *)verticesFromCell:(Cell *)cell {
    NSMutableArray *vertices = [NSMutableArray array];
    Vertex *startPoint;
    Vertex *endPoint;
    
    // create an array of vertices of the cell from the half-edges, eliminating duplicates
    for (Halfedge *halfEdge in [cell halfedges]) {
        startPoint = halfEdge.getStartpoint;
        endPoint = halfEdge.getEndpoint;
        // is the start point already in the array?
        if (![vertices containsObject:startPoint]) {
            [vertices addObject:startPoint];
        }
        // is the end point already in the array?
        if (![vertices containsObject:endPoint]) {
            [vertices addObject:endPoint];
        }
    }
    return vertices;
}

+ (MKPolygon *)overlayFromVertices:(NSArray *)vertices {
    MKMapPoint points[[vertices count]];
    int index = 0;
    for (Vertex *vertex in vertices) {
        points[index] = MKMapPointMake(vertex.x, vertex.y);
        index++;
    }
    
    // Create polygonal overlay based on vertices
    return [MKPolygon polygonWithPoints:points count:[vertices count]];
}

+ (UIColor *)randomColor {
    UIColor *randomRGBColor = [[UIColor alloc] initWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1.0];
    return randomRGBColor;
}

+ (Site *)siteFromTower:(BHEVoronoiCellTower *)tower {
    MKMapPoint mkMapPoint = MKMapPointForCoordinate(tower.location.coordinate);
    Site *s = [[Site alloc] initWithCoord:CGPointMake(mkMapPoint.x, mkMapPoint.y)];
    
    return s;
}

+ (NSArray *)siteArrayFromTowerArray:(NSArray *)towerArray {
    
    NSMutableArray *siteArray = [NSMutableArray new];
    
    for (BHEVoronoiCellTower *tower in towerArray) {
        Site *s = [BHEUtilities siteFromTower:tower];
        [siteArray addObject:s];
    }
    
    return [siteArray copy];
}
@end
