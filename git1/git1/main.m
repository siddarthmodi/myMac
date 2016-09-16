// clang -fobjc-arc -framework Foundation runtime-class.m

#import <Foundation/Foundation.h>

#import <objc/runtime.h>


@interface Person : NSObject

- (id)initWithFirstName: (NSString *)firstName lastName: (NSString *)lastName age: (NSUInteger)age;

@property (readonly) NSString *firstName;
@property (readonly) NSString *lastName;
@property (readonly) NSUInteger age;

@end


int main(int argc, char **argv)
{
    @autoreleasepool
    {
        Class c = objc_allocateClassPair([NSObject class], "Person", 0);
        class_addIvar(c, "firstName", sizeof(id), log2(sizeof(id)), @encode(id));
        class_addIvar(c, "lastName", sizeof(id), log2(sizeof(id)), @encode(id));
        class_addIvar(c, "age", sizeof(NSUInteger), log2(sizeof(NSUInteger)), @encode(NSUInteger));
        
        Ivar firstNameIvar = class_getInstanceVariable(c, "firstName");
        Ivar lastNameIvar = class_getInstanceVariable(c, "lastName");
        ptrdiff_t ageOffset = ivar_getOffset(class_getInstanceVariable(c, "age"));
        
        IMP initIMP = imp_implementationWithBlock(^(id self, NSString *firstName, NSString *lastName, NSUInteger age) {
            object_setIvar(self, firstNameIvar, firstName);
            object_setIvar(self, lastNameIvar, lastName);
            
            char *agePtr = ((char *)(__bridge void *)self) + ageOffset;
            memcpy(agePtr, &age, sizeof(age));
            
            return self;
        });
        const char *initTypes = [[NSString stringWithFormat: @"%s%s%s%s%s%s", @encode(id), @encode(id), @encode(SEL), @encode(id), @encode(id), @encode(NSUInteger)] UTF8String];
        class_addMethod(c, @selector(initWithFirstName:lastName:age:), initIMP, initTypes);
        
        const char *objectGetterTypes = [[NSString stringWithFormat: @"%s%s%s", @encode(id), @encode(id), @encode(SEL)] UTF8String];
        
        IMP descriptionIMP = imp_implementationWithBlock(^(id self) {
            return [NSString stringWithFormat: @"<%@ %p: %@ %@ age %zd>", [self class], self, [self firstName], [self lastName], [self age]];
        });
        class_addMethod(c, @selector(description), descriptionIMP, objectGetterTypes);
        
        IMP firstNameIMP = imp_implementationWithBlock(^(id self) {
            return object_getIvar(self, firstNameIvar);
        });
        class_addMethod(c, @selector(firstName), firstNameIMP, objectGetterTypes);
        
        IMP lastNameIMP = imp_implementationWithBlock(^(id self) {
            return object_getIvar(self, lastNameIvar);
        });
        class_addMethod(c, @selector(lastName), lastNameIMP, objectGetterTypes);
        
        IMP ageIMP = imp_implementationWithBlock(^(id self) {
            char *agePtr = ((char *)(__bridge void *)self) + ageOffset;
            NSUInteger age;
            memcpy(&age, agePtr, sizeof(age));
            return age;
        });
        const char *ageTypes = [[NSString stringWithFormat: @"%s%s%s", @encode(NSUInteger), @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(c, @selector(age), ageIMP, ageTypes);
        
        objc_registerClassPair(c);
        
        Class PersonC = NSClassFromString(@"Person");
        Person *alex = [[PersonC alloc] initWithFirstName: @"Alex" lastName: @"Trebek" age: 29];
        Person *sean = [[PersonC alloc] initWithFirstName: @"Sean" lastName: @"Connery" age: 42];
        
        NSArray *people = @[ alex, sean ];
        
        NSLog(@"%@", people);
    }
}