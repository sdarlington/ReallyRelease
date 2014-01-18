//
//  NSObject+ReallyRelease.m
//  ReallyRelease
//
//  Created by Stephen Darlington on 18/01/2014.
//  Copyright (c) 2014 Wandle Software Limited. All rights reserved.
//

#import "NSObject+ReallyRelease.h"
#import <objc/runtime.h>

@implementation NSObject (ReallyRelease)

- (void)reallyRelease {
    while ([self retainCount] > 0) [self reallyRelease];
}

+ (void)load {
    SEL originalSelector = @selector(release);
    SEL overrideSelector = @selector(reallyRelease);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

@end
