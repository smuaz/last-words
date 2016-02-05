//
//  HomeViewController.m
//  LastWords
//
//  Created by Syed Muaz on 8/24/14.
//  Copyright (c) 2014 team41. All rights reserved.
//

#import "HomeViewController.h"
#import "MessagesViewController.h"
#import "ContactTableViewCell.h"
#import "Contact.h"
#import "ODRefreshControl.h"
#import "MBProgressHUD.h"
#import <RestKit/RestKit.h>
#import <RestKit.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
@property (weak, nonatomic) IBOutlet UIView *pickView;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIView *contactView;
@property (weak, nonatomic) IBOutlet UIImageView *bullet1;
@property (weak, nonatomic) IBOutlet UIImageView *bullet2;
@property (weak, nonatomic) IBOutlet UIImageView *bullet3;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITableView *contactTableView;
@property (strong, nonatomic) NSMutableArray *contactArray;
@property (strong, nonatomic) ODRefreshControl *refreshControl;

- (IBAction)goLogout:(id)sender;
- (IBAction)goHelp:(id)sender;
- (IBAction)goTextMessage:(id)sender;
- (IBAction)goPhoto:(id)sender;
- (IBAction)goVideo:(id)sender;
- (IBAction)goAudio:(id)sender;

@end

@implementation HomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        
        // Customize the Log In View Controller
        LoginViewController *logInViewController = [[LoginViewController alloc] init];
        [self presentViewController:logInViewController animated:NO completion:nil];
        logInViewController = nil;
 
    } else {

        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateProfile) userInfo:nil repeats:NO];
        

    }
    
    [self.homeScrollView setContentSize:CGSizeMake(960, 568)];
    [self.homeScrollView setPagingEnabled:YES];
    [self.homeScrollView setContentOffset:CGPointMake(320, 0)];
    
    [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    [_bullet2 setImage:[UIImage imageNamed:@"bulletenable.png"]];
    [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] isEqualToString:@"new"]) {
        [self refreshContact:self];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"messages"];

    }
    
    
}

-(void)updateProfile
{
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        PFQuery *query = [PFUser query];
        //PFUser *userAgain = (PFUser *)[query getObjectWithId:currentUser.objectId];
        
        [query getObjectInBackgroundWithId:currentUser.objectId block:^(PFObject *object, NSError *error) {
            if (!error) {
                // The get request succeeded. Log the score
                self.fullNameLabel.text = [currentUser objectForKey:@"fullName"];
                self.emailLabel.text = [currentUser objectForKey:@"email"];
                NSLog(@"full name is: %@",self.fullNameLabel.text);
                [self.fullNameLabel setNeedsDisplay];
                [self.emailLabel setNeedsDisplay];
                
            } else {
                // Log details of our failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTableViewCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ContactTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    
    Contact *entry = [self.contactArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = entry.name;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //[formatter setDateFormat:@"hh:mm a"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    //[formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //cell.dateLabel.text = [formatter stringFromDate:entry.sessionDate];
    
    
    // Configure the cell.
    //cell.textLabel.text = [(Session *)[self.sessionArray objectAtIndex:indexPath.row] sessionName];
    //NSLog(@"date: %@",[(Session *)[self.sessionArray objectAtIndex:indexPath.row] sessionDate]);
    if (indexPath.row == 0) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:196.0/255.0 green:156.0/255.0 blue:106.0/255.0 alpha:1];
    }
    else if (indexPath.row == 1) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:27.0/255.0 green:64.0/255.0 blue:86.0/255.0 alpha:1];
    }
    else if (indexPath.row == 2) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:221.0/255.0 green:106.0/255.0 blue:130.0/255.0 alpha:1];
    }
    else if (indexPath.row == 3) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:147.0/255.0 green:112.0/255.0 blue:132.0/255.0 alpha:1];
    }
    else if (indexPath.row == 4) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:208.0/255.0 green:205.0/255.0 blue:189.0/255.0 alpha:1];
    }
    else if (indexPath.row == 5) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:196.0/255.0 green:156.0/255.0 blue:106.0/255.0 alpha:1];
    }
    else if (indexPath.row == 6) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:27.0/255.0 green:64.0/255.0 blue:86.0/255.0 alpha:1];
    }
    else if (indexPath.row == 7) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:221.0/255.0 green:106.0/255.0 blue:130.0/255.0 alpha:1];
    }
    else if (indexPath.row == 8) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:147.0/255.0 green:112.0/255.0 blue:132.0/255.0 alpha:1];
    }
    else if (indexPath.row == 9) {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:208.0/255.0 green:205.0/255.0 blue:189.0/255.0 alpha:1];
    }
    else {
        cell.contentView.backgroundColor = [[UIColor alloc]initWithRed:196.0/255.0 green:156.0/255.0 blue:106.0/255.0 alpha:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"abstract"];
    if ([str isEqualToString:@"yes"]) {
        Session *entry = [self.abstractsArray objectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:@"abstract" forKey:@"web"];
        WebViewController *vc = [[WebViewController alloc] init];
        vc.session = entry;
        [self.navigationController pushViewController:vc animated:YES];
        vc = nil;
    }
    
    */
}


-(void)refreshContact:(id)sender
{
    
    [self.contactArray removeAllObjects];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
    [query orderByAscending:@"date"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        
            // Do something...
            
            if (!error) {
                
                for (PFObject *object in objects)
                {
                    NSString *name = [object objectForKey:@"name"];
                    NSString *email = [object objectForKey:@"email"];
                    PFFile *photo = [object objectForKey:@"photo"];
                    
                    Contact *contact = [[Contact alloc] init];
                    [contact setName:name];
                    [contact setEmail:email];
                    [contact setPhoto:photo];
                    
                    [self.contactArray addObject:contact];
                }
                //NSLog(@"abstract: %@",self.abstractsArray);
                [self.contactTableView reloadData];
                
    
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self.refreshControl endRefreshing];
                
                
                
                
            } else {
                
                //4
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.refreshControl endRefreshing];
            }
        
        
        
    }];

}

- (void)testData
{
    NSLog(@"test data");
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"api/v1/account/feed" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"mappingresults are: %@",mappingResult);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self testData];

    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.contactTableView];
    [self.refreshControl addTarget:self action:@selector(refreshContact:) forControlEvents:UIControlEventValueChanged];
    
    self.contactArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Contact"];
    [query orderByAscending:@"date"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects)
            {
                NSString *name = [object objectForKey:@"name"];
                NSString *email = [object objectForKey:@"email"];
                PFFile *photo = [object objectForKey:@"photo"];
                
                Contact *contact = [[Contact alloc] init];
                [contact setName:name];
                [contact setEmail:email];
                [contact setPhoto:photo];
                
                [self.contactArray addObject:contact];
            }
            //NSLog(@"abstract: %@",self.abstractsArray);
            [self.contactTableView reloadData];
            
            
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        
        
        
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // Perform desired outcome here.
    //NSLog(@"scrollViewDidEndDragging");
    if (scrollView.contentOffset.x == 0) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 320) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletenable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
    }
    if (scrollView.contentOffset.x == 640) {
        [_bullet1 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet2 setImage:[UIImage imageNamed:@"bulletdissable.png"]];
        [_bullet3 setImage:[UIImage imageNamed:@"bulletenable.png"]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goLogout:(id)sender {
    [PFUser logOut];
    LoginViewController *logInViewController = [[LoginViewController alloc] init];
    [self presentViewController:logInViewController animated:NO completion:nil];
    logInViewController = nil;
}

- (IBAction)goHelp:(id)sender {
}

- (IBAction)goTextMessage:(id)sender {
    MessagesViewController *vc = [[MessagesViewController alloc] init];
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [naVC setNavigationBarHidden:YES];
    
    [self presentViewController:naVC animated:YES completion:nil];
    vc = nil;
}

- (IBAction)goPhoto:(id)sender {
}

- (IBAction)goVideo:(id)sender {
}

- (IBAction)goAudio:(id)sender {
}

@end
