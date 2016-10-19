//
//  BHEMapTableViewController.m
//  iosvoronoi
//
//  Created by Rhys Jones on 10/19/16.
//  Copyright © 2016 Rhys D. Jones. All rights reserved.
//

#import "BHEMapTableViewController.h"
#import "BHEConstants.h"
#import "BHEVoronoiMap.h"
#import "BHEVoronoiCellTower.h"
#import "BHEVoronoiMapStore.h"
#import "BHEVoronoiMapViewController.h"

@interface BHEMapTableViewController ()

@property (nonatomic, strong) BHEVoronoiMap *selectedMap;

@end

@implementation BHEMapTableViewController


- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[BHEVoronoiMapStore sharedStore] allVoronoiMaps] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MapCell"];
    // Configure the cell...
    NSArray *voronoiMaps = [[BHEVoronoiMapStore sharedStore] allVoronoiMaps];
    BHEVoronoiMap *voronoiMap = voronoiMaps[indexPath.row];
    cell.textLabel.text = voronoiMap.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu Voronoi Cell Towers", (unsigned long)[voronoiMap.cellTowers count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
}


#pragma mark- Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueNewMap] || [segue.identifier isEqualToString:kSegueMapSettings]) {
        BHEEditMapViewController *editMapVC = segue.destinationViewController;
        editMapVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:kSegueVoronoiMap]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        NSArray *voronoiMaps = [[BHEVoronoiMapStore sharedStore] allVoronoiMaps];
        
        BHEVoronoiMapViewController *voronoiMapVC = segue.destinationViewController;
        voronoiMapVC.vMap = voronoiMaps[indexPath.row];
    }
    
}

#pragma mark- BHEMapDetailsViewControllerDelegate methods
- (void)editMapDidSave:(BHEEditMapViewController *)mapDetails {
    
    BHEVoronoiMap *newVoronoiMap = [[BHEVoronoiMap alloc] initWithTitle:mapDetails.titleField.text];
    [[BHEVoronoiMapStore sharedStore] saveVoronoiMap:newVoronoiMap];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)editMapDidCancel:(BHEEditMapViewController *)mapDetails{
    [self.navigationController popViewControllerAnimated:YES];
}

@end