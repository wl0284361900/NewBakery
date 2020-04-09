//
//  ConfirmViewController.m
//  NewBakery
//
//  Created by CHANCHUN-YI on 2020/4/10.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

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
}

- (void) clickConfirmProduct{
    
}

- (void) clickDeleteProduct{
    //TableView的編輯、刪除
    //刪除資料庫內所點選的麵包產品
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    <#code#>
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //資料庫的訂單有幾筆資料
}



@end
