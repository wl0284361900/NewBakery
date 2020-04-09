//
//  ProductIntroduceViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/7.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ProductIntroduceViewController.h"
#import "ConfirmViewController.h"
#import <SDWebImage/SDWebImage.h>
@interface ProductIntroduceViewController()<UITextFieldDelegate, UIGestureRecognizerDelegate>{
    UITapGestureRecognizer *clickBackground;
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
    // Do any additional setup after loading the view from its nib.
    [self.pImg sd_setImageWithURL:[NSURL URLWithString:self.pImgStr]];
    self.pNamelb.text = self.pNameStr;
    self.pContentlb.text = self.pContentStr;
    
    //Button Setting
    [self.backBtn addTarget:self action:@selector(clickBackToView) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn addTarget:self action:@selector(clickPushConfirmView) forControlEvents:UIControlEventTouchUpInside];
    
    //UITextField
    self.pTextField.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    clickBackground = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardHide)];
    clickBackground.delegate = self;
    [self.view addGestureRecognizer:clickBackground];
    
//    clickBackground.cancelsTouchesInView
}

#pragma mark - Button Action
- (void)clickBackToView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickPushConfirmView{
    ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:@"ConfirmViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:confirm animated:YES];
}

#pragma mark - TextFieldDeleagte
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self keyboardHide];
}

#pragma mark - NSNotificationCenter
- (void)keyboardShow{
    self.view.superview.frame = CGRectMake(0, -250, kScreenWidth, kScreenHeight);
}

- (void)keyboardHide{
    [self.pTextField resignFirstResponder];
//    self.topContraint.constant = 0.1f;
    self.view.superview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}
@end
