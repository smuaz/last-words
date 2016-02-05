//
//  LoginViewController.m
//  LastWords
//
//  Created by Syed Muaz on 8/24/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *signinView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *signupView;
@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordSignUpTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *introScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bullet1;
@property (weak, nonatomic) IBOutlet UIImageView *bullet2;
@property (weak, nonatomic) IBOutlet UIImageView *bullet3;
@property (weak, nonatomic) IBOutlet UIImageView *bullet4;


- (void)transitionType:(NSString *)type direction:(NSString *)direction duration:(CFTimeInterval)time for:(CALayer *)layer;
- (void)fadeAnim:(UIView *)object duration:(NSTimeInterval)time alpha:(float)alpha;
- (void)slideAnim:(UIView *)object duration:(NSTimeInterval)time alpha:(float)alpha positionX:(int)intX positionY:(int)intY;


- (IBAction)signIn:(id)sender;
- (IBAction)signUp:(id)sender;

- (IBAction)goLogin:(id)sender;
- (IBAction)goSignUp:(id)sender;
@end

@implementation LoginViewController

- (void)transitionType:(NSString *)type direction:(NSString *)direction duration:(CFTimeInterval)time for:(CALayer *)layer
{
    CATransition *transition1 = [CATransition animation];
    transition1.duration = time;
    transition1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition1.type = type;
    transition1.subtype = direction;
    [layer addAnimation:transition1 forKey:nil];
}

-(void)fadeAnim:(UIView *)object duration:(NSTimeInterval)time alpha:(float)alpha
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:time];
    
    [object setAlpha:alpha];
    
    [UIView commitAnimations];
    
    
}

-(void)slideAnim:(UIView *)object duration:(NSTimeInterval)time alpha:(float)alpha positionX:(int)intX positionY:(int)intY
{
    [object setAlpha:alpha];
    
    CGRect frame = object.frame;
    frame.origin.x = intX;
    frame.origin.y = intY;
    
    [UIView beginAnimations:nil context:nil];
    
    object.frame = frame;
    
    [UIView commitAnimations];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Perform desired outcome here.
    //NSLog(@"scrollViewDidEndDragging");
    if (scrollView.contentOffset.x == 0) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet4 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 320) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet4 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 640) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet4 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 960) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet4 setImage:[UIImage imageNamed:@"bulletenable.png"]];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self slideAnim:self.signinView duration:2.0 alpha:1.0 positionX:0 positionY:168];
    
    return YES;
}

- (IBAction)signIn:(id)sender {
    [self slideAnim:self.signinView duration:2.0 alpha:1.0 positionX:0 positionY:378];

}

- (IBAction)signUp:(id)sender {
    [self slideAnim:self.signupView duration:2.0 alpha:1.0 positionX:0 positionY:296];

}

- (IBAction)goLogin:(id)sender {
    if ([self.emailTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Email Field Empty"
                              message: @"Please enter your email."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([self.passwordTextField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Password Field Empty"
                              message: @"Please enter your password."
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading";
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            
            [PFUser logInWithUsernameInBackground:self.emailTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
                if (user) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    });
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } else {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }
            }];


        });
        
        
    }

}

- (IBAction)goSignUp:(id)sender {
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.view setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSignInView:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [self.introScrollView setContentSize:CGSizeMake(1280, 568)];
    [self.introScrollView setPagingEnabled:YES];
    
    UIColor *color = [UIColor whiteColor];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _fullnameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Full Name" attributes:@{NSForegroundColorAttributeName: color}];
    _emailSignUpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordSignUpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordConfirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];


    
}

- (void)hideSignInView:(UITapGestureRecognizer*)Sender
{
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self slideAnim:self.signinView duration:2.0 alpha:1.0 positionX:0 positionY:568];
    [self slideAnim:self.signupView duration:2.0 alpha:1.0 positionX:0 positionY:568];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
