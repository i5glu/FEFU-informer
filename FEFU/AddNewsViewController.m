//
//  AddNewsViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "AddNewsViewController.h"

@interface AddNewsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UISwitch *newsType;

@end

@implementation AddNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)addNews:(id)sender {
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    
    if (phoneNumber) {
        
        NSURL *URL = [NSURL URLWithString:@"http://31.131.24.188:8080/additionEvents"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        NSString *stringForHTTPBody = [NSString stringWithFormat:@"{\n  \"title\": \"%@\",\n  \"description\": \"%@\",\n  \"officialParam\": \"%@\",\n  \"phoneNumber\": \"%@\",\n  \"fileUpload\": null\n}", _titleField.text, _descriptionText.text, _newsType.on ? @"true" : @"flase", phoneNumber];
        [request setHTTPBody:[stringForHTTPBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:
                                      ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          if (error) {
                                              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Что-то пошло не так(( попробуйте пожалуйста позже" preferredStyle:UIAlertControllerStyleAlert];
                                              UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                    style: UIAlertActionStyleDefault
                                                                                                  handler: ^(UIAlertAction *action) {
                                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                  }];
                                              [alert addAction:alertAction];
                                              [self presentViewController:alert animated:YES completion:nil];
                                              return;
                                        }
                                          
                                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Все хорошо" message:@"Мои поздравления. Новость добавлена" preferredStyle:UIAlertControllerStyleAlert];
                                          UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                style: UIAlertActionStyleDefault
                                                                                              handler: ^(UIAlertAction *action) {
                                                                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                              }];
                                          [alert addAction:alertAction];
                                          [self presentViewController:alert animated:YES completion:nil];
                                          
                                      }];
        [task resume];
        
        
    } else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка!" message:@"Сначала придется зарегестрироваться" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                            }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];

        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
