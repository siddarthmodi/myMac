//
//  Dog.m
//  Runtime1
//
//  Created by admin on 14/09/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

static NSNumber *count=nil;

@implementation Dog
+(void)initialize{
    
        count = [NSNumber numberWithInt:69];
    
    
}
+(void)initializecopy{

        count = [NSNumber numberWithInt:96];

}
-(id)init{
    if(!(self=[super init]))
        return nil;
    self.vegetarian=FALSE;
    self.numberOfLegs=@4;
    self.eats=@"Pedigree";
    _privateName = @"Steve";
    return self;
}
-(int)somemethod{
    return [count intValue];
}

@end
