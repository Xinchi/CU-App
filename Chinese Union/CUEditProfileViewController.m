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
    
    return 8;
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
                cell.textLabel.text = NSLocalizedString(@"Gender", @"");
                cell.detailTextLabel.text = user.gender;
                break;
                
            case 7:
                cell.textLabel.text = NSLocalizedString(@"WeChat", @"");
                cell.detailTextLabel.text = user.wechatID;
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.email;
                vc.title = NSLocalizedString(@"Email", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditEmail;
                break;
                
            case 4:
                vc = [[CUEditProfileBDViewController alloc] init];
                vc.title = NSLocalizedString(@"Birthday", @"");
                ((CUEditProfileBDViewController *)vc).birthday = user.birthday;
                break;
                
            case 5:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.phone;
                vc.title = NSLocalizedString(@"Phone", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditPhone;
                break;
                
            case 6:
                vc = [[CUEditProfileGenderViewController alloc] init];
                vc.title = NSLocalizedString(@"Gender", @"");
                ((CUEditProfileGenderViewController *)vc).gender = user.gender;
                break;
                
            case 7:
                vc = [[CUEditProfileTextViewController alloc] init];
                ((CUEditProfileTextViewController *)vc).text = user.wechatID;
                vc.title = NSLocalizedString(@"WeChat", @"");
                ((CUEditProfileTextViewController *)vc).option = CUProfileEditWeChat;
                break;
                
            default:
                break;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
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
                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Succeed" mode:MRProgressOverlayViewModeCheckmark animated:YES];
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//                    hud.mode = MBProgressHU
                }
                else
                {
                    NSLog(@"error = %@",error);
                    [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Succeed" mode:MRProgressOverlayViewModeCross animated:YES];
                }
            }];
        }
        else
        {
            NSLog(@"error = %@",error);
            [MRProgressOverlayView showOverlayAddedTo:self.navigationController.view title:@"Succeed" mode:MRProgressOverlayViewModeCross animated:YES];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) dismissOverlay
{
    [MRProgressOverlayView dismissAllOverlaysForView:self.navigationController.view animated:YES];
}
@end
