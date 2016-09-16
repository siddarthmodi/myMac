//
//  DateCalculator+SpyAdditions.h
//  DateCalculator
//
//  Created by Main Account on 12/19/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import "DateCalculator.h"

@interface DateCalculator (SpyAdditions)

- (BOOL)spy_shouldHeDateIfHerAgeIs:(float)herAge;

@end
