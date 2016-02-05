//
//  MessagesViewController.m
//  LastWords
//
//  Created by Syed Muaz on 8/25/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import "MessagesViewController.h"
#import "RecipientViewController.h"

@interface MessagesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;

- (IBAction)goBack:(id)sender;
- (IBAction)confirmMessage:(id)sender;
@end

@implementation MessagesViewController

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
    [self.messageTextView setUserInteractionEnabled:YES];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"messages"];

    
    UISwipeGestureRecognizer *downSwipeOnScreen = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownOnScreen:)];
    downSwipeOnScreen.direction = UISwipeGestureRecognizerDirectionDown;
    downSwipeOnScreen.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:downSwipeOnScreen];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView:)];
    tap.numberOfTapsRequired = 1;
    //tap.cancelsTouchesInView = NO;

    [self.view addGestureRecognizer:tap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";

    return YES;
}

- (void)hideView:(UITapGestureRecognizer*)Sender
{
    //[self.messageTextView resignFirstResponder];
    //[Sender setCancelsTouchesInView:NO];
    [self.view endEditing:YES];
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

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmMessage:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.messageTextView.text forKey:@"messages"];
    
    RecipientViewController *vc = [[RecipientViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc = nil;


    
}
@end
