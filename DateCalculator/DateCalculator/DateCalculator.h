//
//  DateCalculator.h
//  DateCalculator
//
//  Created by Main Account on 12/6/13.
//  Copyright (c) 2013 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateCalculator : NSObject

@property (assign) float hisAge;
@property (strong, nonatomic) NSString *hisName;

- (BOOL)shouldHeDateIfHerAgeIs:(float)herAge;

@end
