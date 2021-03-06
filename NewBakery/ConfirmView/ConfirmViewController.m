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

#import "Singleton.h"
@interface ConfirmViewController (){
    NSMutableArray *OrderArr;
    NSUserDefaults *orderUserDefault;
}

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    orderUserDefault = [NSUserDefaults standardUserDefaults];
    OrderArr = [[NSMutableArray alloc]initWithArray: [orderUserDefault objectForKey:@"orderListTemp"]];
    
    self.mtableView.delegate = self;
    self.mtableView.dataSource = self;
    self.mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableView.bounces = NO;
    
    //UIButton
    [self.confirmBtn addTarget:self action:@selector(clickConfirmProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteBtn addTarget:self action:@selector(clickDeleteProduct) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(clickBackLastView) forControlEvents:UIControlEventTouchUpInside];
}

- (void) clickConfirmProduct{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否確定資料" message:[NSString stringWithFormat:@"確認訂單資料無誤，一但確定就無法更改資料"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CompleteOrderViewController *complete = [[CompleteOrderViewController alloc]initWithNibName:@"CompleteOrderViewController" bundle:nil];
        complete.OrderSearchArr = self->OrderArr;
        [self.navigationController pushViewController:complete animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void) clickDeleteProduct{
    //TableView的編輯、刪除
    //刪除資料庫內所點選的麵包產品
    self.mtableView.editing = YES;
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

#pragma mark - TableView DataSource
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

#pragma mark - TableView Delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"刪除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"刪除該筆資料" message:[NSString stringWithFormat:@"是否要刪除「%@」",OrderArr[indexPath.row][@"pName"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->OrderArr removeObjectAtIndex:indexPath.row];
        [self->orderUserDefault setObject:self->OrderArr forKey:@"orderListTemp"];
        [self->orderUserDefault synchronize];
        //刷新？？？
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.mtableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
