//
//  Singleton.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/5/1.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

+(instancetype)sharedInstance{
    static Singleton *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Singleton alloc]init];
    });
    return instance;
}

@end
