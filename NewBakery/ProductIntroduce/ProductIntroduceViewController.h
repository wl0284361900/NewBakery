//
//  ProductIntroduceViewController.h
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/7.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductIntroduceViewController : UIViewController

@property (strong, nonatomic) NSString *pNameStr;
@property (strong, nonatomic) NSString *pContentStr;
@property (strong, nonatomic) NSString *pImgStr;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraint;

@property (weak, nonatomic) IBOutlet UIImageView *pImg;
@property (weak, nonatomic) IBOutlet UILabel *pNamelb;
@property (weak, nonatomic) IBOutlet UILabel *pContentlb;
@property (strong, nonatomic) IBOutlet UITextField *pTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

NS_ASSUME_NONNULL_END
