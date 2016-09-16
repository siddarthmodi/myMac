//
//  DateCalculator.m
//  DateCalculator
//
//  Created by Main Account on 12/6/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "DateCalculator.h"

@implementation DateCalculator

- (BOOL)shouldHeDateIfHerAgeIs:(float)herAge {
    float minAgeToDate = _hisAge / 2 + 7;
    return herAge > minAgeToDate;
}

@end
