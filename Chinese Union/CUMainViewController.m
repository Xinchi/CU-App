//
//  CUMainViewController.m
//  Chinese Union
//
//  Created by wpliao on 2014/6/4.
//  Copyright (c) 2014年 ucsd.ChineseUnion. All rights reserved.
//

#import "CUMainViewController.h"
#import "CustomDataSource.h"
#import "MosaicLayout.h"
#import "MosaicData.h"
#import "MosaicLayout/Views/MosaicCell.h"
#import "TWTSideMenuViewController.h"

#define kDoubleColumnProbability 40
#define kColumnsiPadLandscape 5
#define kColumnsiPadPortrait 4
#define kColumnsiPhoneLandscape 3
#define kColumnsiPhonePortrait 2

@interface CUMainViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CustomDataSource *dataSource;

@end

@implementation CUMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"CU App";
    
    self.dataSource = [[CustomDataSource alloc] init];
    self.collectionView.dataSource = self.dataSource;

    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    self.navigationItem.leftBarButtonItem = openItem;
    
    [self.collectionView registerClass:[MosaicCell class] forCellWithReuseIdentifier:@"cell"];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setDelegate:self];
}

- (void)openButtonPressed
{
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

#pragma mark - MosaicLayoutDelegate

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //  Base relative height for simple layout type. This is 1.0 (height equals to width)
    float retVal = 1.0;
    
    NSMutableArray *elements = [(CustomDataSource *)self.collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    if (aMosaicModule.relativeHeight != 0){
        
        //  If the relative height was set before, return it
        retVal = aMosaicModule.relativeHeight;
        
    }else{
        
        BOOL isDoubleColumn = [self collectionView:collectionView isDoubleColumnAtIndexPath:indexPath];
        if (isDoubleColumn){
            //  Base relative height for double layout type. This is 0.75 (height equals to 75% width)
            retVal = 0.75;
        }
        
        /*  Relative height random modifier. The max height of relative height is 25% more than
         *  the base relative height */
        
        float extraRandomHeight = arc4random() % 25;
        retVal = retVal + (extraRandomHeight / 100);
        
        /*  Persist the relative height on MosaicData so the value will be the same every time
         *  the mosaic layout invalidates */
        
        aMosaicModule.relativeHeight = retVal;
    }
    
    return retVal;
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *elements = [(CustomDataSource *)self.collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    if (aMosaicModule.layoutType == kMosaicLayoutTypeUndefined){
        
        /*  First layout. We have to decide if the MosaicData should be
         *  double column (if possible) or not. */
        
        NSUInteger random = arc4random() % 100;
        if (random < kDoubleColumnProbability){
            aMosaicModule.layoutType = kMosaicLayoutTypeDouble;
        }else{
            aMosaicModule.layoutType = kMosaicLayoutTypeSingle;
        }
    }
    
    BOOL retVal = aMosaicModule.layoutType == kMosaicLayoutTypeDouble;
    
    return retVal;
    
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    
    UIInterfaceOrientation anOrientation = self.interfaceOrientation;
    
    //  Set the quantity of columns according of the device and interface orientation
    NSUInteger retVal = 0;
    if (UIInterfaceOrientationIsLandscape(anOrientation)){
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            retVal = kColumnsiPadLandscape;
        }else{
            retVal = kColumnsiPhoneLandscape;
        }
        
    }else{
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            retVal = kColumnsiPadPortrait;
        }else{
            retVal = kColumnsiPhonePortrait;
        }
    }
    
    return retVal;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Did select item:%@", indexPath);
//    switch (indexPath.row) {
//        case 0:
//            [self performSegueWithIdentifier:@"eventSegue" sender:self];
//            break;
//            
//        case 1:
//            [self performSegueWithIdentifier:@"storeSegue" sender:self];
//            break;
//            
//        case 2:
//            [self performSegueWithIdentifier:@"calendarSegue" sender:self];
//            break;
//            
//        case 3:
//            [self performSegueWithIdentifier:@"soccerSegue" sender:self];
//            break;
//            
//        case 4:
//            [self performSegueWithIdentifier:@"basketballSegue" sender:self];
//            break;
//            
//        case 5:
//            [self performSegueWithIdentifier:@"contactSegue" sender:self];
//            break;
//            
//        default:
//            break;
//    }
}

@end
