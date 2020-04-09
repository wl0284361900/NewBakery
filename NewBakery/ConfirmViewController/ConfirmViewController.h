//
//  ConfirmViewController.h
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/10.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConfirmViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(weak, nonatomic) IBOutlet UITableView *mtableView;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

NS_ASSUME_NONNULL_END
