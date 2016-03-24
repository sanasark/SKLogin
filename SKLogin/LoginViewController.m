//
//  LoginViewController.m
//  SKLogin
//
//  Created by User on 3/16/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLogin"];
    self.firstNameLabel.text = [[[[NSUserDefaults standardUserDefaults]
                                  objectForKey:@"usernamePasswords"]
                                 objectForKey:username]
                                objectForKey:@"firstName"];
    self.lastNameLabel.text = [[[[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"usernamePasswords"]
                                objectForKey:username]
                               objectForKey:@"lastName"];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
}

- (void)dealloc {
    
}

- (IBAction)signOutAction:(id)sender {
    MainViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"checkBoxIsOn"];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                    }
                    completion:nil];

}


@end
