//
//  CarCell.h
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *destination;
@property (weak, nonatomic) IBOutlet UILabel *departure;
@property (weak, nonatomic) IBOutlet UILabel *payment;
@property (weak, nonatomic) IBOutlet UITextView *note;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;

@end
