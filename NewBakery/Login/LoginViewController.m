//
//  LoginViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "LoginViewController.h"
#import "HomePageViewController.h"

#import <FirebaseFirestore/FirebaseFirestore.h>
#import <FirebaseAuth/FirebaseAuth.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginViewController ()<FBSDKLoginButtonDelegate>{
    FBSDKAccessToken *accessToken;
    FIRAuthCredential *credential;
}
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *FBLoginBtn;
@property (strong, nonatomic) FIRFirestore *db;
@property (strong, nonatomic) FIRAuth *handle;
@property (strong, nonatomic) NSMutableArray *productArr;

@end
@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    //實作FB登入
    //Line登入
    self.FBLoginBtn.delegate = self;
    self.FBLoginBtn.permissions = @[@"public_profile",@"email"];
    
    self.productArr = [[NSMutableArray alloc]initWithCapacity:0];
    //資料庫初始化
    self.db = [FIRFirestore firestore];
    [self readFirebase];
    // child 是增加欄位
    //setvalue 是寫入欄位中的值
    
    //如果有取得token就直接登入
    if ([FBSDKAccessToken currentAccessToken]) {
        
        //要用一個小菊花等待 資料庫撈完資料
//        HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:[NSBundle mainBundle]];
//        home.tr_productArr = self.productArr;
//        [self.navigationController pushViewController:home animated:YES];
        [self readFirebase];
    }
    
    
}


- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    if(error == nil){
        if((accessToken = [FBSDKAccessToken  currentAccessToken])){
            if((credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken.tokenString])){
                [[FIRAuth auth] signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
                    if(error == nil){
                        //進入下一頁;
                        [self readFirebase];
                    }else{
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
        }
    }
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    NSLog(@"lout out");
}


- (void)readFirebase{
    //讀取 //撈該集合所有文件
    [[self.db collectionWithPath:@"ProductInfo"] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if(snapshot.count == 0){
            return;
        }
        for(FIRDocumentSnapshot *docSnapshot in snapshot.documents){
            [self->_productArr addObject:docSnapshot.data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"self.productArr:%@", self->_productArr);
            //跳下一頁
            HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
            home.tr_productArr = self.productArr;
            [self.navigationController pushViewController:home animated:YES];
        });
    }];
}
@end
