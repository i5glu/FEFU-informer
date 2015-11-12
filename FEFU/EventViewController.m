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

@implementation EventViewController{
    NSArray *data;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    data = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"EventCell";
    EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.header.text  = [data objectAtIndex:indexPath.row];
    cell.text.text = [data objectAtIndex:indexPath.row];
    cell.image.image = [UIImage imageNamed:@"AboutIcon"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showEventDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"showEventDetails"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        EventDetailViewController *vc = (EventDetailViewController*)[segue destinationViewController];
        
        vc.textValue = [data objectAtIndex:indexPath.row];
        vc.imageValue = [UIImage imageNamed:@"AboutIcon"];
        vc.title = [data objectAtIndex:indexPath.row];
    }
}

@end
