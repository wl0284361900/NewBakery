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
@interface CompleteOrderViewController (){
    NSUserDefaults *orderUserDefault;
}
@property (strong, nonatomic) FIRFirestore *db;
@end



@implementation CompleteOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderUserDefault = [NSUserDefaults standardUserDefaults];
    
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableView.bounces = NO;
    
    //button
    [self.backHomeBtn addTarget:self action:@selector(clickBackHome) forControlEvents:UIControlEventTouchUpInside];
    
    self.db = [FIRFirestore firestore];
    [self readOrderFirebase];
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
    
    //從內存讀取 +1 之後 存入
    NSNumber *lCount;//第幾筆訂單   要儲存在內存：每次讀取舊的一筆資料，每次加一
    
    lCount = [NSNumber numberWithInteger:[orderUserDefault integerForKey:@"OrderListAmount"]+1];
    NSDictionary *parameterdic = @{
        @"pList":self.OrderSearchArr,
        @"OLTime": currentDateString,   //OL = orderList 訂單列表
        @"OLCount":lCount
    };
    
    
    [[[[[self.db collectionWithPath:@"OrderSearch"]documentWithPath:dic[@"name"]]collectionWithPath:@"OrderList"] documentWithPath:[NSString stringWithFormat:@"%d", [lCount intValue]]]setData:parameterdic completion:^(NSError * _Nullable error) {
        if(error != nil){
            //                    NSLog(@"Error writing document: %@", error);
        }else{
            //清除內存
            [self->orderUserDefault setObject:nil forKey:@"orderListTemp"];
            [self->orderUserDefault setObject:nil forKey:@"OrderListAmount"];
            [self->orderUserDefault synchronize];
            
            #warning 跳至首頁 且要發送「推播」 推播資料為[OrderSearch][userName]
            //跳至首頁
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
- (void)readOrderFirebase{
    //讀取
    //用成Singleton
    NSDictionary *nameDic = @{@"userName":[Singleton sharedInstance].userId};

    [[[[self.db collectionWithPath:@"OrderSearch"]documentWithPath:nameDic[@"userName"]]collectionWithPath:@"OrderList"]getDocumentsWithCompletion:^(FIRQuerySnapshot * _Nullable snapshot, NSError * _Nullable error) {
        [self->orderUserDefault setInteger:snapshot.count forKey:@"OrderListAmount"];
        [self->orderUserDefault synchronize];
    }];
}
@end
