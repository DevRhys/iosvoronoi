//
//  BHEVoronoiMapStore.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BHEVoronoiMap.h"

@interface BHEVoronoiMapStore : NSObject

+ (instancetype)sharedStore;

@property (nonatomic, readonly) NSArray *allVoronoiMaps;

- (void)clearVoronoiMaps;

- (BOOL)saveToDisk;
- (BOOL)saveVoronoiMap:(BHEVoronoiMap *)vMap;
- (BOOL)removeVoronoiMapByID:(NSUUID *)uuID;

- (BHEVoronoiMap *)getVoronoiMapByID:(NSUUID *)uuID;
- (NSString *)generateVoronoiMapTitle;

@end
