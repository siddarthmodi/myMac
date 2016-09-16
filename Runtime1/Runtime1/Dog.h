//
//  Dog.m
//  Runtime1
//
//  Created by admin on 14/09/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "Animal.h"

@protocol MyProtocol



@end

@interface Dog:Animal <MyProtocol>
{
    NSString *_privateName;
}
-(int)somemethod;
@end