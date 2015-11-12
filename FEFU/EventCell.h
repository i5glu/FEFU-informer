//
//  EventCell.h
//  FEFU
//
//  Created by Илья on 10.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *header;
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, weak) IBOutlet UIImageView *image;

@end
