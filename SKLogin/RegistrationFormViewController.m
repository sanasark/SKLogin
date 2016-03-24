//
//  RegistrationFormViewController.m
//  SKLogin
//
//  Created by User on 3/16/16.
//  Copyright © 2016 ACA. All rights reserved.
//

#import "RegistrationFormViewController.h"
#import "regTableViewCell.h"

@interface RegistrationFormViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableArray *userInfo;


@end


@implementation RegistrationFormViewController

- (void)viewDidLoad {
    self.userInfo = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<7; i++) {
        NSString *temp = @"";
        [self.userInfo addObject:temp];
    }
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.allowsSelection = NO;
    NSMutableAttributedString *user = [[NSMutableAttributedString alloc] initWithString:@"Username *"];
    [user addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, 1)];
    NSMutableAttributedString *password = [[NSMutableAttributedString alloc] initWithString:@"Password *"];
    [password addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9, 1)];
    NSMutableAttributedString *conPassword = [[NSMutableAttributedString alloc] initWithString:@"Conform Password *"];
    [conPassword addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(17, 1)];
    NSAttributedString *firstName = [[NSAttributedString alloc] initWithString:@"First Name"];
    NSAttributedString *lastName = [[NSAttributedString alloc] initWithString:@"Last Name"];
    NSAttributedString *gender = [[NSAttributedString alloc] initWithString:@"Gender"];
    NSAttributedString *email = [[NSAttributedString alloc] initWithString:@"E-mail"];
    self.keys = @[ user, password, conPassword,firstName, lastName, gender , email];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissKeyboard {
    NSIndexPath *temp;
    for (NSInteger i=0; i<7; i++) {
        temp = [NSIndexPath indexPathForRow:i inSection:0];
        regTableViewCell *temp2 = [self.mainTableView cellForRowAtIndexPath:temp] ;
        [temp2.regTextField resignFirstResponder];
    };
}


- (IBAction)submitAction:(id)sender {
    [self submit];

}



- (void)submit {
    if ((![self.userInfo[0] isEqualToString:@""]) &&
        (![self.userInfo[1] isEqualToString:@""]) &&
        (![self.userInfo[2] isEqualToString:@""])) {
        if ([self.userInfo[1] isEqualToString:self.userInfo[2]]) {
            NSMutableDictionary *usernamePasswords = [[[NSUserDefaults standardUserDefaults]
                                                       objectForKey:@"usernamePasswords"] mutableCopy];
            NSDictionary *userInfo = [self arrayToDictionarry];
            __block BOOL userNameIsExist = NO;
            [usernamePasswords enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:[userInfo objectForKey:@"username"]]) {
                    *stop = YES;
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username already exist" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [ac addAction:okAction];
                    [self presentViewController:ac animated:YES completion:nil];
                    userNameIsExist = YES;
                }
            }];
            if (!userNameIsExist) {
                if (usernamePasswords == nil) {
                    NSDictionary *usernamePasswords = @{  [userInfo objectForKey:@"username"] : userInfo };
                    [[NSUserDefaults standardUserDefaults] setObject:usernamePasswords forKey:@"usernamePasswords"];
                } else {
                    [usernamePasswords setObject:userInfo forKey:[userInfo objectForKey:@"username"]];
                    [[NSUserDefaults standardUserDefaults] setObject:[usernamePasswords copy] forKey:@"usernamePasswords"];
                    
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"password doesn't match confirmation" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [ac addAction:okAction];
            [self presentViewController:ac animated:YES completion:nil];
        }
    } else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"Fill the required fields" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [ac addAction:okAction];
        [self presentViewController:ac animated:YES completion:nil];
    }

}



- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary *)arrayToDictionarry {
    NSDictionary *temp = @{ @"username" : self.userInfo[0],
                                   @"password" : self.userInfo[1],
                                   @"firstName" : self.userInfo[3],
                                   @"lastName" : self.userInfo[4],
                                   @"gender" : self.userInfo[5],
                                   @"email" : self.userInfo[6]
                                   };
    return temp;
}


#pragma mark textField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;
    
    if (nextTag == 7) {
        [self submit];
    } else {
        if (![self cellIsVisible:nextTag]) {
            [self.mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:nextTag inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
        UIResponder* nextResponder = [textField.superview.superview.superview viewWithTag:nextTag];
        [nextResponder becomeFirstResponder];
    }
    return NO;
}


- (BOOL)cellIsVisible:(NSInteger)cellTag {
    for (NSIndexPath *index in [self.mainTableView indexPathsForVisibleRows]) {
        if (index.row == cellTag) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *temp = [NSString stringWithFormat:@"%@%@", textField.text, string];
    self.userInfo[textField.tag] = temp;
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}


#pragma mark Header Footer cells

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectZero];
    header.text = @"Registration";
    header.textAlignment = NSTextAlignmentCenter;
    [header sizeToFit];
    return header;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectZero];
    NSMutableAttributedString *footertext = [[NSMutableAttributedString alloc] initWithString:@"* - required"];
    [footertext addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    footer.attributedText = footertext;
    footer.textAlignment = NSTextAlignmentCenter;
    [footer sizeToFit];
    return footer;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    regTableViewCell *cell = nil;
    if (indexPath.row == 1 || indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"regSecureCell" forIndexPath:indexPath];
    } else if (indexPath.row == 3 || indexPath.row == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"capitalLetterCell" forIndexPath:indexPath];
    } else if (indexPath.row == 6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"email" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"regCell" forIndexPath:indexPath];
    }
    cell.keyLabel.attributedText = self.keys[indexPath.row];
    cell.regTextField.tag = indexPath.row;
    cell.regTextField.delegate = self;
    cell.regTextField.text = self.userInfo[indexPath.row];
    return cell;
}



#pragma mark keyboard


- (void)handleKeyboardWillShow:(NSNotification *)sender {
    
    CGRect rect = [[sender.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    self.bottomConst.constant = rect.size.height;
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)handleKeyboardWillHide:(NSNotification *)sender {
    self.bottomConst.constant = 0;
    [UIView animateWithDuration:[sender.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]  animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

@end


