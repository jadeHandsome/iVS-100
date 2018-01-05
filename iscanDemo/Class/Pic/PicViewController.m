//
//  PicViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/3.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "PicViewController.h"
#import "CollectionViewCell.h"
#import "CLTreeViewNode.h"
#import "SDPhotoBrowser.h"
@interface PicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowyout;
@property (nonatomic, strong) NSMutableArray *allPic;
@property (nonatomic, assign) NSInteger page;
@end

@implementation PicViewController
- (NSMutableArray *)allPic {
    if (!_allPic) {
        _allPic = [NSMutableArray array];
    }
    return _allPic;
}
-(UICollectionViewFlowLayout *)collectionFlowyout{
    
    if (_collectionFlowyout == nil) {
        
        _collectionFlowyout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionFlowyout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*0.5, 285);
        
        _collectionFlowyout.minimumLineSpacing = 0;
        
        _collectionFlowyout.minimumInteritemSpacing = 0;
        
    }
    
    return _collectionFlowyout;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCole];
    [self headerFresh];
    self.view.backgroundColor = LRRGBColor(236, 236, 236);
    
}
- (void)setUpCole {
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.collectionFlowyout];
    [self.view addSubview:self.collectionView];
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.collectionView.backgroundColor = LRRGBColor(244, 244, 244);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"colleCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
//    [self.collectionView registerClass:[KRListCollCollectionViewCell class] forCellWithReuseIdentifier:@"collCell"];
    [KRBaseTool tableViewAddRefreshFooter:self.collectionView withTarget:self refreshingAction:@selector(footerFresh)];
    [KRBaseTool tableViewAddRefreshHeader:self.collectionView withTarget:self refreshingAction:@selector(headerFresh)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.allPic.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colleCell" forIndexPath:indexPath];
    cell.row = indexPath.row;
    __weak typeof(self) weakSelf = self;
    cell.backgroundColor = [UIColor clearColor];
    __weak typeof(cell) weakCell = cell;
    cell.block = ^(NSInteger tags) {
//        UIView *imageView = tap.view;
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = tags;
        browser.sourceImagesContainerView = weakCell;
        //NSLog(@"%ld",self.scrollView.subviews.count);
        browser.imageCount = weakSelf.allPic.count;
        browser.delegate = weakSelf;
        [browser show];
    };
    [cell setDataWith:self.allPic[indexPath.row]];
    return cell;
}
- (void)footerFresh {
    self.page = 1;
    [self loadData];
}
- (void)headerFresh {
    self.page ++;
    [self loadData];
}
- (void)loadData {
    
//    -(ASIHTTPRequest *)findCaptureImgList:(NSString *)hostUrl Vid:(NSString *)vid StartTime:(NSString *)start EndTime:(NSString *)end Target:(id)target Success:(SEL)suc Failure:(SEL)fail;
    NSString *end = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd hh:mm:ss" withDate:[NSDate date]];
    NSString *start = [KRBaseTool timeStringFromFormat:@"yyyy-MM-dd hh:mm:ss" withDate:[NSDate dateWithTimeIntervalSinceNow:-24 * 3600 * 365]];
    ASIHTTPRequest *requst = [SharedSDK findCaptureImgList:SharedUserInfo.baseUrl Vid:self.device.id StartTime:start EndTime:end page:self.page Target:self Success:@selector(succ:) Failure:@selector(defaultReq:)];
    [requst startAsynchronous];
    
}
- (void)succ:(ASIHTTPRequest *)req {
    
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    CLTreeViewNode *node = [[req userInfo] objectForKey:@"node"];
    NSData *data = [req responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *deviceList = dic[@"rows"];
    if ([deviceList isEqual:[NSNull null] ]) {
       
        return ;
    }
    if (self.page == 1) {
        self.allPic = [deviceList mutableCopy];
    } else {
        [self.allPic addObjectsFromArray:deviceList];
    }
    [self.collectionView reloadData];
    
}
- (void)defaultReq:(ASIHTTPRequest *)req {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //NSString *imageName = self.imagsArray[index];[
    NSURL *url = [NSURL URLWithString:self.allPic[index][@"imgPath"]];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
//    UIImageView *imageView = [UIImageView new];
    return [UIImage new];
}
@end
