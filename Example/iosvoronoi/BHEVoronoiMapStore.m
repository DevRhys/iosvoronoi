//
//  BHEVoronoiMapStore.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEVoronoiMapStore.h"
#import "BHEConstants.h"

@interface BHEVoronoiMapStore ()

@property (nonatomic, strong) NSMutableDictionary *privateVoronoiMaps;

@end

@implementation BHEVoronoiMapStore


#pragma mark- Singleton

+ (instancetype)sharedStore {
    static BHEVoronoiMapStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

#pragma mark- Initializers

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        NSString *archivePath = [self voronoiMapArchivePath];
        _privateVoronoiMaps = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
        
        if (!_privateVoronoiMaps) {
            _privateVoronoiMaps = [NSMutableDictionary dictionary];
        }
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[VoronoiMapStore sharedStore]" userInfo:nil];
    return nil;
}

#pragma mark- Disk Storage

- (BOOL)saveToDisk {
    NSString *archivePath = [self voronoiMapArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:self.privateVoronoiMaps toFile:archivePath];
}

#pragma mark- SoundMap Management

- (BHEVoronoiMap *)getVoronoiMapByID:(NSUUID *)uuID {
    return [self.privateVoronoiMaps objectForKey:uuID];
}

- (BOOL)saveVoronoiMap:(BHEVoronoiMap *)voronoiMap {
    // Don't save nil values into the store
    if (!voronoiMap) {
        return FALSE;
    }
    [self.privateVoronoiMaps setObject:voronoiMap forKey:voronoiMap.uuID];
    if ([self saveToDisk]) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)removeVoronoiMapByID:(NSUUID *)uuID {
    
    [self.privateVoronoiMaps removeObjectForKey:uuID];
    if (![self saveToDisk]) {
        return FALSE;
    }
    return TRUE;
}

- (void)clearVoronoiMaps {
    [self.privateVoronoiMaps removeAllObjects];
    [self saveToDisk];
}

#pragma mark- Accessors

- (NSArray *)allVoronoiMaps {
    return [self.privateVoronoiMaps allValues];
}

#pragma mark- Private Utility Functions

- (NSString *)voronoiMapArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:kArchiveName];
}

- (NSString *)generateVoronoiMapTitle
{
    NSString *baseTitle = kBaseSoundMapTitle;
    NSString *title = baseTitle;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    NSArray *results = [self.allVoronoiMaps filteredArrayUsingPredicate:predicate];
    int suffix = 2;
    
    while ([results count]) {
        title = [baseTitle stringByAppendingString: [NSString stringWithFormat:@" %d", suffix]];
        predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
        results = [self.allVoronoiMaps filteredArrayUsingPredicate:predicate];
        suffix++;
    }
    return title;
}

@end
