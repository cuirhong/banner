//
//  CHImageScrollViewController.m
//  Scroll_Image
//
//  Created by apple on 16/11/8.
//  Copyright © 2016年 hong. All rights reserved.
//

#import "CHImageScrollViewController.h"
#import "UIView+SDAutoLayout.h"
#import "CHImageCollectionViewCell.h"

@interface CHImageScrollViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{

    UICollectionView *_collectionView;
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation CHImageScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initValue];
    [self setupUI];
  
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self settingAutoScroll];

    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.link.paused = YES;

}

- (void)settingAutoScroll{

    [NSTimer scheduledTimerWithTimeInterval:self.timeVlaue target:self selector:@selector(startAutoScrollImage) userInfo:nil repeats:NO];

}
- (void)startAutoScrollImage{

    self.link.paused = NO;

}

- (CADisplayLink *)link{

    @synchronized(self) {
        if (_link == nil) {
            _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScrollImage)];
            [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            _link.frameInterval = self.timeVlaue * 60;
        }
    }
    return _link;


}
- (void)autoScrollImage{
    
    NSIndexPath *indexPath = [[_collectionView indexPathsForVisibleItems] lastObject];

    
 
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    NSInteger index = (indexPath.item + 1) % self.imageModels.count;
    
     _pageControl.currentPage = index;
}

- (void)initValue{
    if (self.timeVlaue == 0) {
        self.timeVlaue = 2.5;
    }
    
    if (self.maxNum == 0) {
        self.maxNum = 1000000;
    }


}

- (void)setupUI{

    _collectionView = [self createdCollectionView];
    
    [self.view addSubview:_collectionView];
    
    _collectionView.sd_layout.leftEqualToView(_collectionView.superview).bottomEqualToView(_collectionView.superview).rightEqualToView(_collectionView.superview).topEqualToView(_collectionView.superview);
    
    _pageControl = [[UIPageControl alloc]init];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = self.imageModels.count;
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    _pageControl.sd_layout.centerXEqualToView(self.view);
    _pageControl.sd_layout.bottomEqualToView(self.view);
    _pageControl.sd_layout.heightIs(30);
    
}

- (UICollectionView*)createdCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.footerReferenceSize = CGSizeMake(0, 0);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    [collectionView registerClass:[CHImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self ;
    collectionView.delegate = self ;
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;

  
    return collectionView;
    


}



#pragma mark -  UICollectionViewDataSource,UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageModels.count == 0) {
        return 0;
    }
    return self.maxNum;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CHImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
 
    if (self.imageModels.count > 0) {
        NSInteger index = indexPath.item % self.imageModels.count;
        CHImageModel *imageModel = self.imageModels[index];
        if ([imageModel isKindOfClass:[CHImageModel class]]) {
            cell.imageModel = imageModel;
           
        }
    }  
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //解决选中之后返回item还处于选中状态，再次点击时没反应，需要点击两次才有反应
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickedImageWithImageModel:)]) {
        NSInteger index = indexPath.item % self.imageModels.count;
        CHImageModel *imageModel = self.imageModels[index];
        if ([imageModel isKindOfClass:[CHImageModel class]]) {
            [self.delegate didClickedImageWithImageModel:imageModel];
            
        }
    }
  
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.bounds.size;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{


    [self settingCurrentPageWithScrollView:scrollView];

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   

    [self settingCurrentPageWithScrollView:scrollView];
}

- (void)settingCurrentPageWithScrollView:(UIScrollView*)scrollView{
    NSInteger index = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    index =  index % self.imageModels.count;
    
    _pageControl.currentPage = index;


}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    
    self.link.paused = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self settingAutoScroll];


}

- (void)dealloc{

    [self.link invalidate];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
