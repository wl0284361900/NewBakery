//
//  HomePageViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "HomePageViewController.h"
#import "ProductMenuCollectionViewCell.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface HomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSArray *productMenuArr;
    
    //決定mScrollView Content
    NSInteger spacing;
    NSInteger headSpacing;
    NSInteger btnSpacing;
    NSInteger btnTotalWidth;
    
    //collection
    
    
}


@property (weak, nonatomic) IBOutlet UIScrollView *mscrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *mcollectionView;

@end

static const CGFloat kColumnSpacing = 10.f; //列
static const CGFloat kRowSpacing = 10.f;    //行
static const CGFloat kCellMargins = 10.f;   //左右邊界
static const NSInteger kRowNumber = 2;      //一行顯示的Cell數

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    productMenuArr = [[NSArray alloc]initWithObjects:@"首頁",@"熱門商品",@"吐司類",@"蛋糕類",@"麵包類", nil];
    
    //button into scrollView(Frame)
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
    
    
    
    
    //collectionView creat
    self.mcollectionView.delegate = self;
    self.mcollectionView.dataSource = self;
    self.mcollectionView.pagingEnabled = NO;
    [self.mcollectionView registerNib:[UINib nibWithNibName:@"ProductMenuCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    
    
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


#pragma mark - CollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.pNameLb.adjustsFontSizeToFitWidth = YES;   //依照label寬度 自適應字體大小
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

#pragma mark - CollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //依照Cell的Size決定該Row顯示幾個Cell
    //kCellMargins = 左右邊界各10
    float width = (kScreenWidth - kRowSpacing - (kCellMargins * 2)) / kRowNumber;
    return CGSizeMake(width, width);
}

#pragma mark - CollectionViewFlowLayout
//边距设置:整体边距的优先级，始终高于内部边距的优先级
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, kRowSpacing, 15, kRowSpacing);
}

//item行與行的間距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kRowSpacing;
}
//item列與列的間距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kColumnSpacing;
}


@end
