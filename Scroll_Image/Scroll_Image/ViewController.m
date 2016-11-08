//
//  ViewController.m
//  Scroll_Image
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import "ViewController.h"

#import "CHImageScrollViewController.h"

#import "UIView+SDAutoLayout.h"

#import "CHImageModel.h"

@interface ViewController ()<CHDidClickedImageDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
  
    
    
    
}

- (void)setupUI{

    CHImageScrollViewController *controller = [[CHImageScrollViewController alloc]init];
    controller.delegate = self;
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        CHImageModel *imageModel = [[CHImageModel alloc]init];
        imageModel.imageName = [NSString stringWithFormat:@"%ld",i +1];
        imageModel.imageID = [NSString stringWithFormat:@"%ld",i +1];
        [array addObject:imageModel];
    }
    
    controller.imageModels = array;
 
    [self.view addSubview:controller.view];
    
    [self addChildViewController:controller];
    
    UIView *view = controller.view;
    view.sd_layout.leftEqualToView(self.view).rightEqualToView(self.view).topEqualToView(self.view);
    view.sd_layout.heightIs(self.view.bounds.size.height / 3.0);
   
    
}

- (void)didClickedImageWithImageModel:(CHImageModel *)imageModel{

    NSLog(@"%@",imageModel.imageID);


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
