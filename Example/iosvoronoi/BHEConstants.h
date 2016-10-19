//
//  BHEConstants.h
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//
#import <Foundation/Foundation.h>

#pragma mark- View Tags
#define kLeftCalloutButtonTag 99
#define kRightCalloutButtonTag 98
#define kBeaconTypePickerTag 0
#define kActivityTypePickerTag 1

#pragma mark- Segues
#define kSegueCellTowerView @"CellTowerViewSegue"
#define kSegueCellTowerDetail @"CellTowerDetailSegue"
#define kSegueVoronoiMap @"VoronoiMapSegue"
#define kSegueNewMap @"NewMapSegue"
#define kSegueMapSettings @"MapSettingsSegue"

#pragma mark- Reuse Identifiers
#define kReuseIdentifierCellTowerAnnotation @"CellTowerAnnotation"

#pragma mark- Data Storage
#define kBaseCellTowerTitle @"New Cell Tower"
#define kBaseSoundMapTitle @"New Voronoi Map"
#define kArchiveName @"VoronoiMap.archive"

#pragma mark- Map Constants
#define kMaximumMapPointX 268435456.000000
#define kMaximumMapPointY 268435456.000000

// Because Mercator projects the poles at infinity, Apple Maps cannot show the poles.
// Instead it cuts off coverage at 85.051129° north and south. This is not considered a limitation,
// given the purpose of the service. The value 85.051129° is the latitude at which the full map
// becomes a square, and is computed as φ given y = 0. So while the theoretical maximum
// latitude is 90, we reduce this to the actual map rectangle of the Mercator projection.
// https://en.wikipedia.org/wiki/Web_Mercator

#define kPracticalMaximumMapPointY 267995781.597516
#define kPracticalMaximumLatitude 85.051129
#define kMaximumLatitude 90.000000
#define kMaximumLongitude 180.000000

#pragma mark- Voronoi
#define kVoronoiStartRendering 0
#define kVoronoiRenderingDelay 6
#define kFillColor 0.6