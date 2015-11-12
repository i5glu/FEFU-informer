//
//  EventViewController.m
//  FEFU
//
//  Created by Илья on 10.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "EventViewController.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#import "AFNetworking.h"

@implementation EventViewController{
    NSArray *data;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/newsLine/0&o" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (NSInteger)[data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"EventCell";
    EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.header.lineBreakMode = NSLineBreakByWordWrapping;
    cell.text.numberOfLines = 0;
    
    cell.header.text  = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.text.text = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    
    /*
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"img_src"]]];
    cell.image.image = [UIImage imageWithData:imageData];
    */
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"img_src"]  ]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            cell.image.image = [UIImage imageWithData: imageData];
        });
    });
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    NSLog(@"%li", (long)indexPath.row);
    [self performSegueWithIdentifier:@"showEventDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"showEventDetails"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        EventDetailViewController *vc = (EventDetailViewController*)[segue destinationViewController];
        NSLog(@"%ld",(long)indexPath.row);
        vc.textValue = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"img_src"]]];
        vc.imageValue = [UIImage imageWithData:imageData];
        vc.title = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
        
    }
}

@end
