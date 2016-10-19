//
//  BHEVoronoiMap.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BHEVoronoiMap : NSObject


@property (nonatomic, strong) NSUUID *uuID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableDictionary *cellTowers;

+ (NSArray *)voronoiCellsFromTowers:(NSMutableDictionary *)cellTowers;

- (instancetype)initWithTitle:(NSString*)title;

- (NSArray *)annotations;
- (NSArray *)allTowerLocations;
- (NSArray *)voronoiCells;

- (NSString *)generateCellTowerTitle;

@end