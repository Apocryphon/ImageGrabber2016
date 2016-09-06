//
//  ImageListViewController.m
//  ImageGrabber2016
//
//  Created by Richard Yeh on 9/5/16.
//  Copyright © 2016 Situation Excellent. All rights reserved.
//

#import "ImageListViewController.h"

@interface ImageListViewController ()

@end

@implementation ImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // TODO: handle this in storyboard
    // Add activity indicator to nav bar
    CGRect frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
    self.activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithFrame:frame];
    [self.activityIndicator sizeToFit];
    self.activityIndicator.autoresizingMask =
    (UIViewAutoresizingFlexibleLeftMargin |
     UIViewAutoresizingFlexibleRightMargin |
     UIViewAutoresizingFlexibleTopMargin |
     UIViewAutoresizingFlexibleBottomMargin);
    [self.activityIndicator startAnimating];
    
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    loadingView.target = self;
    self.navigationItem.rightBarButtonItem = loadingView;
    
    // Start image manage to load images
    self.imageInfos = [[NSMutableArray alloc] init];
    self.imageManager = [[ImageManager alloc] initWithHTML:self.html delegate:self];
    [self.imageManager process];

}

- (void)imageInfosAvailable:(NSArray *)newInfos done:(BOOL)done {
    
    NSLog(@"Image infos available: %lu!", (unsigned long) newInfos.count);
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:newInfos.count];
    for(unsigned long i = self.imageInfos.count; i < self.imageInfos.count + newInfos.count; ++i) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
    }
    [self.imageInfos addObjectsFromArray:newInfos];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
    
    if (done) {
        [self.activityIndicator stopAnimating];
    }
    
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
    return self.imageInfos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ImageInfo *info = [self.imageInfos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.imageName;
    cell.imageView.image = info.image;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    ImageInfo *info = [self.imageInfos objectAtIndex:indexPath.row];
    if (self.imageDetailViewController == nil) {
        self.imageDetailViewController = [[ImageDetailViewController alloc] init];
    }
    self.imageDetailViewController.info = info;
    [self.navigationController pushViewController:self.imageDetailViewController animated:YES];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
