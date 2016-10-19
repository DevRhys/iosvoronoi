//
//  BHEVoronoiMap.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEVoronoiMap.h"
#import "BHEConstants.h"
#import "BHEVoronoiCell.h"
#import "BHEVoronoiCellTower.h"
#import "BHECellTowerAnnotation.h"
#import "Voronoi.h"
#import "VoronoiResult.h"
#import "Cell.h"

@implementation BHEVoronoiMap

+ (NSArray *)voronoiCellsFromTowers:(NSMutableDictionary *)cellTowers {
    NSMutableArray *voronoiCells = [NSMutableArray array];
    
    // Voronoi Tesselation
    Voronoi *voronoi = [[Voronoi alloc] init];
    
    VoronoiResult *result = [voronoi computeWithSites:[cellTowers allValues] andBoundingBox:CGRectMake(0, 0, kMaximumMapPointX, kMaximumMapPointY)];
    
    for (Cell *cell in result.cells) {
        // Get the tower that corresponds to this cell using the uuID of the Site in the cell
        BHEVoronoiCellTower *cellTower = [cellTowers objectForKey:cell.site.uuID];
        
        // Create a VoronoiCell from the tower and the cell
        BHEVoronoiCell *vCell = [[BHEVoronoiCell alloc] initWithCell:cell tower:cellTower];
        
        [voronoiCells addObject:vCell];
    }
    
    return voronoiCells;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _uuID = [NSUUID UUID];
        _title = title;
        _cellTowers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _uuID = [aDecoder decodeObjectForKey:@"uuID"];
        _cellTowers = [aDecoder decodeObjectForKey:@"cellTowers"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.uuID forKey:@"uuID"];
    [aCoder encodeObject:self.cellTowers forKey:@"cellTowers"];
}

- (NSArray *)allTowerLocations {
    NSMutableArray *coordinates = [NSMutableArray array];
    for (BHEVoronoiCellTower *cellTower in [self.cellTowers allValues]) {
        [coordinates addObject:cellTower.location];
    }
    
    //fix me
    return coordinates;
}

- (NSArray *)annotations {
    NSMutableArray *annotationsArray = [NSMutableArray array];
    
    for (BHEVoronoiCellTower *cellTower in [self.cellTowers allValues]) {
        BHECellTowerAnnotation *annotation = [[BHECellTowerAnnotation alloc] initWithTower:cellTower];
        [annotationsArray addObject:annotation];
    }
    return annotationsArray;
}

- (NSString *)generateCellTowerTitle {
    NSString *baseTitle = kBaseCellTowerTitle;
    NSString *title = baseTitle;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSArray *results = [[self.cellTowers allValues] filteredArrayUsingPredicate:predicate];
    int suffix = 2;
    
    while ([results count]) {
        title = [baseTitle stringByAppendingString: [NSString stringWithFormat:@" %d", suffix]];
        predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
        results = [[self.cellTowers allValues] filteredArrayUsingPredicate:predicate];
        suffix++;
    }
    return title;
}

- (NSArray *)voronoiCells {
    
    return [BHEVoronoiMap voronoiCellsFromTowers:self.cellTowers];
    
}

@end
