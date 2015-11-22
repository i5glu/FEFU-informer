//
//  mainViewController.m
//  FEFU
//
//  Created by Илья on 10.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()
@end

@implementation MainViewController

/*
- (void)viewDidAppear:(BOOL)animated{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss"
                                                          style: UIAlertActionStyleDefault
                                                        handler: ^(UIAlertAction *action) {
                                                            //[self performSegueWithIdentifier:@"showNews" sender:self];
                                                        }];
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
}
*/

- (IBAction)showNews:(id)sender{
    [self performSegueWithIdentifier: @"showNews" sender: sender];
}

@end
