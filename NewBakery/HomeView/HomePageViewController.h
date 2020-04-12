//
//  HomePageViewController.h
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *sideMenuBtn;

@property (strong, nonatomic) NSMutableArray *tr_productArr;
@end

NS_ASSUME_NONNULL_END
