//
//  Singleton.h
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/5/1.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSMutableArray *orderListTemp;

+ (instancetype) sharedInstance;

@end

NS_ASSUME_NONNULL_END
