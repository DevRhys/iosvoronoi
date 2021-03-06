//
//  ClayRelaxer.m
//  objcvoronoi
//

#import "ClayRelaxer.h"
#import "Site.h"
#import "Vertex.h"
#import "Cell.h"
#import "Edge.h"
#import "Halfedge.h"
#import "Vertex.h"

@implementation ClayRelaxer


- (id)initWithCells:(NSMutableArray *)cellArray
{
    self = [super init];
    if (self) {
        cells = [[NSMutableArray alloc] initWithArray:cellArray];
        newSites = [[NSMutableArray alloc] init];
        
    }
    return self;
}

// Return an NSMutableArray of NSValues that encode NSPoints that
// can be used to regenerate the Voronoi diagram
+ (NSMutableArray *)relaxSitesInCells:(NSMutableArray *)cellArray
{
    ClayRelaxer *cr = [[ClayRelaxer alloc] initWithCells:cellArray];
    [cr processCells];
    return [cr newSites];
    
}

- (void)processCells
{
    //NSLog(@"Processing Cells...");
    // Iterate through each cell, process its sites, and then 
    // put the new site into the newSites array. 
    for (Cell *c in cells) {
        
        // Put the point from the cell into this array, which we'll process
        NSMutableArray *cellPoints = [[NSMutableArray alloc] init];
        
        for (Halfedge *he in [c halfedges]) {
            // Get the start point from each halfedge
            // and thereby avoid getting duplicates
            // (vs. getting both points).
            Vertex *start = [he getStartpoint];
            [cellPoints addObject:[NSValue valueWithCGPoint:[start coord]]];
        }
        
        double newX = 0;
        double newY = 0;
        double countPoints = 0;
        
        for (NSValue *v in cellPoints) {
            newX += [v CGPointValue].x;
            newY += [v CGPointValue].y;
            countPoints += 1;
        }
        
        newX = newX / countPoints;
        newY = newY / countPoints;
        
        [newSites addObject:[NSValue valueWithCGPoint:CGPointMake(newX, newY)]];
    }
    //NSLog(@"...completed processing cells.");
}

- (NSMutableArray *)newSites
{
    return newSites;
}

@end
