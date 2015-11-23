//
//  LoginViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController


- (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}


- (IBAction)confirmLogin:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"http://31.131.24.188:8080/authUsers"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString *password = [self md5:_passwordField.text];
    
    NSString *stringForHTTPBody = [NSString stringWithFormat:@"{\n  \"phoneNumber\": \"%@\",\n  \"password\": \"%@\"\n}",
                                   _phoneNumberField.text,
                                   password
                                   ];
    [request setHTTPBody:[@"{\n  \"phoneNumber\": \"89242336096\",\n  \"password\": \"a75cc07b5d22e6f71a02ceedf3a25ede\"\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      if (error) {
                                          // Handle error...
                                          return;
                                      }
                                      
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      if (httpResponse.statusCode == 200) {
                                          [[NSUserDefaults standardUserDefaults] setObject:_phoneNumberField.text forKey:@"phoneNumber"];
                                          
                                          __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успех!" message:@"Поздравляем, вы вошли" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                style: UIAlertActionStyleDefault
                                                                                              handler: ^(UIAlertAction *action) {
                                                                                                  dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                  });
                                                                                                  
                                                                                              }];
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^(void){
                                              [alert addAction:alertAction];
                                              [self presentViewController:alert animated:YES completion:nil];
                                          });

                                          
                                          
                                      }
                                  }];
    [task resume];
}



@end
