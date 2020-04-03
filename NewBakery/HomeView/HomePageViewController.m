//
//  HomePageViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController (){
    NSArray *productMenuArr;
    
    //決定mScrollView Content
    NSInteger spacing;
    NSInteger headSpacing;
    NSInteger btnSpacing;
    NSInteger btnTotalWidth;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mscrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *mcollectionView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    productMenuArr = [[NSArray alloc]initWithObjects:@"首頁",@"熱門商品",@"吐司類",@"蛋糕類",@"麵包類", nil];
    
    
    //創建button
    btnTotalWidth = 0;
    btnSpacing = 0;
    for(int i = 0; i < 5; i++){
        if(i == 0){
            headSpacing = 30;
            spacing = 0;
        }else{
            headSpacing = 0;
            spacing = 40;
        }
        btnSpacing += (spacing + headSpacing);
        UIButton *btn = [self creatButton:productMenuArr[i]];
        btnTotalWidth += btn.frame.size.width;
        [_mscrollView addSubview:btn];
        
    }
    headSpacing = 30;
    //設定scrollView content size
    _mscrollView.contentSize = CGSizeMake((spacing * (productMenuArr.count - 1))+ btnTotalWidth + (headSpacing * 2), 0);
    
    
    //button into scrollView(Frame)
    
    //collectionView creat
    
}

//button創建的function
- (UIButton *)creatButton:(NSString *)title{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    // 順序不能改變
    btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [btn sizeToFit];    //button大小自適應字體大小
    btn.center = CGPointMake(0, self.mscrollView.frame.size.height * 0.5);
    btn.frame = CGRectMake(btnSpacing+btnTotalWidth, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    return btn;
}



@end
