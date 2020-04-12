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

#import <FirebaseFirestore/FirebaseFirestore.h>
@interface CompleteOrderViewController (){
    NSMutableArray *OrderArr;
}
@property (strong, nonatomic) FIRFirestore *db;
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
    
    //Firebase
    self.db = [FIRFirestore firestore];
    [self readOrderFirebase];
}

- (void)clickBackHome{
    
    //將"Prodcut"集合的所有文件裡面的值都寫入另外一個紀錄訂單的地方
    //刪除"Product"集合的所有文件（document）
    
    
    
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ProductListTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductListTableViewCell" owner:self options:nil]objectAtIndex:0];
    cell.oNumberLB.text = [NSString stringWithFormat:@"%ld", (indexPath.row + 1)];
    cell.oNameLB.text = OrderArr[indexPath.row][@"pName"];
    cell.oAmountLB.text = [NSString stringWithFormat:@"%ld", [OrderArr[indexPath.row][@"pAmount"] integerValue]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return OrderArr.count;
}

#pragma mark - Firebase
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mtableView reloadData];
        });
    }];
}
@end
