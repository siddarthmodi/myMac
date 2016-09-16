//
//  Animal.h
//  Runtime1
//
//  Created by admin on 14/09/16.
//  Copyright © 2016 admin. All rights reserved.
//
#import "AnimalBase.h"
@interface Animal ()

@property(nonatomic,readwrite,getter=isVegetarian) BOOL vegetarian;
@property(nonatomic,readwrite) NSNumber *numberOfLegs;
@property(nonatomic,readwrite) NSString *eats;
-(id)initWithParams:(BOOL)veg legs:(NSNumber *)numberOfLegs eats:(NSString *)eats;
-(NSString *)print;

@end
