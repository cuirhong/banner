//
//  CHImageCollectionViewCell.m
//  Scroll_Image
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import "CHImageCollectionViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "UIImageView+WebCache.h"
@interface CHImageCollectionViewCell ()
{

    UIImageView *_imageView;
}
@end
@implementation CHImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{

     self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        
        _imageView.sd_layout.leftEqualToView(_imageView.superview).rightEqualToView(_imageView.superview).bottomEqualToView(_imageView.superview).topEqualToView(_imageView.superview);
        
    }
    return self;
}

- (void)setImageModel:(CHImageModel *)imageModel{

    _imageModel = imageModel;
    if (imageModel.urlPath.length > 0) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.urlPath] placeholderImage:[UIImage imageNamed:imageModel.imageName]];
    }else{
     _imageView.image = [UIImage imageNamed:imageModel.imageName];
    }
   


}



@end
