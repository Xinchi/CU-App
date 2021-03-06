//
//  CUPurchaseHistoryDetailTableViewController.m
//  Chinese Union
//
//  Created by wpliao on 10/2/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUPurchaseHistoryDetailTableViewController.h"
#import "NSDateFormatter+Additions.h"
#import "CUQRCodeTableViewCell.h"
#import "Order.h"
#import "CUProducts.h"
#import "Common.h"
#import "WYPopoverController.h"
#import "CUTextViewController.h"

NSString * const cellId = @"cellId";
NSString * const QRCellId = @"QRCellId";

@interface CUPurchaseHistoryDetailTableViewController ()

@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) WYPopoverController *popover;

@end

@implementation CUPurchaseHistoryDetailTableViewController

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [NSDateFormatter eventDateFormatter];
    }
    return _dateFormatter;
}

- (instancetype)initWithOrder:(Order *)order
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[PFTableViewCell class] forCellReuseIdentifier:cellId];
    [self.tableView registerNib:[UINib nibWithNibName:@"CUQRCodeTableViewCell" bundle:nil] forCellReuseIdentifier:QRCellId];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }
    else if (indexPath.section == 2)
    {
        return 176;
    }
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }
    else if (section == 1) {
        return 5;
    }
    else if (section == 2) {
        return 1;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return NSLocalizedString(@"Product", @"");
    }
    else if (section == 1)
    {
        return NSLocalizedString(@"Billing", @"");
    }
    else
    {
        return NSLocalizedString(@"QR Code", @"");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.imageView.image = nil;
        cell.textLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == 0) {
            CUProducts *product = self.order.item;
            
            if (indexPath.row == 0) {
                cell.imageView.file = product.image;
                //[cell.imageView loadInBackground];
                cell.textLabel.text = product.name;
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"Price: $%@", [product.price stringValue]];
            }
            else if (indexPath.row == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"Description: %@", product.detail ? : @""];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Order ID: %@", self.order.objectId];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"Name: %@", self.order.name];
            }
            else if (indexPath.row == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"Address: %@", self.order.address];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else if (indexPath.row == 3) {
                cell.textLabel.text = [NSString stringWithFormat:@"Zip: %@", self.order.zip];
            }
            else if (indexPath.row == 4) {
                cell.textLabel.text = [NSString stringWithFormat:@"Purchase Date: %@", [self.dateFormatter stringFromDate:self.order.createdAt]];
            }
        }
        return cell;
    }
    else
    {
        CUQRCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QRCellId];
        UIImage *image = [Common generateQRCodeWithData:[NSString stringWithFormat:@"order_%@",self.order.objectId] withSize:160.0
                                          withFillColor:[UIColor darkGrayColor]];
        cell.QRImageView.image = image;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        [self showPopoverInView:cell title:@"Description" content:self.order.item.detail];
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        [self showPopoverInView:cell title:@"Address" content:self.order.address];
    }
}

- (void)showPopoverInView:(UIView *)view title:(NSString *)title content:(NSString *)content
{
    CUTextViewController *vc = [[CUTextViewController alloc] init];
    vc.aString = content;
    vc.title = title;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    self.popover = [[WYPopoverController alloc] initWithContentViewController:nav];
    self.popover.theme = [WYPopoverTheme themeForIOS7];
    self.popover.popoverLayoutMargins = UIEdgeInsetsMake(40, 40, 40, 40);
    
    [self.popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
}

@end
