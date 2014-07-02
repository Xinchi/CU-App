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
#import "CUEditProfileBDViewController.h"

NSString *picCellID = @"picCell";
NSString *cellID = @"cell";
NSString *takePhoto = @"Take Photo";
NSString *choosePhoto = @"Choose Existing Photo";

@interface CUEditProfileViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation CUEditProfileViewController

- (UIActionSheet *)actionSheet {
    if (_actionSheet == nil) {
        _actionSheet = [[UIActionSheet alloc] init];
        _actionSheet.delegate = self;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [_actionSheet addButtonWithTitle:takePhoto];
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [_actionSheet addButtonWithTitle:choosePhoto];
        }
        
        _actionSheet.cancelButtonIndex = [_actionSheet addButtonWithTitle:@"Cancel"];
    }
    return _actionSheet;
}

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
        cell.imageView.image = [UIImage imageNamed:@"BlackWidow"];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"User Name", @"");
                cell.detailTextLabel.text = user.username;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 1:
                cell.textLabel.text = NSLocalizedString(@"First Name", @"");
                cell.detailTextLabel.text = user.firstName;
                break;
                
            case 2:
                cell.textLabel.text = NSLocalizedString(@"Last Name", @"");
                cell.detailTextLabel.text = user.lastName;
                break;
                
            case 3:
                cell.textLabel.text = NSLocalizedString(@"Email", @"");
                cell.detailTextLabel.text = user.email;
                break;
                
            case 4:
                cell.textLabel.text = NSLocalizedString(@"Birthday", @"");
                cell.detailTextLabel.text = [[NSDateFormatter birthdayFormatter] stringFromDate:user.birthday];
                break;
                
            case 5:
                cell.textLabel.text = NSLocalizedString(@"Phone", @"");
                cell.detailTextLabel.text = user.phone;
                break;
                
            case 6:
                cell.textLabel.text = NSLocalizedString(@"WeChat", @"");
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
    if (indexPath.section == 0) {
        [self.actionSheet showInView:self.view];
    }
    else {
        User *user = [User currentUser];
        CUEditProfileTextViewController *detailViewController = [[CUEditProfileTextViewController alloc] init];
        CUEditProfileBDViewController *bdVC;
        
        switch (indexPath.row) {
            case 0:
                return;
                break;
                
            case 1:
                detailViewController.text = user.firstName;
                detailViewController.title = NSLocalizedString(@"First Name", @"");
                break;
                
            case 2:
                detailViewController.text = user.lastName;
                detailViewController.title = NSLocalizedString(@"Last Name", @"");
                break;
                
            case 3:
                detailViewController.text = user.email;
                detailViewController.title = NSLocalizedString(@"Email", @"");
                break;
                
            case 4:
                bdVC = [[CUEditProfileBDViewController alloc] init];
                bdVC.title = NSLocalizedString(@"Birthday", @"");
                bdVC.birthday = user.birthday;
                [self.navigationController pushViewController:bdVC animated:YES];
                return;
                break;
                
            case 5:
                detailViewController.text = user.phone;
                detailViewController.title = NSLocalizedString(@"Phone", @"");
                break;
                
            case 6:
                detailViewController.text = user.wechatID;
                detailViewController.title = NSLocalizedString(@"WeChat", @"");
                break;
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }
    return 44;
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
        return;
    }
    
    UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:takePhoto] ) {
        pickerC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                              UIImagePickerControllerSourceTypeCamera];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:choosePhoto]) {
        pickerC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                              UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self presentViewController:pickerC animated:YES completion:nil];
}

@end
