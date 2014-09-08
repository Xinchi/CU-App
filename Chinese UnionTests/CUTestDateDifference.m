//
//  CUTestDateDifference.m
//  Chinese Union
//
//  Created by wpliao on 9/7/14.
//  Copyright (c) 2014 ucsd.ChineseUnion. All rights reserved.
//

#import "CUTestHeader.h"
#import "NSDate+Difference.h"

SpecBegin(DateDifference)

__block NSCalendar *calendar;
__block NSDate *fromDate;

beforeAll(^{
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    fromDate = [NSDate date];
    MyLog(@"From date = %@", fromDate);
});

describe(@"Date difference", ^{
    
    __block NSDate *toDate;
    
    context(@"1 day after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day = 1;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(1);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"day");
        });
    });
    
    context(@"2 days after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.day = 2;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(2);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"days");
        });
    });
    
    context(@"1 hour after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.hour = 1;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(1);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"hour");
        });
    });
    
    context(@"2 hours after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.hour = 2;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(2);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"hours");
        });
    });
    
    context(@"1 min after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.minute = 1;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(1);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"min");
        });
    });
    
    context(@"30 mins after", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.minute = 30;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.equal(30);
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"mins");
        });
    });
    
    context(@"less than 1 min", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.second = 30;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"Less than a min");
        });
    });
    
    context(@"expired", ^{
        beforeEach(^{
            NSDateComponents *components = [[NSDateComponents alloc] init];
            components.hour = -1;
            toDate = [calendar dateByAddingComponents:components toDate:fromDate options:0];
        });
        
        it(@"should return correct string", ^{
            NSDictionary *dict = [fromDate differenceToDate:toDate];
            expect(dict[CUDateDifferenceValueKey]).to.beNil;
            expect(dict[CUDateDifferenceStringKey]).to.equal(@"Expired");
        });
    });
});

SpecEnd
