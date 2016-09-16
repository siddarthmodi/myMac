//
//  DateCalculator+SpyAdditions.m
//  DateCalculator
//
//  Created by Main Account on 12/19/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "DateCalculator+SpyAdditions.h"

@implementation DateCalculator (SpyAdditions)

- (BOOL)spy_shouldHeDateIfHerAgeIs:(float)herAge {
    BOOL result = [self spy_shouldHeDateIfHerAgeIs:herAge];
    if (herAge < 18) {
        NSLog(@"Pervert detected! Adding to secret database...");
    }
    return result;
}

@end
