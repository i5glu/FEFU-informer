//
//  CarTableViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarCell.h"
#import "AFNetworking.h"


@interface CarTableViewController ()

@end

@implementation CarTableViewController{
    NSArray *data;
    NSNumber *loadOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/drivingBidsList/0" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        loadOffset = @15;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CarCell";
    CarCell *cell = (CarCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    
    
    cell.destination.text  = [[data objectAtIndex:indexPath.row] objectForKey:@"destination"];
    cell.departure.text = [[data objectAtIndex:indexPath.row] objectForKey:@"departure"];
    cell.payment.text = [[data objectAtIndex:indexPath.row] objectForKey:@"payment"];
    cell.phoneNumber.text = [[data objectAtIndex:indexPath.row] objectForKey:@"phoneNumber"];
    cell.note.text = [[data objectAtIndex:indexPath.row] objectForKey:@"note"];
    cell.note.editable = NO;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 50;
    if(y > h + reload_distance) {
        
        NSString *url = [NSString stringWithFormat:@"http://31.131.24.188:8080/drivingBidsList/%@", loadOffset];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            data = [data arrayByAddingObjectsFromArray:responseObject];
            [self.tableView reloadData];
            loadOffset = @([loadOffset intValue] + 15);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
}

@end
