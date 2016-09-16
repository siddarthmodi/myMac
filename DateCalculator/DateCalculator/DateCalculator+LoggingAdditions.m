//
//  DateCalculator+LoggingAdditions.m
//  DateCalculator
//
//  Created by Main Account on 12/19/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "DateCalculator+LoggingAdditions.h"

@implementation DateCalculator (LoggingAdditions)

- (void)log {
    NSLog(@"A calculator for %@, age %d.", self.hisName, (int) self.hisAge);
}

@end
