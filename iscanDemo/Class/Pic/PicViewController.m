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
#import "HeadCollectionReusableView.h"
@interface PicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDPhotoBrowserDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowyout;
@property (nonatomic, strong) NSMutableArray *allPic;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UILabel *detaillabel;
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
        
        _collectionFlowyout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*0.5, [UIScreen mainScreen].bounds.size.width*0.5 - 27 + 60);
        
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
    self.navigationItem.title = SharedUserInfo.termSn;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"相机"] style:UIBarButtonItemStyleDone target:self action:@selector(caClick)];
    [self.collectionView registerClass:[HeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"cell"];
//    [self.collectionView registerClass:[KRListCollCollectionViewCell class] forCellWithReuseIdentifier:@"collCell"];
    [KRBaseTool tableViewAddRefreshFooter:self.collectionView withTarget:self refreshingAction:@selector(footerFresh)];
    [KRBaseTool tableViewAddRefreshHeader:self.collectionView withTarget:self refreshingAction:@selector(headerFresh)];
}
- (void)caClick {
//    NSLog(@"%@",)
    if (SharedUserInfo.currentChannel == nil) {
        SharedUserInfo.currentChannel = @"1";
    }
    ASIHTTPRequest *requst = [SharedSDK sendCaptureCmd:SharedUserInfo.baseUrl TermSn:SharedUserInfo.termSn Channel:SharedUserInfo.currentChannel Number:SharedSetting.numbers Interval:SharedSetting.interval?SharedSetting.interval:@"2" Target:self Success:@selector(photoSuc:) Failure:@selector(photoDeful:)];
    [requst startAsynchronous];
    [self showLoadingHUD];
}
- (void)photoSuc:(ASIHTTPRequest *)requst {
    [self hideHUD];
    NSData *data = [requst responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}
- (void)photoDeful:(ASIHTTPRequest *)requst {
    [self hideHUD];
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
        browser.bountView = self.view;
        NSString *str = [NSString stringWithFormat:@"%@ %@",weakSelf.allPic[tags][@"channelName"],weakSelf.allPic[tags][@"createDate"]];
//        weakSelf.allPic[tags][@""]
        UILabel *detailLabel = [[UILabel alloc]init];
        _detaillabel = detailLabel;
        detailLabel.textColor = [UIColor whiteColor];
        detailLabel.font = [UIFont systemFontOfSize:15];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
        [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[str rangeOfString:weakSelf.allPic[tags][@"createDate"]]];
        [detailLabel setAttributedText:attr];
        browser.detailLabel = detailLabel;
        browser.sourceImagesContainerView = weakSelf.collectionView;
        //NSLog(@"%ld",self.scrollView.subviews.count);
        browser.imageCount = weakSelf.allPic.count;
        browser.delegate = weakSelf;
        [browser show];
    };
    [cell setDataWith:self.allPic[indexPath.row]];
    return cell;
}
#pragma mark －collectionView增加头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headView = nil;
    
//    UZGPersonalSetting *s=[UZGPersonalSetting getInstance];
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cell" forIndexPath:indexPath];;
        header.backgroundColor = [UIColor clearColor];
        headView = header ;
    } else if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        
    }
    return headView;
    
}
#pragma mark －分区高度
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={[UIScreen mainScreen].bounds.size.width,15};
    return size;
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
    ASIHTTPRequest *requst = [SharedSDK findCaptureImgList:SharedUserInfo.baseUrl Vid:SharedUserInfo.device.id StartTime:start EndTime:end page:self.page Target:self Success:@selector(succ:) Failure:@selector(defaultReq:)];
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
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *ip=[userDefault valueForKey:@"ip"];
    NSString *port=[userDefault valueForKey:@"port"];
//    [self.mainImageView sd_setImageWithURL:[[[@"http://" stringByAppendingString:ip] stringByAppendingString:port?[@":" stringByAppendingString:port]:@""] stringByAppendingString:dic[@"imgPath"]] placeholderImage:[UIImage new]];
    NSURL *url = [NSURL URLWithString:[[[@"http://" stringByAppendingString:ip] stringByAppendingString:port?[@":" stringByAppendingString:port]:@""] stringByAppendingString:self.allPic[index][@"imgPath"]]];
    return url;
}
- (void)didScollIndex:(NSInteger)index {
    NSString *str = [NSString stringWithFormat:@"%@ %@",self.allPic[index][@"channelName"],self.allPic[index][@"createDate"]];
    //    UILabel *detailLabel = [[UILabel alloc]init];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[str rangeOfString:self.allPic[index][@"createDate"]]];
    [_detaillabel setAttributedText:attr];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
//    UIImageView *imageView = [UIImageView new];
    return [UIImage new];
}
@end
