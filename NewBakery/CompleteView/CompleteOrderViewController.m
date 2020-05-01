//
//  CompleteOrderViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/12.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "CompleteOrderViewController.h"
#import "ProductListTableViewCell.h"
#import "HomePageViewController.h"

#import "Singleton.h"
#import <FirebaseFirestore/FirebaseFirestore.h>
@interface CompleteOrderViewController ()@property (strong, nonatomic) FIRFirestore *db;
@end



@implementation CompleteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableView.bounces = NO;
    
    //button
    [self.backHomeBtn addTarget:self action:@selector(clickBackHome) forControlEvents:UIControlEventTouchUpInside];
    
    self.db = [FIRFirestore firestore];
    
}

- (void)clickBackHome{
    
    //將"Prodcut"集合的所有文件裡面的值都寫入另外一個紀錄訂單的地方
    //刪除"Product"集合的所有文件（document）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale: [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hant_TW"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Taipei"]];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate *now = [[NSDate alloc]init];
    NSString *currentDateString = [formatter stringFromDate:now];
    
    NSDictionary *dic = @{@"name":[Singleton sharedInstance].userId};
//    NSDictionary *pdic = @{@"productName":self.pNameStr};
    
    //從內存讀取 +1 之後 存入
    NSNumber *lCount;//第幾筆訂單   要儲存在內存：每次讀取舊的一筆資料，每次加一
    NSUserDefaults *readDefaults = [NSUserDefaults standardUserDefaults];
    lCount = [NSNumber numberWithInteger:[readDefaults integerForKey:@"OrderListAmount"]];
    if([lCount intValue] == 0){
        lCount = [NSNumber numberWithInteger:1];
    }
    NSLog(@"lCount:%d", [lCount intValue]);
    
   
//
    NSDictionary *parameterdic = @{
        @"pList":self.OrderSearchArr,
        @"OLTime": currentDateString,   //OL = orderList 訂單列表
        @"OLCount":lCount
    };
    
    
    [[[[[self.db collectionWithPath:@"OrderSearch"]documentWithPath:dic[@"name"]]collectionWithPath:@"OrderList"] documentWithPath:[NSString stringWithFormat:@"%d", [lCount intValue]]]setData:parameterdic completion:^(NSError * _Nullable error) {
        if(error != nil){
            //                    NSLog(@"Error writing document: %@", error);
        }else{
            //刪除該資料庫文件
            for(int i =0 ; i < self.OrderSearchArr.count; i++){
                [[[[[self.db collectionWithPath:@"Order"]documentWithPath:dic[@"name"]]collectionWithPath:@"Product"] documentWithPath:self.OrderSearchArr[i][@"pName"]]deleteDocument];
            }
         
            //應該是要讀資料庫裡面的資料有幾筆，然後加一（ＹＥＳ）
            //在內存 將訂單列表+1（ＮＯ）
            NSUserDefaults *writeDefaults = [NSUserDefaults standardUserDefaults];
            [writeDefaults setInteger:([lCount integerValue]+1) forKey:@"OrderListAmount"]; //訂單列表
            [writeDefaults synchronize];
            
            #warning 跳至首頁 且要發送「推播」 推波資料為[OrderSearch][userName]
            HomePageViewController *home = [[HomePageViewController alloc]init];
            UIViewController *target = nil;
            
            for(UIViewController *controller in self.navigationController.viewControllers){
                if([controller isKindOfClass:[home class]]){
                    target = controller;
                }
            }
            if(target){
                [self.navigationController popToViewController:target animated:YES];
            }

        }
    }];
    
    
//    HomePageViewController *home = [[HomePageViewController alloc]init];
//    UIViewController *target = nil;
//
//    for(UIViewController *controller in self.navigationController.viewControllers){
//        if([controller isKindOfClass:[home class]]){
//            target = controller;
//        }
//    }
//    if(target){
//        [self.navigationController popToViewController:target animated:YES];
//    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductListTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductListTableViewCell" owner:self options:nil]objectAtIndex:0];
    cell.oNumberLB.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    cell.oNameLB.text = self.OrderSearchArr[indexPath.row][@"pName"];
    cell.oAmountLB.text = [NSString stringWithFormat:@"%ld", [self.OrderSearchArr[indexPath.row][@"pAmount"] integerValue]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.OrderSearchArr.count;
}

#pragma mark - Firebase
//- (void)readOrderFirebase{
//    //讀取
//    //用成Singleton
//    NSDictionary *nameDic = @{@"userName":@"ChunYi-Chan"};
//
//    [[[[[self.db collectionWithPath:@"Order"]documentWithPath:nameDic[@"userName"]]collectionWithPath:@"Product"] queryOrderedByField:@"pTime"] getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
//        if(snapshot.count == 0){
//            return;
//        }
//        for(FIRDocumentSnapshot *docSnapshot in snapshot.documents){
////            [self->OrderArr addObject:docSnapshot.data];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.mtableView reloadData];
//        });
//    }];
//}
@end
