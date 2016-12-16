//
//  ViewController.m
//  HTAssetsPickerDemo
//
//  Created by cxq on 19/10/2016.
//  Copyright © 2016 cxq. All rights reserved.
//

#import "ViewController.h"
#import "HTAssetsPickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadTestButton];
    
}

- (void)loadTestButton{
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 50, self.view.bounds.size.height/2 - 100, 100, 100)];
    testButton.backgroundColor = [UIColor redColor];
    [testButton setTitle:@"开始测试" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(startTest) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}

- (void)startTest{
    HTAssetsPickerViewController *controller = [HTAssetsPickerViewController new];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
