//
//  RecipientViewController.m
//  LastWords
//
//  Created by Syed Muaz on 8/25/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import "RecipientViewController.h"
#import "MBProgressHUD.h"

@interface RecipientViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *dateScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *bullet1;
@property (weak, nonatomic) IBOutlet UIImageView *bullet2;
@property (weak, nonatomic) IBOutlet UIView *specificView;
@property (weak, nonatomic) IBOutlet UIView *afterdeathView;
@property (weak, nonatomic) IBOutlet UITextField *daySpecView;
@property (weak, nonatomic) IBOutlet UITextField *monthSpecTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearSpecTextField;
@property (weak, nonatomic) IBOutlet UITextField *afterdeathDayTextField;

- (IBAction)goConfirm:(id)sender;
- (IBAction)close:(id)sender;
@end

@implementation RecipientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *color = [UIColor whiteColor];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    [self.dateScrollView setContentSize:CGSizeMake(940, 148)];
    [self.dateScrollView setPagingEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboardView:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    /*
    UISwipeGestureRecognizer *downSwipeOnScreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownOnScreen:)];
    downSwipeOnScreen.direction = UISwipeGestureRecognizerDirectionDown;
    downSwipeOnScreen.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:downSwipeOnScreen];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
	recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:recognizer];
     */
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Perform desired outcome here.
    //NSLog(@"scrollViewDidEndDragging");
    if (scrollView.contentOffset.x == 0) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 320) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletenable.png"]];
    }
    
}

- (void)hideKeyboardView:(UITapGestureRecognizer*)Sender
{
    [self.emailTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.daySpecView resignFirstResponder];
    [self.monthSpecTextField resignFirstResponder];
    [self.yearSpecTextField resignFirstResponder];
    [self.afterdeathDayTextField resignFirstResponder];

}

- (void)goBack:(UISwipeGestureRecognizer*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeDownOnScreen:(UISwipeGestureRecognizer*)Sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goConfirm:(id)sender {
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    PFObject *contact = [PFObject objectWithClassName:@"Contact"];
    [contact setObject:self.nameTextField.text forKey:@"name"];
    [contact setObject:self.emailTextField.text forKey:@"email"];
    
    [contact saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
            if (!error) {
                NSLog(@"Contact updated");
                PFObject *item = [PFObject objectWithClassName:@"Item"];
                [item setObject:contact forKey:@"ContactBy"];
                [item setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] forKey:@"messages"];
                [item setObject:@"message" forKey:@"category"];
                
                [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"Item updated");
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"new" forKey:@"messages"];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        [errorAlertView show];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];

                    }
                }];
                
                //[self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }


        
    }];

}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


@end
