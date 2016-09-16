//
//  Animal.m
//  Runtime1
//
//  Created by admin on 14/09/16.
//  Copyright © 2016 admin. All rights reserved.
//
#import "Animal.h"

@implementation Animal

@synthesize vegetarian;
@synthesize numberOfLegs;
@synthesize eats;
-(id)initWithParams:(BOOL)veg legs:(NSNumber *)numOfLegs eats:(NSString *)eatsstring{
    if(!(self=[super init]))
        return nil;
    self.vegetarian=veg;
    self.numberOfLegs=numOfLegs;
    self.eats=eatsstring;
    return self;
}
-(NSString *)print{
    NSString *temp= [NSString stringWithFormat:@"I am a animal and i have %@ and i eat %@",self.numberOfLegs,self.eats];
    return temp;
}
@end
