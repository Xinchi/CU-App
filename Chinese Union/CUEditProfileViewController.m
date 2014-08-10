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
#import "CUProfileEditOption.h"
#import "User.h"
#import "MRProgress.h"
#import "MBProgressHUD.h"
#import "CUEditProfileGenderViewController.h"

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
        
        _actionSheet.cancelButtonIndex = [_actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
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
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User currentUser];
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:picCellID forIndexPath:indexPath];
        cell.textLabel.text = @"Profile Picture";
        
        NSData *imageData = [user.profilePic getData];
        UIImage *profileImage = [UIImage imageWithData:imageData];
        cell.imageView.image = profileImage;
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        
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
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 4:
                cell.textLabel.text = NSLocalizedString(@"Birthday", @"");
                cell.detailTextLabel.text = [[NSDateFormatter birthdayFormatter] stringFromDate:user.birthday];
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 5:
                cell.textLabel.text = NSLocalizedString(@"Phone", @"");
                cell.detailTextLabel.text = user.phone;
                break;
                
            case 6:
                cell.textLabel.text = NSLocalizedString(@"Gender", @"");
                cell.detailTextLabel.text = user.gender;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            case 7:
                cell.textLabel.text = NSLocalizedString(@"WeChat", @"");
                cell.detailTextLabel.text = user.wechatID;
                break;
                
            case 8:
                cell.textLabel.text = NSLocalizedString(@"Password", @"");
                cell.detailTextLabel.text = nil;
                cell.textLabel.textColor = [UIColor redColor];
//                cell.layer.borderColor = [UIColor redColor].CGColor;
//                cell.layer.borderWidth = 2;
//                cell.backgroundColor = [UIColor redColor];
                break;
                
            case 9:
                if (![PFFacebookUtils isLinkedWithUser:user])
                {
                    cell.textLabel.text = NSLocalizedString(@"Link with Facebook", @"");
                }
                else
                {
                    cell.textLabel.text = NSLocalizedString(@"Facebook account has been linked", @"");
                }
                cell.detailTextLabel.text = nil;
                cell.textLabel.textColor = [UIColor blueColor];
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL vcPresentable = true;
    if (indexPath.section == 0) {
        [self.actionSheet showInView:self.view];
    }
    else {
        User *user = [User currentUser];
        CUEditProfileBaseViewController *vc;
        
        switch (indexPath.row) {
            case 0:
                return;
                break;
                
            case 1:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.firstName;
                vc.title = NSLocalizedString(@"First Name", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditFirstName;
                break;
                
            case 2:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.lastName;
                vc.title = NSLocalizedString(@"Last Name", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditLastName;
                break;
                
            case 3:
                return;
//                vc = [[CUEditProfileTextViewController alloc] init];
//                ((CUEditProfileTextViewController *)vc).text = user.email;
//                vc.title = NSLocalizedString(@"Email", @"");
//                ((CUEditProfileTextViewController *)vc).option = CUProfileEditEmail;
                break;
                
            case 4:
                return;
//                vc = [[CUEditProfileBDViewController alloc] init];
//                vc.title = NSLocalizedString(@"Birthday", @"");
//                ((CUEditProfileBDViewController *)vc).birthday = user.birthday;
                break;
                
            case 5:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.phone;
                vc.title = NSLocalizedString(@"Phone", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditPhone;
                break;
                
            case 6:
                return;
//                vc = [[CUEditProfileGenderViewController alloc] init];
//                vc.title = NSLocalizedString(@"Gender", @"");
//                ((CUEditProfileGenderViewController *)vc).gender = user.gender;
                break;
                
            case 7:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.wechatID;
                vc.title = NSLocalizedString(@"WeChat", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditWeChat;
                break;
                
            case 8:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.wechatID;
                vc.title = NSLocalizedString(@"Password", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditPassword;
                break;
                
            case 9:
                [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view animated:YES];
                vcPresentable = false;
                if (![PFFacebookUtils isLinkedWithUser:user])
                {
                    NSLog(@"Before FB was not linked");
                    [PFFacebookUtils linkUser:user permissions:nil block:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Link Successful!" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                            
                            [self.tableView reloadData];
                            [self performSelector:@selector(dismissOverlay) withObject:nil afterDelay:1];
                            ;
                        }
                        else {

                            [self showAlertTitle:NSLocalizedString(@"Error",@"") msg:[[error userInfo] valueForKey:@"error"]];
                        }
                        
                        NSIndexPath *selectedIndexpath = [self.tableView indexPathForSelectedRow];
                        [self.tableView deselectRowAtIndexPath:selectedIndexpath animated:YES];
                    }];

                }else {
                    NSLog(@"Before FB was linked");
                    [user refresh];
                    NSLog(@"currentUser id = %@",user.objectId);
                    [PFFacebookUtils unlinkUserInBackground:user block:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            NSLog(@"Unlink successfully..");
                            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Unlink Successful!" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                            [self.tableView reloadData];
                            [self performSelector:@selector(dismissOverlay) withObject:nil afterDelay:1];
                        }
                        else{
                            NSLog(@"Error : %@",error);
                        }
                    }];
                }
                
                break;
            default:
                break;
        }
        if(vcPresentable)
        {
            [self.navigationController pushViewController:vc animated:YES];
        }
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
    pickerC.allowsEditing = YES;
    pickerC.delegate = self;
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:takePhoto] ) {
        pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:choosePhoto]) {
        pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                              UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [self presentViewController:pickerC animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    User *user = [User currentUser];
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    PFFile *image = [PFFile fileWithName:@"image.png" data:imageData];
    user.profilePic = image;


    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Uploading ... " mode:MRProgressOverlayViewModeDeterminateCircular animated:YES];

    [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        // Handle success or failure here ...
        if(succeeded)
        {
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
                if(succeeded)
                {
//                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Succeed" mode:MRProgressOverlayViewModeCheckmark animated:YES];
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"Picture uploading Completed";
                    [hud hide:YES afterDelay:2];
                }
                else
                {
                    MyLog(@"error = %@",error);
                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Error" mode:MRProgressOverlayViewModeCross animated:YES];
                }
            }];
        }
        else
        {
            MyLog(@"error = %@",error);
            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Error" mode:MRProgressOverlayViewModeCross animated:YES];
        }
        [self performSelector:@selector(dismissOverlay) withObject:self afterDelay:1.0];

    }progressBlock:^(int percentDone) {
        float ratio = (float)percentDone/100.0;
        [MRProgressOverlayView overlayForView:self.navigationController.view].progress = ratio;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.tableView reloadData];
}

- (void)showAlertTitle:(NSString *)title msg:(NSString *)msg {
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) dismissOverlay
{
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
}
@end
