//
//  BHEEditMapViewController.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEEditMapViewController.h"
#import "BHEVoronoiMapStore.h"

@implementation BHEEditMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleField.text = [[BHEVoronoiMapStore sharedStore] generateVoronoiMapTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self.delegate editMapDidCancel:self];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    [self.delegate editMapDidSave:self];
}

@end
