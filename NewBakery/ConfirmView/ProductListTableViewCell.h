//
//  ProductListTableViewCell.h
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/10.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *oNameLB;
@property (weak, nonatomic) IBOutlet UILabel *oAmountLB;


@end

NS_ASSUME_NONNULL_END
