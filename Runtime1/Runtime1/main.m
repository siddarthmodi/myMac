//
//  main.m
//  Runtime1
//
//  Created by admin on 14/09/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Animal.h"
#import "Dog.h"
#import <objc/message.h>



int main(int argc, const char * argv[]) {
    
        Animal *a=[[Animal alloc] init];
        a.vegetarian=TRUE;
        NSLog(@"%@",a.isVegetarian?@"YES I AM VEGETARIAN":@"NO I AM NOT VEGETARIAN");
        NSLog(@"%@",[a print]);
        
        Animal *b=[[Animal alloc] initWithParams:FALSE legs:@4 eats:@"nothing"];
        NSLog(@"%@",b.isVegetarian?@"YES I AM VEGETARIAN":@"NO I AM NOT VEGETARIAN");
        NSLog(@"%@",[b print]);
        
        Dog *c=[[Dog alloc] init] ;
        NSLog(@"%@",[c print]);
        NSLog(@"%d",[c somemethod]);
        
        Class myClass = [c class];
        Class superclass = class_getSuperclass(myClass);
        Class supersuperclass = class_getSuperclass(superclass);
        NSLog(@"Superclass of %@ is %@", NSStringFromClass(myClass), NSStringFromClass(superclass));
        NSLog(@"Superclass of %@ is %@", NSStringFromClass(superclass), NSStringFromClass(supersuperclass));
        
        myClass = objc_getClass("Dog");
        NSLog(@"The name of my class is %s",(class_getName(myClass)));
        NSLog(@"The name of my super class is %s",(class_getName(superclass)));
        
        NSLog(@"Is Dog a meta class %@",class_isMetaClass(myClass)?@"YES":@"NO");
        
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(myClass, &count);
        if(count)
        {
            NSLog(@"Properties of %s",(class_getName(myClass)));
            for(int i=0;i<count;i++)
            {
                objc_property_t property=properties[i];
                NSString *temp=[NSString stringWithFormat:@"%s %s ",property_getName(property),property_getAttributes(property)];
                NSLog(@"--%@",temp);
                
            }
        }
        else
        {
            NSLog(@"%s has 0 properties",(class_getName(myClass)));
        }
        
        
        properties = class_copyPropertyList(superclass, &count);
        if(count)
        {
            NSLog(@"Properties of %s",(class_getName(superclass)));
            for(int i=0;i<count;i++)
            {
                objc_property_t property=properties[i];
                NSString *temp=[NSString stringWithFormat:@"%s-- %s ",property_getName(property),property_getAttributes(property)];
                NSLog(@"--%@",temp);
                
            }
        }
        else
        {
            NSLog(@"%s has 0 properties",(class_getName(myClass)));
        }
        
        Ivar ivar1=class_getInstanceVariable(superclass, "vegetarian");
        Ivar ivar2=class_getInstanceVariable(superclass, "numberOfLegs");
        Ivar ivar3=class_getInstanceVariable(superclass, "eats");
        BOOL vegetarian = object_getIvar(c, ivar1);
        NSNumber *numberOfLegs = object_getIvar(c, ivar2);
        NSString *eats= object_getIvar(c, ivar3);
        NSString *temp= [NSString stringWithFormat:@"I am a dog and i have %@ and i eat %@",numberOfLegs,eats];
        NSLog(@"%@",temp);
        NSLog(@"%@",vegetarian?@"YES I AM VEGETARIAN":@"NO I AM NOT VEGETARIAN");
        
        
        
        //class_getClassVariable does not work
        
        //you cannot add instance variables to an existing class
        
        unsigned int outCount;
        Ivar *vars = class_copyIvarList(superclass, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar var = vars[i];
            NSLog(@"%s %s", ivar_getName(var), ivar_getTypeEncoding(var));
            
        }
        free(vars);
        
        objc_property_t property = class_getProperty(superclass, "numberOfLegs");
        temp=[NSString stringWithFormat:@"%s-- %s ",property_getName(property),property_getAttributes(property)];
        NSLog(@"--%@",temp);
        
        IMP newMethodIMP = imp_implementationWithBlock(^(id self) {
            for(int i=0;i<[[self numberOfLegs] intValue];i++)
            {
                NSLog(@"Leg no %d",i+1);
            }
        });
        
        const char *initTypes = [[NSString stringWithFormat: @"%s%s",  @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(myClass, @selector(justPrint), newMethodIMP, initTypes);
        SEL justPrint = @selector(justPrint);
        [c performSelector:justPrint];
        
        newMethodIMP = imp_implementationWithBlock(^(id self,NSString *ownerName) {
            NSString *temp=[NSString stringWithFormat:@"bhow bhow %@ bhow bhow %@",ownerName,ownerName];
            NSLog(@"%@",temp);
        });
        
        initTypes = [[NSString stringWithFormat: @"%s%s%s",  @encode(id), @encode(SEL), @encode(id)] UTF8String];
        class_addMethod(myClass, @selector(speak:), newMethodIMP, initTypes);
        justPrint = @selector(speak:);
        [c performSelector:justPrint withObject:[NSString stringWithString:@"Siddarth"]];
        
        newMethodIMP = imp_implementationWithBlock(^(id self,NSString *ownerName) {
            NSString *temp=[NSString stringWithFormat:@"meaw bhow %@ bhow bhow %@",ownerName,ownerName];
            NSLog(@"%@",temp);
        });
        
        initTypes = [[NSString stringWithFormat: @"%s%s%s",  @encode(id), @encode(SEL), @encode(id)] UTF8String];
        class_addMethod(myClass, @selector(speakcopy:), newMethodIMP, initTypes);
        justPrint = @selector(speakcopy:);
        [c performSelector:justPrint withObject:[NSString stringWithString:@"Siddarth"]];
        
        Method meth = class_getInstanceMethod(myClass, @selector(speak:));
        Method meth1 = class_getInstanceMethod(myClass, @selector(speakcopy:));
        /*
         typedef struct objc_method *Method;
         
         ....
         
         struct objc_method {
         SEL method_name                                          OBJC2_UNAVAILABLE;
         char *method_types                                       OBJC2_UNAVAILABLE;
         IMP method_imp                                           OBJC2_UNAVAILABLE;
         }
         
         
         (t->method_imp)(ztest, t->method_name);
         */
        
        method_exchangeImplementations(meth, meth1);
        justPrint = @selector(speakcopy:);
        [c performSelector:justPrint withObject:[NSString stringWithString:@"Siddarth"]];
        justPrint = @selector(speak:);
        [c performSelector:justPrint withObject:[NSString stringWithString:@"Siddarth"]];
        
        
        //responds to selector does not work for class method
        
        myClass = object_getClass((id)c);
        NSLog(@"%@",myClass);
        
        meth = class_getClassMethod(myClass, @selector(initialize));
        NSLog(@"%@",meth?@"YES":@"NO");
        meth1 = class_getClassMethod(myClass, @selector(initializecopy));
        NSLog(@"%@",meth1?@"YES":@"NO");
        method_exchangeImplementations(meth, meth1);
        Dog * dog=[[Dog alloc] init];
        [Dog initialize];
        NSLog(@"%d",[dog somemethod]);
        
    
    
        IMP imp1 = method_getImplementation(meth);
        IMP imp2 = method_getImplementation(meth1);
        method_setImplementation(meth, imp2);
        method_setImplementation(meth1, imp1);
        dog=[[Dog alloc] init];
        [Dog initialize];
        NSLog(@"%d",[dog somemethod]);
    
        myClass = [c class];
    
        SEL originalSelector = @selector(justPrint);
        SEL swizzledSelector = @selector(justotherPrint);
    
        Method originalMethod = class_getInstanceMethod(myClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(myClass, swizzledSelector);
    
        newMethodIMP = imp_implementationWithBlock(^(id self) {
            for(int i=0;i<[[self numberOfLegs] intValue];i++)
            {
                NSLog(@"Leg no %d",i+2);
            }
        });
    
        BOOL didAddMethod =class_addMethod(myClass,swizzledSelector,newMethodIMP,method_getTypeEncoding(originalMethod));
    
        c=[[Dog alloc] init];
        [c performSelector:@selector(justPrint)];
        [c performSelector:@selector(justotherPrint)];
    
    
    
        swizzledMethod = class_getInstanceMethod(myClass, swizzledSelector);
        if (didAddMethod) {
            class_replaceMethod(myClass,swizzledSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
        }
    
        c=[[Dog alloc] init];
        [c performSelector:@selector(justPrint)];
        [c performSelector:@selector(justotherPrint)];
   
        NSLog(@"The class methods of dog are : ");
        int unsigned numMethods;
        Method *methods = class_copyMethodList(objc_getMetaClass("Dog"), &numMethods);
        for (int i = 0; i < numMethods; i++) {
            NSLog(@"---%@", NSStringFromSelector(method_getName(methods[i])));
        }
        free(methods);
    
    
        NSLog(@"The object methods of dog are : ");
        methods = class_copyMethodList(objc_getClass("Dog"), &numMethods);
        for (int i = 0; i < numMethods; i++) {
            NSLog(@"---%@", NSStringFromSelector(method_getName(methods[i])));
        }
        free(methods);
    
        NSLog(@"The class methods of animal are : ");
        methods = class_copyMethodList(objc_getMetaClass("Animal"), &numMethods);
        for (int i = 0; i < numMethods; i++) {
            NSLog(@"---%@", NSStringFromSelector(method_getName(methods[i])));
        }
        free(methods);
    
    
        NSLog(@"The object methods of animal are : ");
        methods = class_copyMethodList(objc_getClass("Animal"), &numMethods);
        for (int i = 0; i < numMethods; i++) {
            NSLog(@"---%@", NSStringFromSelector(method_getName(methods[i])));
        }
        free(methods);
    
        c=[[Dog alloc] init];
        NSLog(@"%@",class_respondsToSelector(myClass, @selector(justPrint))?@"YES":@"NO");
        NSLog(@"%@",class_respondsToSelector(myClass, @selector(justPrint))?@"YES":@"NO");
    
        objc_property_attribute_t type = { "T", "@\"NSString\"" };
        objc_property_attribute_t ownership = { "C", "" }; // C = copy
        objc_property_attribute_t backingivar  = { "V", "_privateName" };
        objc_property_attribute_t attrs[] = { type, ownership, backingivar };
        NSLog(@"%@",class_addProperty(myClass, "name", attrs, 3)?@"YES added the property":@"NO");
    
        c=[[Dog alloc] init];
        myClass = [c class];
    
        property = class_getProperty(myClass, "name");
        temp=[NSString stringWithFormat:@"%s-- %s ",property_getName(property),property_getAttributes(property)];
        NSLog(@"--%@",temp);
    
        //Doubt
    
        properties = class_copyPropertyList(myClass, &count);
        if(count)
        {
            NSLog(@"Properties of %s",(class_getName(myClass)));
            for(int i=0;i<count;i++)
            {
                objc_property_t property=properties[i];
                NSString *temp=[NSString stringWithFormat:@"%s %s ",property_getName(property),property_getAttributes(property)];
                NSLog(@"--%@",temp);
            
            }
        }
        else
        {
            NSLog(@"%s has 0 properties",(class_getName(myClass)));
        }
    
        NSLog(@"%@",class_conformsToProtocol(myClass, @protocol(MyProtocol))?@"YES":@"NO");
    
        SEL selector = @selector(hahahhahahaha:);
        NSLog(@"Selector: %@", NSStringFromSelector(selector));
    
        
        NSLog(@"Member of NSObject: %@", [c isMemberOfClass:[NSObject class]]?@"YES":@"NO");
        NSLog(@"Kind of NSObject: %@", [c isKindOfClass:[NSObject class]]?@"YES":@"NO");
        
        Class newClass = objc_allocateClassPair([c class], "Pomerian", 0);
    
    
        BOOL result=class_addIvar(newClass, "tail", sizeof(id), log2(sizeof(id)), @encode(id));
        NSLog(@"%@",result?@"YES":@"NO");
    
    
    
        newMethodIMP = imp_implementationWithBlock(^(id self) {
            for(int i=0;i<[[self numberOfLegs] intValue];i++)
            {
                NSLog(@"Leg no %d",i+1);
            }
        });
    
        initTypes = [[NSString stringWithFormat: @"%s%s",  @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(newClass, @selector(goodmethod), newMethodIMP, initTypes);
    
    
        objc_registerClassPair(newClass);
        id newObject = [[NSClassFromString(@"Pomerian") alloc] init];
    
    
        justPrint = @selector(goodmethod);
        [newObject performSelector:justPrint];
    
    
        newMethodIMP = imp_implementationWithBlock(^(id self) {
            for(int i=0;i<[[self numberOfLegs] intValue];i++)
            {
                NSLog(@"Leg no %d",i+3);
            }
        });
    
        initTypes = [[NSString stringWithFormat: @"%s%s",  @encode(id), @encode(SEL)] UTF8String];
        class_addMethod(newClass, @selector(justPrint), newMethodIMP, initTypes);
        justPrint = sel_registerName("justPrint");
        [newObject performSelector:justPrint];
    
    
        Ivar ivar=class_getInstanceVariable([newObject class], "tail");
        object_setIvar(newObject, ivar, @"abc");
    
    
    
        NSString *tail = object_getIvar(newObject, ivar);
        NSLog(@"%@",tail);
    
    
        NSLog(@"%s",object_getClassName(newObject));
    

        //doubt
        struct objc_super superInfo={
            newObject,
            [newObject superclass]
        };
    
        // objc_msgSendSuper(&superInfo,@selector(justPrint));
    
    
      int numClasses;
      Class *classes = NULL;
    
        classes = NULL;
        numClasses = objc_getClassList(NULL, 0);
        NSLog(@"Number of classes: %d", numClasses);
    
        if (numClasses > 0 )
        {
            classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
            numClasses = objc_getClassList(classes, numClasses);
            for (int i = 0; i < numClasses; i++) {
                NSLog(@"Class name: %s", class_getName(classes[i]));
            }
            free(classes);
        }
    
    NSLog(@"--------------");
    classes = NULL;
    
    
    unsigned ccount;
    classes = objc_copyClassList( &ccount );
    for (unsigned i=0 ; i<ccount ; i++) {
        if(class_getSuperclass(classes[i])==[c class])
        {
            NSLog(@"Class name: %s", class_getName(classes[i]));
        }
    }
    
    
    id handlerClass = objc_lookUpClass([@"Dog" cStringUsingEncoding:[NSString defaultCStringEncoding]]);
    id myObject = [[handlerClass alloc]init];
    NSLog(@"%d",[myObject somemethod]);
    
    meth = class_getClassMethod(myClass, @selector(initialize));
    NSLog(@"%s",method_getName(meth));
    NSLog(@"%s",method_copyReturnType(meth));
    
    
    return 0;
}
