//
//  ProductMenuCollectionViewCell.h
//  NewBakery
//
//  Created by ChunYi on 2020/4/4.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductMenuCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pImg;
@property (weak, nonatomic) IBOutlet UILabel *pNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *pBGImg;
@end

NS_ASSUME_NONNULL_END
