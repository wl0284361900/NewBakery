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
#import <FirebaseFirestore/FirebaseFirestore.h>
@interface ProductIntroduceViewController()<UITextFieldDelegate, UIGestureRecognizerDelegate>{
    UITapGestureRecognizer *clickBackground;
    NSMutableArray *OrderArr;
}
@property (strong, nonatomic) FIRFirestore *db;
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
    
    
    //資料庫
    self.db = [FIRFirestore firestore];
    OrderArr = [[NSMutableArray alloc]initWithCapacity:0];
    [self readOrderFirebase];
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
    //用Singleton取出使用者的姓名 or(該專屬ID)，暫時先用寫死的姓名
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale: [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *now = [[NSDate alloc]init];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *dic = @{@"name":@"ChunYi-Chan"};
    NSDictionary *pdic = @{@"productName":self.pNameStr};
    NSDictionary *parameterdic = @{
        @"pName":pdic[@"productName"],
        @"pAmount":[NSNumber numberWithInteger:[self.pTextField.text integerValue]],
        @"pTime": currentDateString
    };
//    NSLog(@"parameterdic Name:%@",parameterdic[@"pName"]);
    
    __block BOOL repeat = NO;
    
    [[[[[self.db collectionWithPath:@"Order"]documentWithPath:dic[@"name"]]collectionWithPath:@"Product"]queryWhereField:@"pName" isEqualTo:parameterdic[@"pName"]]getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        id document = snapshot.documents.firstObject;
        NSInteger amount = 0;
        for(NSDictionary *orderDic in self->OrderArr){
            if([orderDic[@"pName"] isEqualToString:parameterdic[@"pName"]]){
                amount = [self.pTextField.text integerValue] + [orderDic[@"pAmount"] integerValue];
                repeat = true;
                break;
            }
        }
        
        if(repeat){
            //如果有資料就累加上去
            [[document reference]updateData:@{
                @"pAmount": [NSNumber numberWithInteger:amount],
                @"pTime":currentDateString
            } completion:^(NSError * _Nullable error) {
                if(error){
                    //有可能因為沒開網路
//                    NSLog(@"%@",error.localizedDescription);
                }else{
                    ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:@"ConfirmViewController" bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:confirm animated:YES];
                }
            } ];
        }else{
            //若沒有就加入
            [[[[[self.db collectionWithPath:@"Order"]documentWithPath:dic[@"name"]]collectionWithPath:@"Product"]documentWithPath:parameterdic[@"pName"]]setData:parameterdic completion:^(NSError * _Nullable error) {
                if(error != nil){
//                    NSLog(@"Error writing document: %@", error);
                }else{
//                    NSLog(@"Document successfully written!");
                    ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:@"ConfirmViewController" bundle:[NSBundle mainBundle]];
                    [self.navigationController pushViewController:confirm animated:YES];
                }
                
            }];
        }
    }];
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

#pragma mark - Firebase
#pragma mark 讀取
- (void)readOrderFirebase{
    //讀取
    //用成Singleton
    NSDictionary *nameDic = @{@"userName":@"ChunYi-Chan"};
    
    [[[[[self.db collectionWithPath:@"Order"]documentWithPath:nameDic[@"userName"]]collectionWithPath:@"Product"] queryOrderedByField:@"pTime"] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot.count == 0){
            return;
        }
        for(FIRDocumentSnapshot *docSnapshot in snapshot.documents){
            [self->OrderArr addObject:docSnapshot.data];
        }
        
    }];
    
}
@end
