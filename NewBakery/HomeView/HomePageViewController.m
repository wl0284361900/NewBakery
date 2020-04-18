//
//  HomePageViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "HomePageViewController.h"
#import "ProductMenuCollectionViewCell.h"
#import "ProductIntroduceViewController.h"

#import <SDWebImage/SDWebImage.h>
#import <FirebaseFirestore/FirebaseFirestore.h>


typedef enum productType{
    Bread,
    Snack,
    Toast
}productType;

@interface HomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
//    productType type;
    
    NSArray *productMenuArr;    //scrollView上的種類
    NSMutableArray *productArr; //所有商品
    NSMutableArray *allProductArr;  //首頁
    NSMutableArray *popularArr;     //熱門
    NSMutableArray *breadArr;       //麵包類
    NSMutableArray *SnackArr;       //點心類
    NSMutableArray *ToastArr;       //吐司類
    NSMutableArray *btnMutArr;  //用來存放所有ProductMenuBtn的陣列
    
    //決定mScrollView Content
    NSInteger spacing;
    NSInteger headSpacing;
    NSInteger btnSpacing;
    NSInteger btnTotalWidth;
    NSInteger btnTag;
    
    //列表陣列 暫放這
    NSMutableArray *orderListArr;
}

@property (strong, nonatomic) FIRFirestore *db;

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
    
    self.db = [FIRFirestore firestore];
    //暫用
    [self.sideMenuBtn addTarget:self action:@selector(ClickTmpBack) forControlEvents:UIControlEventTouchUpInside];
    //佔用：訂單列表顯示
    orderListArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self.soundBtn addTarget:self action:@selector(readOrderSearchFirebase) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    productMenuArr = [[NSArray alloc]initWithObjects:@"首頁",@"熱門商品",@"吐司類",@"蛋糕類",@"麵包類", nil];
    productArr = [[NSMutableArray alloc]initWithCapacity:0];
    allProductArr = [NSMutableArray arrayWithArray:self.tr_productArr];
    popularArr = [[NSMutableArray alloc]initWithCapacity:0];
    breadArr = [[NSMutableArray alloc]initWithCapacity:0];
    SnackArr = [[NSMutableArray alloc]initWithCapacity:0];
    ToastArr = [[NSMutableArray alloc]initWithCapacity:0];
    //分類
    for(NSDictionary *dic in allProductArr){
        if([dic[@"popular"] isEqualToNumber:@1]){
            [popularArr addObject:dic];
        }
        
        switch ([dic[@"type"] integerValue]) {
            case Bread:
                [breadArr addObject:dic];
                break;
            case Snack:
                [SnackArr addObject:dic];
                break;
            case Toast:
                [ToastArr addObject:dic];
                break;
            default:
                break;
        }
    }
    //初始化是顯示所有商品（首頁）
    productArr = allProductArr;
    
        

    //collectionView creat
    self.mcollectionView.delegate = self;
    self.mcollectionView.dataSource = self;
    self.mcollectionView.pagingEnabled = NO;
    [self.mcollectionView registerNib:[UINib nibWithNibName:@"ProductMenuCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];

}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"123");
    allProductArr = [NSMutableArray arrayWithArray:self.tr_productArr];
    
    //button into scrollView(Frame)
    //創建button
    btnTotalWidth = 0;
    btnSpacing = 0;
    btnTag = 0;
    btnMutArr = [[NSMutableArray alloc]initWithCapacity:0];
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

    //初始化是顯示所有商品（首頁）
    productArr = allProductArr;
    [self.mcollectionView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    //離開此頁面 初始化
    for(UIButton *btn in btnMutArr){
        [btn removeFromSuperview];
    }
    
    //回滾到初始化
    [self.mcollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.mscrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

//暫時用
- (void)ClickTmpBack{
    [self.navigationController popViewControllerAnimated:YES];
}


//button創建的function
- (UIButton *)creatButton:(NSString *)title{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    // 順序不能改變
    if(btnTag == 0){
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
    }else{
        [btn.titleLabel setFont:[UIFont fontWithName:@"System" size:17.0f]];
    }
    [btn sizeToFit];    //button大小自適應字體大小
    btn.center = CGPointMake(0, self.mscrollView.frame.size.height * 0.5);
    btn.frame = CGRectMake(btnSpacing+btnTotalWidth, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    btn.tag = btnTag;
    btnTag++;
    [btn addTarget:self action:@selector(clickProductMenu:) forControlEvents:UIControlEventTouchUpInside];
    [btnMutArr addObject:btn];
    return btn;
}

- (void)clickProductMenu:(UIButton *)sender{
    //所有按鈕初始化
    for(UIButton *btn in btnMutArr){
        [btn.titleLabel setFont:[UIFont fontWithName:@"System" size:17.0f]];
    }
    
    //加粗
    [sender.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20.0f]];
    [sender sizeToFit];
    
    switch (sender.tag) {
        case 0:
            productArr = allProductArr;
            break;
        case 1:
            productArr = popularArr;
            break;
        case 2:
            productArr = ToastArr;
            break;
        case 3:
            productArr = SnackArr;
            break;
        case 4:
            productArr = breadArr;
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mcollectionView reloadData];
    });
    
    
}
#pragma mark - Firebase
- (void)readOrderSearchFirebase{
    //讀取
    //用成Singleton
    NSDictionary *nameDic = @{@"userName":@"ChunYi-Chan"};

    [[[[[self.db collectionWithPath:@"OrderSearch"] documentWithPath:nameDic[@"userName"]]collectionWithPath:@"OrderList"] queryOrderedByField:@"OLCount"] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot.count == 0){
            return;
        }
        for(FIRDocumentSnapshot *docSnapshot in snapshot.documents){
            [self->orderListArr addObject:docSnapshot.data];
        }
        NSLog(@"列出訂單：%@", self->orderListArr);
    }];
}


#pragma mark - CollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.pNameLb.adjustsFontSizeToFitWidth = YES;   //依照label寬度 自適應字體大小
    cell.pNameLb.text = productArr[indexPath.row][@"name"];
    
    //麵包圖片
    [cell.pImg sd_setImageWithURL:[NSURL URLWithString:productArr[indexPath.row][@"img"]]];
    
    //判斷該麵包是哪一種種類 對應 背景圖
    switch ([productArr[indexPath.row][@"type"]integerValue]) {
        case Bread:
            cell.pBGImg.image = [UIImage imageNamed:@"BreadMenuBG.png"];
            break;
        case Snack:
            cell.pBGImg.image = [UIImage imageNamed:@"CakeMenuBG.png"];
            break;
        case Toast:
            cell.pBGImg.image = [UIImage imageNamed:@"ToastMenuBG.png"];
            break;
        default:
            break;
    }
    
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return productArr.count;
}

#pragma mark - CollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductIntroduceViewController *introduce = [[ProductIntroduceViewController alloc]initWithNibName:@"ProductIntroduceViewController" bundle:[NSBundle mainBundle]];
    introduce.pNameStr = productArr[indexPath.row][@"name"];
    introduce.pContentStr = productArr[indexPath.row][@"content"];
    introduce.pImgStr = productArr[indexPath.row][@"img"];
    [self.navigationController pushViewController:introduce animated:YES];
}

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
