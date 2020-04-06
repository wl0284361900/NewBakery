//
//  ProductIntroduceViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/7.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ProductIntroduceViewController.h"

@interface ProductIntroduceViewController ()

@end

@implementation ProductIntroduceViewController

/*
 1. 不要顯示navigationBarItem
 2. 將所選的商品名、內容傳到此頁顯示在pNamelb、pContentlb
 3. TextField 點擊 要將整個畫面往上移
 4. 注意TextField輸入過多數字的bug
 5. contentlb 記得[lb sizeToFit];
 6. 測試看看content內容過多會蓋到TextField 要有字數限制。
 7. 按下確認將商品名、商品量 存入資料庫
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
