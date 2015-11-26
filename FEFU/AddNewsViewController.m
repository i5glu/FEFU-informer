//
//  AddNewsViewController.m
//  FEFU
//
//  Created by Илья on 23.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "AddNewsViewController.h"
#import "AFNetworking.h"

@interface AddNewsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;
@property (weak, nonatomic) IBOutlet UISwitch *newsType;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UIButton *picturePicker;

@end

@implementation AddNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _picturePicker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_descriptionText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [_descriptionText.layer setBorderWidth:1.0];
    _descriptionText.layer.cornerRadius = 5;
    _descriptionText.clipsToBounds = YES;
    
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (IBAction)pickAvatar:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion: nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *picture = [info valueForKey: UIImagePickerControllerOriginalImage];
    _picture.image = picture;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)addNews:(id)sender {
    NSUserDefaults *phoneDef = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [phoneDef stringForKey:@"phoneNumber"];
    
    NSString *fileUpload;
    if (_picture.image) {
        fileUpload = [UIImagePNGRepresentation(_picture.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        fileUpload = @"nill";
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{
                                @"title"        : _titleField.text,
                                @"description"  : _descriptionText.text,
                                @"eventsStatus" : _newsType.on ? @"true" : @"false",
                                @"phoneNumber"  : phoneNumber,
                                @"fileUpload"   : fileUpload
                                };
    [manager POST:@"http://31.131.24.188:8080/additionEvents" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успех!" message:responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
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
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseObject[@"status"]);
            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:operation.responseObject[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                  style: UIAlertActionStyleDefault
                                                                handler: ^(UIAlertAction *action) {
                                                                }];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [alert addAction:alertAction];
                [self presentViewController:alert animated:YES completion:nil];
            });

        }];
        
}


@end
