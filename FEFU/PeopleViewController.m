//
//  PeopleViewController.m
//  FEFU
//
//  Created by Илья on 15.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "PeopleViewController.h"
#import "AFNetworking.h"
#import "AvatarViewController.h"
#include <NSString+MD5.h>

@implementation PeopleViewController{
    NSArray *data;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    if (phoneNumber) {
        UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
        self.navigationItem.leftBarButtonItem = logoutButton;
    } else {
        UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
        self.navigationItem.leftBarButtonItem = loginButton;
    }
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
                                                                    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Выйти" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
                                                                    self.navigationItem.leftBarButtonItem = logoutButton;
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


- (void)viewDidLoad{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestData)
                  forControlEvents:UIControlEventValueChanged];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/allUsersInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        data = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)getLatestData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://31.131.24.188:8080/allUsersInfo" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.refreshControl endRefreshing];
        data = responseObject;
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *firstName = [[data objectAtIndex:indexPath.row] objectForKey:@"first_name"];
    NSString *secondName = [[data objectAtIndex:indexPath.row] objectForKey:@"last_name"];
    NSString *fullName = [[firstName stringByAppendingString:@" "] stringByAppendingString:secondName];
    cell.textLabel.text = fullName;
    NSLog(@"%@", [[data objectAtIndex:indexPath.row] objectForKey:@"avatar_src"]);
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"avatar_src"]  ]];
        if ( imageData == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData: imageData];
            [cell setNeedsLayout];
        });
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"showAvatar" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier  isEqual: @"showAvatar"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        AvatarViewController *vc = (AvatarViewController*)[segue destinationViewController];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[data objectAtIndex:indexPath.row] objectForKey:@"avatar_src"]]];
        vc.pictureValue = [UIImage imageWithData:imageData];
        NSString *firstName = [[data objectAtIndex:indexPath.row] objectForKey:@"first_name"];
        NSString *secondName = [[data objectAtIndex:indexPath.row] objectForKey:@"last_name"];
        NSString *fullName = [[firstName stringByAppendingString:@" "] stringByAppendingString:secondName];
        vc.title = fullName;
    }
}



@end
