//
//  UnofficialNewsViewController.m
//  FEFU
//
//  Created by Илья on 15.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "UnofficialNewsViewController.h"
#import "CellView.h"
#import "DetailsViewController.h"
#import "AFNetworking.h"


@implementation UnofficialNewsViewController{
    NSArray *data;
    NSNumber *newsLoadOffset;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/eventsList/0&u" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        newsLoadOffset = @5;
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
    CellView *cell = (CellView*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.header.lineBreakMode = NSLineBreakByWordWrapping;
    cell.content.editable = NO;
    
    cell.header.text  = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.content.text = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"img_src"]  ]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.picture.image = [UIImage imageWithData: imageData];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showDetails" sender:self];
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
        
        NSString *url = [NSString stringWithFormat:@"http://31.131.24.188:8080/eventsList/%@&u", newsLoadOffset];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            data = [data arrayByAddingObjectsFromArray:responseObject];
            [self.tableView reloadData];
            newsLoadOffset = @([newsLoadOffset intValue] + 5);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"showDetails"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        DetailsViewController *vc = (DetailsViewController*)[segue destinationViewController];
        vc.contentValue = [[data objectAtIndex:indexPath.row] objectForKey:@"description"];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"img_src"]]];
        vc.pictureValue = [UIImage imageWithData:imageData];
        vc.title = [[data objectAtIndex:indexPath.row] objectForKey:@"title"];
    }
}

@end
