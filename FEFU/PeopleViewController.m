//
//  PeopleViewController.m
//  FEFU
//
//  Created by Илья on 15.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "PeopleViewController.h"
#import "AFNetworking.h"
#import "DetailsViewController.h"

@implementation PeopleViewController{
    NSArray *data;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/allUsersInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    NSString *firstName = [[data objectAtIndex:indexPath.row] objectForKey:@"first_name"];
    NSString *secondName = [[data objectAtIndex:indexPath.row] objectForKey:@"last_name"];
    NSString *fullName = [[firstName stringByAppendingString:@" "] stringByAppendingString:secondName];
    cell.textLabel.text = fullName;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"avatar_src"]  ]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData: imageData];
            [cell setNeedsLayout];
        });
    });
    return cell;
}

@end
