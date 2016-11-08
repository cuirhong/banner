//
//  CHImageScrollViewController.h
//  Scroll_Image
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CHImageModel;

@protocol CHDidClickedImageDelegate <NSObject>

- (void)didClickedImageWithImageModel:(CHImageModel*)imageModel;

@end

@interface CHImageScrollViewController : UIViewController

@property (nonatomic, assign) id<CHDidClickedImageDelegate>delegate;

@property (nonatomic, copy) NSArray *imageModels;

@property (nonatomic, assign) NSInteger timeVlaue;

@property (nonatomic, assign) NSInteger maxNum;






@end
