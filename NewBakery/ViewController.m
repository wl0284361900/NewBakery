//
//  ViewController.m
//  NewBakery
//
//  Created by ChunYi on 2020/4/3.
//  Copyright © 2020 ES711-apple-2. All rights reserved.
//

#import "ViewController.h"
#import "HomePageViewController.h"
@interface ViewController ()

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

}

- (void) nextView{
    HomePageViewController *home = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:home animated:YES];
    
}
@end
