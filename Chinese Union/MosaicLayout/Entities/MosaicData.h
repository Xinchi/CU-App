//
//  MosaicData.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/17/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kMosaicLayoutTypeUndefined,
    kMosaicLayoutTypeSingle,
    kMosaicLayoutTypeDouble
} MosaicLayoutType;

@interface MosaicData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (strong, nonatomic) PFFile *image; // Image file pulled from Parse. If nil, use imageFilename instead.
@property (strong) NSString *imageFilename;
@property (strong) NSString *title;
@property (assign) BOOL firstTimeShown;
@property (assign) MosaicLayoutType layoutType;
@property (assign) float relativeHeight;
@end
