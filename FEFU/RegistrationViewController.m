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


@implementation RegistrationViewController



- (NSString *) md5:(NSString *) input{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSString *)base64String:(UIImage *)image {
    NSData * data = [UIImagePNGRepresentation(image) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [NSString stringWithUTF8String:[data bytes]];
}


- (IBAction)pickAvatar:(id)sender {
    UIImagePickerController *avatarPicker = [[UIImagePickerController alloc]init];
    avatarPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    avatarPicker.delegate = self;
    [self presentViewController:avatarPicker animated:NO completion: nil];
}

- (IBAction)confirm:(id)sender {
    NSString *password = [self md5:_password.text];
    
    NSURL *URL = [NSURL URLWithString:@"http://31.131.24.188:8080/registrationUsers"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *stringForHTTPBody = [NSString stringWithFormat:@"{\n  \"firstName\": \"%@\",\n  \"lastName\": \"%@\",\n  \"fileUpload\": null,\n  \"phoneNumber\": \"%@\",\n  \"password\": \"%@\"\n}", _firstName.text, _lastName.text, _phoneNumber.text, password];
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
                                                                                                  [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                              }];
                                          dispatch_async(dispatch_get_main_queue(), ^(void){
                                              [alert addAction:alertAction];
                                              [self presentViewController:alert animated:YES completion:nil];
                                          });
                                          return;
                                      }
                                      
                              
                                      
                                      
                                      
                                      
                                      NSString* body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                      
                                      if (httpResponse.statusCode == 200) {
                                          NSString *phoneCode = [body substringWithRange:NSMakeRange(60, 4)];
                                          NSURL *URL = [NSURL URLWithString:@"http://31.131.24.188:8080/validationUsers"];
                                          NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
                                          [request setHTTPMethod:@"POST"];
                                          [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                                          NSString *stringForHTTPBody = [NSString stringWithFormat:
                                                                         @"{\n  \"phoneNumber\": \"%@\",\n  \"phoneCode\": \"%@\"\n}", _phoneNumber.text, phoneCode];
                                          
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
                                                                                                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                                                    }];
                                                                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                                    [alert addAction:alertAction];
                                                                                    [self presentViewController:alert animated:YES completion:nil];
                                                                                });
                                                                                
                                                                                return;
                                                                            }
                                                                            
                                                                            __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успех!" message:@"Поздравляем, теперь вы один из нас" preferredStyle:UIAlertControllerStyleAlert];
                                                                            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                                                                                                  style: UIAlertActionStyleDefault
                                                                                                                                handler: ^(UIAlertAction *action) {
                                                                                                                                    [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber.text forKey:@"phoneNumber"];
                                                                                                                                    dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                                                                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                                                                    });
                                                                                                                                    
                                                                                                                                }];
                                                                            
                                                                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                                                                [alert addAction:alertAction];
                                                                                [self presentViewController:alert animated:YES completion:nil];
                                                                            });
                                                                            
                                                                            
                                                                        }];
                                          [task resume];
                                          
                                      }
                                      
                                  }];
    [task resume];
    
    
    
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
