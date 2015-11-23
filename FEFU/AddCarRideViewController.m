//
//  AddCarRideViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "AddCarRideViewController.h"

@interface AddCarRideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UITextField *departure;
@property (weak, nonatomic) IBOutlet UITextField *payment;
@property (weak, nonatomic) IBOutlet UITextView *note;

@end

@implementation AddCarRideViewController
- (IBAction)addCarRide:(id)sender {
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    if (phoneNumber){
        
        NSURL *URL = [NSURL URLWithString:@"http://31.131.24.188:8080/additionDrivingBid"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSString *stringForHTTPBody = [NSString stringWithFormat:@"{\n  \"destination\": \"%@\",\n  \"departure\": \"%@\",\n  \"payment\": \"%@\",\n  \"note\": \"%@\",\n  \"phoneNumber\": \"%@\"\n}", _destination.text, _departure.text, _payment.text, _note.text, phoneNumber];
        
        [request setHTTPBody:[stringForHTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          if (error) {
                                              __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Что-то пошло не так(( попробуйте пожалуйста позже" preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                    style: UIAlertActionStyleDefault
                                                                                                  handler: ^(UIAlertAction *action) {
                                                                                                  }];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^(void){
                                                  [alert addAction:alertAction];
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              });
                                              return;
                                          }
                                          
                                          __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Все ок" message:@"Скоро кто-нибудь вас подкинет" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                style: UIAlertActionStyleDefault
                                                                                              handler: ^(UIAlertAction *action) {
                                                                                              }];
                                          dispatch_async(dispatch_get_main_queue(), ^(void){
                                              [alert addAction:alertAction];
                                              [self presentViewController:alert animated:YES completion:nil];
                                          });
                                      }];
        [task resume];
        
    }else{
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:@"Сначала придется зарегестрироваться" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];

        });
    }

    
}
@end
