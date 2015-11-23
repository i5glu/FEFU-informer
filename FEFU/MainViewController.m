//
//  MainViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
- (IBAction)accountSeguePerform:(id)sender {
    NSUserDefaults *textDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [textDef stringForKey:@"phoneNumber"];
    if (phoneNumber) {
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Не надо" message:@"Вы уже зарегестрированы" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }  else{
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Действие" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *registerAction = [UIAlertAction actionWithTitle: @"Зарегестироваться"
                                                              style: UIAlertActionStyleDefault
                                                               handler: ^(UIAlertAction *action) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                       [self performSegueWithIdentifier:@"register" sender:self];
                                                                   });
                                                            }];
        UIAlertAction *loginAction = [UIAlertAction actionWithTitle: @"Войти"
                                                             style: UIAlertActionStyleDefault
                                                           handler: ^(UIAlertAction *action) {
                                                               dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                   [self performSegueWithIdentifier:@"login" sender:self];
                                                               });
                                                           }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert addAction:registerAction];
            [alert addAction:loginAction];
            [self presentViewController:alert animated:YES completion:nil];
        });

    }

}


@end
