//
//  BHEUtilities.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Cell.h"
#import "Site.h"
#import "BHEVoronoiCellTower.h"

@interface BHEUtilities : NSObject

+ (NSArray *)verticesFromCell:(Cell *)cell;
+ (MKPolygon *)overlayFromVertices:(NSArray *)vertices;
+ (UIColor*)randomColor;
+ (Site *)siteFromTower:(BHEVoronoiCellTower *)tower;
+ (NSArray *)siteArrayFromTowerArray:(NSArray *)towerArray;

@end