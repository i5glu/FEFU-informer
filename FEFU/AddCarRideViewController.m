//
//  AddCarRideViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "AddCarRideViewController.h"
#import "AFNetworking.h"

@interface AddCarRideViewController ()
@property (weak, nonatomic) IBOutlet UITextField *destination;
@property (weak, nonatomic) IBOutlet UITextField *departure;
@property (weak, nonatomic) IBOutlet UITextField *payment;
@property (weak, nonatomic) IBOutlet UITextView  *note;
@end

@implementation AddCarRideViewController

- (void)viewDidLoad{
    [self.tabBarController.tabBar setHidden:YES];
    [_note.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_note.layer setBorderWidth:1.0];
    _note.layer.cornerRadius = 5;
    _note.clipsToBounds = YES;
    
}

- (IBAction)addCarRide:(id)sender {
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    if (phoneNumber){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSDictionary *parameters = @{
                                     @"phoneNumber": phoneNumber,
                                     @"destination": _destination.text,
                                     @"departure"  : _departure.text,
                                     @"payment"    : _payment.text,
                                     @"note"       : _note.text
                                     };
        [manager POST:@"http://31.131.24.188:8080/additionDrivingBid" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успех!" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                  style: UIAlertActionStyleDefault
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
            });

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Беда!" message:operation.responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                  style: UIAlertActionStyleDefault
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
            });

            
        }];
                
    }else{
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:@"Сначала придется зарегестрироваться или войти" preferredStyle:UIAlertControllerStyleAlert];
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
