//
//  RegistrationViewController.m
//  FEFU
//
//  Created by Илья on 19.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#include <NSString+MD5.h>

@implementation RegistrationViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    _password.secureTextEntry = YES;
    [self.tabBarController.tabBar setHidden:YES];
}


- (IBAction)pickAvatar:(id)sender {
    UIImagePickerController *avatarPicker = [[UIImagePickerController alloc]init];
    avatarPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    avatarPicker.delegate = self;
    [self presentViewController:avatarPicker animated:NO completion: nil];
}

- (IBAction)confirm:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSString *password = [_password.text MD5Digest];
    NSString *fileUpload;
    if (_avatarView.image) {
        fileUpload = [UIImagePNGRepresentation(_avatarView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        fileUpload = @"nill";
    }

    
    
    NSDictionary *parameters = @{
                                 @"firstName"   : _firstName.text,
                                 @"lastName"    : _lastName.text,
                                 @"phoneNumber" : _phoneNumber.text,
                                 @"password"    : password,
                                 @"fileUpload"  : fileUpload
                                 };
    
    [manager POST:@"http://31.131.24.188:8080/registrationUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{
                                     @"phoneNumber": _phoneNumber.text,
                                     @"phoneCode"  : responseObject[@"phoneCode"]
                                     };
        [manager POST:@"http://31.131.24.188:8080/validationUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber.text forKey:@"phoneNumber"];
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Мои поздравления"
                                                                                   message:responseObject[@"message"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Беда"
                                                                                   message:operation.responseObject[@"message"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *tryLater = [UIAlertAction actionWithTitle:@"Попробую позже" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }];
            
            UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Попробую ещё раз" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alert addAction:tryAgain];
                [alert addAction:tryLater];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Беда"
                                                                               message:operation.responseObject[@"message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *tryLater = [UIAlertAction actionWithTitle:@"Попробую позже" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }];
        
        UIAlertAction *tryAgain = [UIAlertAction actionWithTitle:@"Попробую ещё раз" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert addAction:tryAgain];
            [alert addAction:tryLater];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *avatar = [info valueForKey: UIImagePickerControllerOriginalImage];
    self.avatarView.image = avatar;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
