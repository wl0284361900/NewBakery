//
//  ProductIntroduceViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/7.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ProductIntroduceViewController.h"
#import "ConfirmViewController.h"

#import "Singleton.h"
#import <SDWebImage/SDWebImage.h>
@interface ProductIntroduceViewController()<UITextFieldDelegate, UIGestureRecognizerDelegate>{
    UITapGestureRecognizer *clickBackground;
    NSMutableArray *OrderArr;
    NSUserDefaults *orderUserDefault;
}
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

    self.pContentTV.editable = NO;
    
    [self.pImg sd_setImageWithURL:[NSURL URLWithString:self.pImgStr]];
    self.pNamelb.text = self.pNameStr;
    self.pContentTV.text = self.pContentStr;
    
    //Button Setting
    self.backBtn.enabled = YES;
    self.confirmBtn.enabled = YES;
    [self.backBtn addTarget:self action:@selector(clickBackToView) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(clickPushConfirmView) forControlEvents:UIControlEventTouchUpInside];
    
    //UITextField
    self.pTextField.delegate = self;
    
    //監聽鍵盤
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    clickBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide)];
    clickBackground.delegate = self;
    [self.view addGestureRecognizer:clickBackground];
    
}
- (void)viewWillAppear:(BOOL)animated{
    //初始化
    orderUserDefault = [NSUserDefaults standardUserDefaults];
    if([orderUserDefault objectForKey:@"orderListTemp"] != nil){
        OrderArr = [[NSMutableArray alloc]initWithArray:[orderUserDefault objectForKey:@"orderListTemp"]];
    }else{
        OrderArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [self keyboardHide];
}

#pragma mark - Button Action
#pragma mark 返回上一頁
- (void)clickBackToView{
    self.backBtn.enabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 確定訂單
- (void)clickPushConfirmView{
    self.confirmBtn.enabled = NO;
    
    //寫入資料
    //時間
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale: [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *now = [[NSDate alloc]init];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *pdic = @{@"productName":self.pNameStr};
    NSDictionary *parameterdic = @{
        @"pName":pdic[@"productName"],
        @"pAmount":[NSNumber numberWithInteger:[self.pTextField.text integerValue]],
        @"pTime": currentDateString
    };

    
    
    //線性搜尋（資料量大的時候不適用）
    //如果目前這筆資料已存在就移除舊資料，新增新的。
    for(int i = 0; i < OrderArr.count; i++){
        if(pdic[@"productName"] == OrderArr[i][@"pName"]){
            [OrderArr removeObjectAtIndex:i];
            break;
        }
    }
    //如果沒有存在就存到內存裡面
    [OrderArr addObject:parameterdic];
    [orderUserDefault setObject:OrderArr forKey:@"orderListTemp"];
    [orderUserDefault synchronize];
    
    ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:@"ConfirmViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:confirm animated:YES];
}


#pragma mark - TextFieldDeleagte
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardHide];
}

#pragma mark - NSNotificationCenter
- (void)keyboardShow{
    self.view.superview.frame = CGRectMake(0, -250, kScreenWidth, kScreenHeight);
}

- (void)keyboardHide{
    [self.pTextField resignFirstResponder];
    self.view.superview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

@end
