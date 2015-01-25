//
//  CustomDelegate.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "CustomDataSource.h"
#import "MosaicLayout/Entities/MosaicData.h"
#import "MosaicLayout/Views/MosaicCell.h"

@interface CustomDataSource()
-(void)loadFromDisk;

@property (strong, nonatomic) NSArray *tileImageKeys;
@property (strong, nonatomic) NSArray *tileTitleKeys;

@end

@implementation CustomDataSource

- (NSArray *)tileImageKeys
{
    if (_tileImageKeys == nil) {
        _tileImageKeys = @[@"Event_Image",
                           @"Store_Image",
                           @"Soccer_Image",
                           @"Basketball_Image",
                           @"Contact_Image",
                           @"Market_Image",
                           @"Note_Image",
                           @"Sponsor_Image"];
    }
    return _tileImageKeys;
}

- (NSArray *)tileTitleKeys
{
    if (_tileTitleKeys == nil) {
        _tileTitleKeys = @[@"Event_Title",
                           @"Store_Title",
                           @"Soccer_Title",
                           @"Basketball_Title",
                           @"Contact_Title",
                           @"Market_Title",
                           @"Note_Title",
                           @"Sponsor_Title"];
    }
    
    return _tileTitleKeys;
}

#pragma mark - Private
-(void)loadFromDisk{
    _elements = [[NSMutableArray alloc] init];
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
    
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements){
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [_elements addObject:aMosaicModule];
    }
}

#pragma mark - Public

-(id)init{
    self = [super init];
    if (self){
        [self loadFromDisk];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_elements count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    
    PFConfig *config = [PFConfig currentConfig];
    
    MosaicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    MosaicData *data = [_elements objectAtIndex:indexPath.row];
    data.image = config[self.tileImageKeys[indexPath.row]];
    data.title = config[self.tileTitleKeys[indexPath.row]];
    cell.mosaicData = data;
    
    float randomWhite = (arc4random() % 40 + 10) / 255.0;
    cell.backgroundColor = [UIColor colorWithWhite:randomWhite alpha:1];
    
    return cell;
}

@end
