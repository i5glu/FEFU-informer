//
//  CarTableViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "CarTableViewController.h"
#import "CarCell.h"
#import "AFNetworking.h"
#include <NSString+MD5.h>

@interface CarTableViewController ()

@end

@implementation CarTableViewController{
    NSArray *data;
    NSNumber *loadOffset;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    if (phoneNumber) {
        UIBarButtonItem *addCarRide = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCarRide)];
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.leftBarButtonItem = logoutButton;
        self.navigationItem.rightBarButtonItem = addCarRide;
    } else {
        UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
        self.navigationItem.leftBarButtonItem = loginButton;
    }
}

- (void)addCarRide{
    [self performSegueWithIdentifier:@"addCarRide" sender:self];
}

- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    self.navigationItem.leftBarButtonItem = loginButton;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)login{
    __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Вы уже с нами?"
                                                                           message:@""
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* registration = [UIAlertAction actionWithTitle:@"Нет, но хочу" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"registration" sender:self];
        });
    }];
    
    
    UIAlertAction* login = [UIAlertAction actionWithTitle:@"Да, сейчас войду" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        __block UIAlertController *loginAlert = [UIAlertController
                                                 alertControllerWithTitle:@"Вы уже с нами?"
                                                 message:@""
                                                 preferredStyle:UIAlertControllerStyleAlert];
        [loginAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Номер телефона";
        }];
        [loginAlert  addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Пароль";
            textField.secureTextEntry = YES;
        }];
        
        
        UIAlertAction* loginAction = [UIAlertAction actionWithTitle:@"Войти"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                
                                                                NSString *phoneNumber = loginAlert.textFields.firstObject.text;
                                                                NSString *password = [loginAlert.textFields.lastObject.text MD5Digest];
                                                                
                                                                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                                                                manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                                                                NSDictionary *parameters = @{
                                                                                             @"phoneNumber": phoneNumber,
                                                                                             @"password"   : password
                                                                                             };
                                                                [manager POST:@"http://31.131.24.188:8080/authUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                    UIBarButtonItem *addNews = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCarRide)];
                                                                    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
                                                                    self.navigationItem.leftBarButtonItem = logoutButton;
                                                                    self.navigationItem.rightBarButtonItem = addNews;
                                                                    [[NSUserDefaults standardUserDefaults] setObject:phoneNumber forKey:@"phoneNumber"];
                                                                    
                                                                    __block UIAlertController *successLoginAlert = [UIAlertController
                                                                                                                    alertControllerWithTitle:@"Мои поздравления"
                                                                                                                    message:responseObject[@"message"]
                                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                    }];
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                        [successLoginAlert addAction:defaultAction];
                                                                        [self presentViewController:successLoginAlert animated:YES completion:nil];
                                                                    });
                                                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                    __block UIAlertController *failLoginAlert = [UIAlertController
                                                                                                                 alertControllerWithTitle:@"Беда"
                                                                                                                 message:operation.responseObject[@"message"]
                                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                                                                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                    }];
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                        [failLoginAlert addAction:defaultAction];
                                                                        [self presentViewController:failLoginAlert animated:YES completion:nil];
                                                                    });
                                                                }];
                                                                
                                                            }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [loginAlert addAction:loginAction];
            [self presentViewController:loginAlert animated:YES completion:nil];
        });
        
    }];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Нет и не надо" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [alert addAction:login];
        [alert addAction:registration];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}




- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/drivingBidsList/0" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        loadOffset = @15;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CarCell";
    CarCell *cell = (CarCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.destination.text  = [[data objectAtIndex:indexPath.row] objectForKey:@"destination"];
    cell.departure.text = [[data objectAtIndex:indexPath.row] objectForKey:@"departure"];
    NSString *payment = [NSString stringWithFormat:@"%@", [[data objectAtIndex:indexPath.row] objectForKey:@"payment"]];
    cell.payment.text = payment;
    NSString *phoneNumber = [NSString stringWithFormat:@"%@", [[data objectAtIndex:indexPath.row] objectForKey:@"phone_number"]];
    cell.phoneNumber.text = [NSString stringWithFormat:@"8%@", phoneNumber];
    cell.note.text = [[data objectAtIndex:indexPath.row] objectForKey:@"note"];
    cell.note.editable = NO;
    cell.note.selectable = NO;
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = 50;
    if(y > h + reload_distance) {
        
        NSString *url = [NSString stringWithFormat:@"http://31.131.24.188:8080/drivingBidsList/%@", loadOffset];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            data = [data arrayByAddingObjectsFromArray:responseObject];
            [self.tableView reloadData];
            loadOffset = @([loadOffset intValue] + 15);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
}

@end
