//
//  ViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ViewController.h"
#import "HomePageViewController.h"

#import <FirebaseFirestore/FirebaseFirestore.h>

@interface ViewController ()
@property (strong, nonatomic) FIRFirestore *db;
@property (strong, nonatomic) NSMutableArray *productArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 30.0];
    [btn setTitle:@"click me" forState:UIControlStateNormal];
    [btn sizeToFit];
    NSLog(@"width:%f height:%f", btn.frame.size.width, btn.frame.size.height);
    
    
    btn.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    [btn addTarget:self action:@selector(nextView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    self.productArr = [[NSMutableArray alloc]initWithCapacity:0];
    //資料庫初始化
    self.db = [FIRFirestore firestore];
    [self readFirebase];
    //建資料庫
//    NSArray *name = [NSArray arrayWithObjects:@"芋頭麵包",@"萬聖節餅乾",@"蔓越梅乳酪貝果",@"豬油香蔥麵包",@"丹麥紅豆吐司",@"可可藍莓",@"培根洋蔥吐司",@"起司火腿吐司",@"楓糖吐司",@"極致鮮乳吐司",@"蜂蜜吐司", nil];
//    NSArray *content = [NSArray arrayWithObjects:@"日本古早味「餡麵包」，打麵糰時需避免打出筋性，口感介於麵包與蛋糕間，餡裡吃得到芋頭角，更添層次。",@"使用奶油餅乾和巧克力餅乾壓膜製程萬聖節限定點心，可愛的照型讓萬聖節的氣氛充滿你的味蕾。",@"貝果充滿嚼勁的口感配上酸甜的蔓越梅果乾，利用乳酪加以融合，創照出新的層次。",@"低溫長時間發酵，口感鬆軟有彈性，好吃的祕訣是進烤箱前才將青蔥切碎製作蔥餡，保留水分及新鮮度。",@"層層疊疊的丹麥麵糰，包覆著頂級鮮奶製作的卡士達醬，拌入特製蜜漬紅豆，甜、香、軟、脆在口中一起融化。",@"當季現做的藍莓醬配上香甜的可可將，看似衝突的口味卻融合出新的口感。",@"麵糰以低溫發酵一晚 包入有嚼勁的培根及乳酪塊內餡再灑上洋蔥及乳酪絲，鬆軟爽口。",@"將鬆軟的吐司內包入鹹香的火腿片再配上乳酪絲，配上爽脆的生菜，爽口的口感適合夏天的早晨。",@"來自日本的楓糖餡，比巧克力更柔軟，散發特有甜香，令人滿足的大口享受。",@"全鮮乳製作，不加一滴水，鮮乳與麵粉的比例與發酵時間是製作關鍵，光是單吃就相當柔軟，乳香極為濃郁。",@"直接將龍眼蜜拌入麵糰，因為蜂蜜會抑制麵糰的發酵，所以加入老麵提升效率及風味，口感軟潤、蜜香濃。", nil];
//    NSArray *type = [NSArray arrayWithObjects:@"麵包類",@"點心類",@"麵包類",@"麵包類",@"吐司類",@"吐司類",@"吐司類",@"吐司類",@"吐司類",@"吐司類",@"吐司類", nil];
//    NSArray *img = [NSArray arrayWithObjects:
//                    @"https://imgur.com/vptJ8dr.jpg",
//                    @"https://imgur.com/PH09zaQ.jpg",
//                    @"https://imgur.com/pCU4pgs.jpg",
//                    @"https://imgur.com/MLzMUGn.jpg",
//                    @"https://i.imgur.com/4uTCzeJ.jpg",
//                    @"https://i.imgur.com/LqkXPU1.jpg",
//                    @"https://imgur.com/fE1TPWk.jpg",
//                    @"https://i.imgur.com/9bmUIov.jpg",
//                    @"https://imgur.com/nMp5mSZ.jpg",
//                    @"https://imgur.com/TI7d4zZ.jpg",
//                    @"https://imgur.com/T2cHwYB.jpg", nil];
//
//    for(int i = 0; i < name.count; i++){
//        int random = (arc4random() % 100) + 25;
//        NSDictionary *dict = @{@"name":name[i],
//                               @"content":content[i],
//                               @"price":[NSNumber numberWithInt:random],
//                               @"type":type[i],
//                               @"img":img[i],
//        };
//
//        [self writeFirebase:dict];
//
//    }
    
    
    
    
    
    
}


- (void) nextView{
    HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:[NSBundle mainBundle]];
    home.productArr = self.productArr;
    [self.navigationController pushViewController:home animated:YES];
    
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
            NSLog(@"self.productArr:%@", self->_productArr);
        });
    }];
}

//- (void)writeFirebase:(NSDictionary *)dic{
//    //隨機產生document ID
//    __block FIRDocumentReference *ref =
//    [[self.db collectionWithPath:@"ProductInfo"] addDocumentWithData:dic completion:^(NSError * _Nullable error) {
//      if (error != nil) {
//        NSLog(@"Error adding document: %@", error);
//      } else {
//        NSLog(@"Document added with ID: %@", ref.documentID);
//      }
//    }];
//}
@end
