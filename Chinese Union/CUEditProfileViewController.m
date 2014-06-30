//
//  CUEditProfileViewController.m
//  Chinese Union
//
//  Created by wpliao on 6/29/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUEditProfileViewController.h"
#import "UIViewController+Additions.h"
#import "CUProfilePicCell.h"
#import "CUProfileTextCell.h"
#import "User.h"
#import "NSDateFormatter+Additions.h"
#import "CUEditProfileTextViewController.h"

NSString *picCellID = @"picCell";
NSString *cellID = @"cell";

@interface CUEditProfileViewController ()

@end

@implementation CUEditProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addExitButton];
    self.title = @"Edit";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CUProfilePicCell" bundle:nil] forCellReuseIdentifier:picCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"CUProfileTextCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User currentUser];
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:picCellID forIndexPath:indexPath];
        cell.textLabel.text = @"Profile Picture";
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"User Name";
                cell.detailTextLabel.text = user.username;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = @"First Name";
                cell.detailTextLabel.text = user.firstName;
                break;
                
            case 2:
                cell.textLabel.text = @"Last Name";
                cell.detailTextLabel.text = user.lastName;
                break;
                
            case 3:
                cell.textLabel.text = @"Email";
                cell.detailTextLabel.text = user.email;
                break;
                
            case 4:
                cell.textLabel.text = @"Birthday";
                cell.detailTextLabel.text = [[NSDateFormatter birthdayFormatter] stringFromDate:user.birthday];
                break;
                
            case 5:
                cell.textLabel.text = @"Phone";
                cell.detailTextLabel.text = user.phone;
                break;
                
            case 6:
                cell.textLabel.text = @"WeChat";
                cell.detailTextLabel.text = user.wechatID;
                break;
                
            default:
                break;
        }
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        User *user = [User currentUser];
        CUEditProfileTextViewController *detailViewController = [[CUEditProfileTextViewController alloc] init];
        
        switch (indexPath.row) {
            case 0:
                return;
                break;
                
            case 1:
                detailViewController.text = user.firstName;
                break;
                
            case 2:
                detailViewController.text = user.lastName;
                break;
                
            case 3:
                detailViewController.text = user.email;
                break;
                
            case 4:
                return;
                break;
                
            case 5:
                detailViewController.text = user.phone;
                break;
                
            case 6:
                detailViewController.text = user.wechatID;
                break;
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


@end
