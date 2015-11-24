//
//  MainViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *textDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [textDef stringForKey:@"phoneNumber"];
    if (phoneNumber) {
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.rightBarButtonItem = logoutButton;

    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                 @"password": @"e10adc3949ba59abbe56e057f20f883e",
                                 @"phoneNumber": @"89532021797"
                                 };
    [manager POST:@"http://31.131.24.188:8080/authUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
    
    
}

- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.navigationItem.rightBarButtonItem = nil;
}

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
