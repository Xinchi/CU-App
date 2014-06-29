//
//  STPCheckoutView.h
//  Checkout Example
//
//  Created by Alex MacCaw on 2/14/13.
//  Copyright (c) 2013 Stripe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stripe.h"
#import "PKView.h"

#define STPCardErrorUserMessage NSLocalizedString(@"Your card is invalid", @"Error when the card is not valid")

typedef void (^STPCheckoutTokenBlock)(STPToken* token, NSError* error);

@class STPCheckoutView;

@protocol STPCheckoutDelegate <NSObject>
@optional
- (void) checkoutView:(STPCheckoutView*)view withCard:(PKCard *)card isValid:(BOOL)valid;
@end

@interface STPCheckoutView : UIView <PKViewDelegate>

- (id)initWithFrame: (CGRect)frame andKey: (NSString*)stripeKey;

@property IBOutlet PKView* paymentView;
@property (copy) NSString* key;
@property id <STPCheckoutDelegate> delegate;
@property (readonly) BOOL pending;
@property (setter = setUSAddress:) BOOL usAddress;

- (void)createToken:(STPCheckoutTokenBlock)block;

@end
