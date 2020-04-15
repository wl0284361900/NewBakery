//
//  ConfirmViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/10.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ConfirmViewController.h"
#import "ProductListTableViewCell.h"
#import "HomePageViewController.h"
#import "CompleteOrderViewController.h"

#import <FirebaseFirestore/FirebaseFirestore.h>
@interface ConfirmViewController (){
    NSMutableArray *OrderArr;
}
@property (strong, nonatomic) FIRFirestore *db;
@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableView.bounces = NO;
    
    //UIButton
    [self.confirmBtn addTarget:self action:@selector(clickConfirmProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(clickDeleteProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(clickBackLastView) forControlEvents:UIControlEventTouchUpInside];
    
    OrderArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.db = [FIRFirestore firestore];
    [self readOrderFirebase];
}

- (void) clickConfirmProduct{
    CompleteOrderViewController *complete = [[CompleteOrderViewController alloc]initWithNibName:@"CompleteOrderViewController" bundle:nil];
    complete.OrderSearchArr = OrderArr;
    [self.navigationController pushViewController:complete animated:YES];
}

- (void) clickDeleteProduct{
    //TableView的編輯、刪除
    //刪除資料庫內所點選的麵包產品
}

- (void) clickBackLastView{
    //返回到Home
    HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
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
    //資料庫的訂單有幾筆資料
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
//            NSLog(@"%@",docSnapshot.data);
            [self->OrderArr addObject:docSnapshot.data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mtableView reloadData];
        });
    }];
    
}
@end
