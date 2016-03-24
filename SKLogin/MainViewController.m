//
//  MainViewController.m
//  SKLogin
//
//  Created by User on 3/15/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "MainViewController.h"
#import "RegistrationFormViewController.h"
#import "LoginViewController.h"

@interface MainViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (nonatomic, assign) BOOL checkBoxIsOn;
@property (weak, nonatomic) IBOutlet UIView *secondView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constMiddle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constBottom;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UILabel *logo;


//@property (nonatomic, strong) NSDictionary *aaa;

@end


@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UIImage *image = [UIImage imageNamed:@"checkbox-unchecked-md"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"checkBoxIsOn"];
    self.checkBoxIsOn = NO;
    [self.checkButton setImage:image forState:UIControlStateNormal];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastLogin"] != nil) {
        self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLogin"];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
   
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissKeyboard {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}


- (IBAction)registerAction:(id)sender {
    [self performSegueWithIdentifier:@"registrationForm" sender:nil];
}

- (IBAction)checkBoxAction:(id)sender {
    UIImage *image = nil;
    if (self.checkBoxIsOn) {
        self.checkBoxIsOn = NO;
        image = [UIImage imageNamed:@"checkbox-unchecked-md"];
    } else {
        self.checkBoxIsOn = YES;
        image = [UIImage imageNamed:@"nxt-checkbox-checked-ok-md"];
    }
    [self.checkButton setImage:image forState:UIControlStateNormal];

}

- (IBAction)loginAction:(id)sender {
    [self login];
}


- (void)login {
    if ([self.userNameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Fill the username and password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        NSDictionary *usernamePasswords = [[NSUserDefaults standardUserDefaults] objectForKey:@"usernamePasswords"];
        __block BOOL passwordIsWrong = NO;
        __block BOOL logined = NO;
        if ([usernamePasswords count] != 0) {
            [usernamePasswords enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
                if ([key isEqualToString:self.userNameTextField.text]) {
                    *stop = YES;
                    if ([[obj objectForKey:@"password"] isEqualToString:self.passwordTextField.text]) {
                        [[NSUserDefaults standardUserDefaults] setObject:self.userNameTextField.text forKey:@"lastLogin"];
                        if (self.checkBoxIsOn) {
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"checkBoxIsOn"];
                        }
                        LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"loginForm"];
                        [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                                          duration:0.5
                                           options:UIViewAnimationOptionTransitionFlipFromLeft
                                        animations:^{
                                            [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                                        }
                                        completion:nil];
                        logined = YES;
                    } else {
                        passwordIsWrong = YES;
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid password" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [ac addAction:okAction];
                        [self presentViewController:ac animated:YES completion:nil];
                    }
                }
            }];
            if (!passwordIsWrong && !logined) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid Username" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [ac addAction:okAction];
                [self presentViewController:ac animated:YES completion:nil];
            }
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Invalid Username" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
            
        }
    }

    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.userNameTextField]) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    } else {
        [self login];
        return YES;
    }
}



#pragma mark keyboard


- (void)handleKeyboardWillShow:(NSNotification *)sender {
    CGFloat bottom = self.view.frame.size.height / 2.0 - 101;
    CGRect rect = [[sender.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    if (rect.size.height > bottom) {
        self.constMiddle.active = NO;
        self.constBottom.active = YES;
        self.constBottom.constant = rect.size.height;
    }
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]  animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)handleKeyboardWillHide:(NSNotification *)sender {
    self.constBottom.active = NO;
    self.constMiddle.active = YES;
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


@end
