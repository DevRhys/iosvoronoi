//
//  MKPolygon+MKPolygon_BHEExtensions.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

// MKPolygon is not inheritence friendly. Our overlays need to be
// associated with either beacons (or simpler, the beacon's color)
// and so we use both a category and objc_setAssociatedObject
// to add to the class. This doesn't please me.

#import <MapKit/MapKit.h>

@interface MKPolygon (MKPolygon_BHEExtensions)

@property (nonatomic, strong) UIColor *overlayColor;

@end