//
//  CarListViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/5.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "CarListViewController.h"
#import "KRMySegmentView.h"
#import "CLTree.h"
#import "CommanUtils.h"
#import "iscanMCSdk.h"
#import "BaseTabbarViewController.h"
#import "ASIHTTPRequest.h"
#import "SettingViewController.h"
//#import "CJSONDeserializer.h"
//#import "HDPreviewView.h"
@interface CarListViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,ASIHTTPRequestDelegate,UISearchBarDelegate>
{
    
    NSInteger totalDeviceCount;
    CommanUtils *util;
    iscanMCSdk *sdk;
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UIScrollView *mainScoll;
@property(strong,nonatomic) NSMutableArray* nodeArray; // 全部机构和设备
@property(strong,nonatomic) NSArray* displayNodeArray; // 需要显示的机构和设备
@property (strong,nonatomic) UITableView* tabView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSString *showType;//1全部 2在线
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) KRMySegmentView *segement;
@end

@implementation CarListViewController
// 所有终端 在线终端
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iVS-100";
    self.showType = @"1";
    [self addHeader];
    util = [CommanUtils new];
    sdk = [iscanMCSdk new];
    [self InitTableView];
    [self.nodeArray removeAllObjects];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_Set"] style:UIBarButtonItemStyleDone target:self action:@selector(getSetting)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(getSetting)]
    
//    [self InitTableView];
    [self headerFresh];
}
- (void)displayLau {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:Localized(@"设置") style:UIBarButtonItemStyleDone target:self action:@selector(getSetting)];
    _searchBar.placeholder = Localized(@"搜索");
    [_segement reloadData];
}
- (void)getSetting {
    SettingViewController *set = [SettingViewController new];
    set.canPop = YES;
    __weak typeof(self) weakSelf = self;
    set.block = ^{
        [weakSelf displayLau];
    };
    [self.navigationController pushViewController:set animated:YES];
}
-(void)InitTableView
{
    self.nodeArray = [[NSMutableArray alloc] init];
    
    self.tabView = [UITableView new];
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    [KRBaseTool tableViewAddRefreshHeader:self.tabView withTarget:self refreshingAction:@selector(headerFresh)];
    //    self.tabView.showsVerticalScrollIndicator = NO;
    self.tabView.scrollEnabled = true;
    //不要分割线
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tabView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1]];
    [self.view addSubview:self.tabView];
    
}
- (void)headerFresh {
    [self getOrganations];
}
- (void)addHeader {
    UIView *headerView = [[UIView alloc]init];
    _headerView = headerView;
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@90);
    }];
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    [headerView addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).with.offset(10);
        make.height.equalTo(@40);
        make.left.equalTo(headerView.mas_left).with.offset(15);
        make.right.equalTo(headerView.mas_right).with.offset(-15);
    }];
    searchBar.delegate = self;
    UITextField* searchField = nil;
//    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setBackgroundImage:[UIImage new]];
    searchBar.backgroundColor = LRRGBColor(238, 238, 238);
    searchBar.placeholder = Localized(@"搜索");
    _searchBar = searchBar;
    LRViewBorderRadius(searchBar, 5, 1, [UIColor clearColor]);
    for (UIView* subview  in [searchBar.subviews firstObject].subviews) {
        
        // 打印出两个结果:
        /*
         UISearchBarBackground
         UISearchBarTextField
         */
        
        if ([subview isKindOfClass:[UITextField class]]) {
            
            searchField = (UITextField*)subview;
            // leftView就是放大镜
            // searchField.leftView=nil;
            // 删除searchBar输入框的背景
            [searchField setBackground:nil];
            [searchField setBorderStyle:UITextBorderStyleNone];
            
//            searchField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search3"]];
            searchField.backgroundColor = [UIColor clearColor];
            
            // 设置圆角
            searchField.layer.cornerRadius = 5;
            searchField.layer.masksToBounds = YES;
            searchField.tintColor = [UIColor blackColor];
            
            break;
        }
    }

    KRMySegmentView *segement = [[KRMySegmentView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 30) andSegementArray:@[@"所有终端",@"在线终端"] andColorArray:@[LRRGBColor(100,100,100),ThemeColor] andClickHandle:^(NSInteger index) {
        if (index == 0) {
            self.showType = @"1";
            [self reloadDataForDisplayArray];
        } else {
            self.showType = @"2";
            [self searchOnline];
        }
        
    }];
    _segement = segement;
    [headerView addSubview:segement];
    UIView *line = [[UIView alloc]init];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(headerView);
        make.height.equalTo(@1);
    }];
    line.backgroundColor = LRRGBColor(100, 100, 100);
    self.mainScoll = [[UIScrollView alloc]init];
    [self.view addSubview:self.mainScoll];
    [self.mainScoll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [headerView bringSubviewToFront:segement];
    UIView *contans = [[UIView alloc]init];
    [self.mainScoll addSubview:contans];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetOrgResult:(ASIHTTPRequest *) requst{
    [self hideHUD];
    [self.nodeArray removeAllObjects];
    NSData *data = [requst responseData];
    NSMutableDictionary *orgs = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    if(true){
        if ([orgs isEqual:[NSNull null] ]) {
            bFinished = true;
            return ;
        }
        for (NSDictionary *orgitem in orgs) {
            // 保存机构，根机构不保存
            if(![@"0" isEqualToString:[orgitem objectForKey:@"pId"]]){
                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
                t_node.nodeLevel = 0;//根层cell
                t_node.nodeshowLevel = t_node.nodeLevel;
                t_node.type = 1;//type 1的cell
                t_node.sonNodes = [[NSMutableArray alloc] init];
                t_node.isExpanded = YES;//展开状态
                t_node.nodeValue = orgitem;
                CLTreeView_LEVEL1_Model *t_model_level1 =[[CLTreeView_LEVEL1_Model alloc]init];
                t_model_level1.name = [orgitem objectForKey:@"name"];
                t_model_level1.sonCnt = @"0/0";
                t_model_level1.isZhan = false;
                t_node.nodeData = t_model_level1;

                [self.nodeArray addObject:t_node];

                [self getChildOrg:orgitem tree_node:t_node];
            }
        }

        [self getDeviceLists];
    }

    [self hideHud];
}
-(void)GetOrgError:(ASIHTTPRequest *) requst{
    [self hideHUD];
    [util showTips:self.view Title:@"服务器响应失败"];
}
-(void)hideHud{
    [HUD removeFromSuperview];
//    [HUD release];
    HUD = nil;
}
bool bFinished = false;
-(void)getOrganations
{
    bFinished = false;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"loading...";
    HUD.mode = MBProgressHUDModeIndeterminate;
    ASIHTTPRequest *request =  [sdk getOrganization:SharedUserInfo.baseUrl Recur:@"true" Target:self Success:@selector(GetOrgResult:) Failure:@selector(GetOrgError:)];
    [self showLoadingHUD];
        [request startAsynchronous];
    
}
-(void)getChildOrg:(NSDictionary*) org tree_node:(CLTreeViewNode*)node
{
    
    NSArray *children=[org valueForKey:@"children"];
    if ([children count]==0) {
        return;
    }
    else
    {
        for (NSDictionary *org_child in children) {
            
            CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
            t_node.nodeLevel = node.nodeLevel+1;//节点层cell
            t_node.nodeshowLevel = t_node.nodeLevel;
            t_node.type = 1;//type 1的cell
            t_node.sonNodes = [[NSMutableArray alloc] init];
            t_node.isExpanded = FALSE;//关闭状态
            t_node.nodeValue = org_child;
            CLTreeView_LEVEL1_Model *t_model_level1 =[[CLTreeView_LEVEL1_Model alloc]init];
            t_model_level1.name = [org_child objectForKey:@"name"];
            t_model_level1.sonCnt = @"0/0";
            t_model_level1.isZhan = t_node.isExpanded;
            t_node.nodeData = t_model_level1;
            
            [node.sonNodes addObject:t_node];
            
            // 获取子机构
            [self getChildOrg:org_child tree_node:t_node];
            
        }
        
    }
}

-(void)getChildNodeDeviceList:(CLTreeViewNode*)node
{
    if ( node.sonNodes.count == 0 ) {
        return;
    }
    
    for (CLTreeViewNode *childNode in node.sonNodes) {
        if (childNode.type != 2 ) {
            [self getDeviceList:childNode];
            node.onlineDevCnt += childNode.onlineDevCnt;
            node.totalDevCnt += childNode.totalDevCnt;
        }
        
        [self getChildNodeDeviceList:childNode];
    }
}

// 获取设备列表
-(void)getDeviceLists
{
    totalDeviceCount = 0;
    for (CLTreeViewNode *node in self.nodeArray) {
        [self getChildNodeDeviceList:node];
        [self getDeviceList:node];
        
        
    }
}
-(void)GetCarResult:(ASIHTTPRequest *) requst{
    [self.tabView.mj_header endRefreshing];
    CLTreeViewNode *node = [[requst userInfo] objectForKey:@"node"];
    NSData *data = [requst responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@",dic);
//    NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
    if(dic){
        NSArray *deviceList = dic[@"rows"];
        if ([deviceList isEqual:[NSNull null] ]) {
            bFinisheddev = true;
            [self.nodeArray removeObject:node];
            return ;
        }
        node.totalDevCnt += [deviceList count];
        totalDeviceCount += node.totalDevCnt;
//        if (deviceList.count == 0) {
//            [self.nodeArray removeObject:node];
//        }
        for (NSDictionary *item in deviceList) {
            NSDictionary *term=[self getState:[item objectForKey:@"termList"]];
            if([@"1" isEqualToString:[term objectForKey:@"online"]])
            {
                node.onlineDevCnt++;
                
                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
                t_node.nodeLevel = node.nodeLevel+1;//节点层cell
                t_node.nodeshowLevel = t_node.nodeLevel;
                t_node.type = 2;//type 1的cell
                t_node.sonNodes = nil;
                t_node.isExpanded = FALSE;//关闭状态
                t_node.nodeValue = item;
                CLTreeView_LEVEL2_Model *t_model_level2 =[[CLTreeView_LEVEL2_Model alloc]init];
                t_model_level2.name = [item objectForKey:@"vin"];
                t_model_level2.headImgPath = @"online_on";
                
                NSString *type=[term objectForKey:@"netType"];
                NSString *nettype=[type isKindOfClass:[NSNull class]]?@"1":([type rangeOfString:@"2G"].location!=NSNotFound)?@"":([type rangeOfString:@"3G"].location!=NSNotFound)?@"1":@"2";
                NSString *csq=[term objectForKey:@"csq"];
                
                if([@"0" isEqualToString:csq])
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"0"];
                }
                else if([@"1" isEqualToString:csq])
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"1"];
                }
                else if([@"2" isEqualToString:csq])
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"2"];
                }
                else if([@"3" isEqualToString:csq])
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"3"];
                }
                else if([@"4" isEqualToString:csq])
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"4"];
                }
                else
                {
                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"5"];
                }
                
                t_model_level2.isOnline = YES;
                t_node.nodeData = t_model_level2;
                
                [node.sonNodes addObject:t_node];
            }
            else   // 所有设备
            {
                // 添加不在线设备
                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
                t_node.nodeLevel = node.nodeLevel+1;//节点层cell
                t_node.nodeshowLevel = t_node.nodeLevel;
                t_node.type = 2;//type 1的cell
                t_node.sonNodes = nil;
                t_node.isExpanded = FALSE;//关闭状态
                CLTreeView_LEVEL2_Model *t_model_level2 =[[CLTreeView_LEVEL2_Model alloc]init];
                t_model_level2.name = [item objectForKey:@"vin"];
                t_model_level2.headImgPath = @"online_off";
                t_model_level2.isOnline = false;
                t_node.nodeData = t_model_level2;
                
                [node.sonNodes addObject:t_node];
            }
            
        }
        
        bFinisheddev = true;
        if ([self.showType isEqualToString:@"1"]) {
            [self reloadDataForDisplayArray];
            [self.tabView reloadData];
        } else {
            [self searchOnline];
        }
        
    }
    
}
-(void)GetCarError:(ASIHTTPRequest *) requst{
    [self.tabView.mj_header endRefreshing];
    [util showTips:self.view Title:@"服务器响应失败"];
}
bool bFinisheddev = false;
//-(void)getDeviceList:(NSDictionary*) org tree_node:(CLTreeViewNode*)node /*online:(NSInteger*)pOnline total:(NSInteger*)nTotal*/
-(void)getDeviceList:(CLTreeViewNode*)node
{
    bFinisheddev = false;
    ASIHTTPRequest *request =  [sdk getCarList:SharedUserInfo.baseUrl OrgId:[node.nodeValue objectForKey:@"id"] Target:self Success:@selector(GetCarResult:) Failure:@selector(GetCarError:)];
    NSDictionary *dicPa = [NSDictionary dictionaryWithObject:node forKey:@"node"];
    [request setUserInfo:dicPa];
    [request startAsynchronous];
}

-(NSDictionary*) getState:(NSArray*)list
{
    NSDictionary *term1=nil;
    NSDictionary *term2=nil;
    NSDictionary *term3=nil;
    for (NSDictionary *item in list) {
        if ([@"3" isEqualToString:[item objectForKey:@"termType"]])
        {
            term3=item;
        }
        else if([@"2" isEqualToString:[item objectForKey:@"termType"]])
        {
            term2=item;
        }
        else
        {
            term1=item;
        }
    }
    if (term3!=nil) {
        return term3;
    }
    if (term2!=nil) {
        return term2;
    }
    return term1;
}
//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/*---------------------------------------
 cell高度默认为40
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return [self.deviceList count];
    if (self.tabView == self.searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    return [self.displayNodeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [self.displayNodeArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    //     NSDictionary *item=[self.deviceList objectAtIndex:indexPath.row];
    //    [self gotoMainPage:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLTreeViewNode *node = [self.displayNodeArray objectAtIndex:indexPath.row];
    
    if(node.type == 2){
        // 点击了设备节点
        //        NSDictionary *item ＝ node.nodeValue;
        [self gotoMainPage:node.nodeValue];
    }
    else{
        [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
        
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            ((CLTreeView_LEVEL1_Cell*)cell).arrowView.image = [UIImage imageNamed:@"展开"];
            
        }
        else{
            ((CLTreeView_LEVEL1_Cell*)cell).arrowView.image = [UIImage imageNamed:@"收起"];
        }
        
        [self.tabView reloadData];
    }
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        if (nodeData.name) {
            ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        }
        
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        if (![nodeData.name isEqual:[NSNull null]]) {
            ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        }
        
        //        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        //        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = [NSString stringWithFormat:@"(%d/%d)", node.onlineDevCnt, node.totalDevCnt];
        if(node.isExpanded ){
            ((CLTreeView_LEVEL1_Cell*)cell).arrowView.image = [UIImage imageNamed:@"展开"];
            
        }
        else{
            ((CLTreeView_LEVEL1_Cell*)cell).arrowView.image = [UIImage imageNamed:@"收起"];
        }
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        //        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
        
        if(nodeData.tailImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).tailImg setImage:[UIImage imageNamed:@"在线"]];
        }
        else if (nodeData.tailImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).tailImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.tailImgUrl]]];
        } else {
            [((CLTreeView_LEVEL2_Cell*)cell).tailImg setImage:[UIImage imageNamed:@"离线"]];
        }
        if (nodeData.isOnline) {
            
            ((CLTreeView_LEVEL2_Cell*)cell).statuLabel.text = Localized(@"在线");
            ((CLTreeView_LEVEL2_Cell*)cell).statuLabel.textColor = ThemeColor;
        } else {
            ((CLTreeView_LEVEL2_Cell*)cell).statuLabel.text = Localized(@"离线");
            ((CLTreeView_LEVEL2_Cell*)cell).statuLabel.textColor = [UIColor blackColor];
        }
    }
}


/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in self.nodeArray) {
        if (node.type == 1 && node.totalDevCnt > 0 ){
            [tmp addObject:node];
            [self loadChildDisplayArray:node Array:tmp];
        }
        
    }
    self.displayNodeArray = [NSArray arrayWithArray:tmp];
    
    [self.tabView reloadData];
}

-(void)loadChildDisplayArray:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray
{
    if (tree_node.sonNodes == nil || !tree_node.isExpanded)
        return;
    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
        bool bAddNode = true;
        if ( bAddNode ){
            [dataArray addObject:node2];
            [self loadChildDisplayArray:node2 Array:dataArray];
        }
        
    }
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in self.nodeArray) {
        bool bAddNode = true;
        
        if (bAddNode) {
            [tmp addObject:node];
            if(cnt == row){
                node.isExpanded = !node.isExpanded;
            }
            ++cnt;
            
            [self loadChildDisplayArrayChangeAt:node Array:tmp selrow:row index:&cnt];
            
        }
    }
    
    self.displayNodeArray = [NSArray arrayWithArray:tmp];
    
}

-(void)loadChildDisplayArrayChangeAt:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray selrow:(NSInteger)selrow index:(NSInteger*)pIndex
{
    if (tree_node.sonNodes == nil || !tree_node.isExpanded)
        return;
    
    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
        
        bool bAddNode = true;
        if (bAddNode){
            [dataArray addObject:node2];
            
            if ( selrow == (*pIndex) )
            {
                node2.isExpanded = !node2.isExpanded;
            }
            ++(*pIndex);
            
            [self loadChildDisplayArrayChangeAt:node2 Array:dataArray selrow:selrow index:pIndex];
        }
    }
}
//bool isFirst = YES;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (isFirst) {
//        isFirst = false;
//        self.nodeArray = [self.displayNodeArray copy];
//    }
    if (searchText.length == 0) {
//        isFirst = YES;
        [self reloadDataForDisplayArray];
    } else {
        [self searchForDisplayArray:searchText];
        
    }
}
- (void)searchOnline {
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in self.nodeArray) {
        if (node.totalDevCnt > 0 ){
            [self searchOnlineArray:node Array:tmp searchText:nil];
        }
        
    }
    self.displayNodeArray = [NSArray arrayWithArray:tmp];
    [self.tabView reloadData];
}
/*---------------------------------------
 搜索将要显示的cell的数据
 --------------------------------------- */
-(void) searchForDisplayArray:(NSString*)text{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in self.nodeArray) {
        if (node.totalDevCnt > 0 ){
            [self searchChildDisplayArray:node Array:tmp searchText:text];
        }
        
    }
    self.displayNodeArray = [NSArray arrayWithArray:tmp];
    [self.tabView reloadData];
}

// 搜索孩子节点
-(void)searchChildDisplayArray:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray searchText:(NSString*)text
{
    if ( tree_node.sonNodes == nil )
        return;
    
    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
        if (node2.type == 2 ){  // 设备
            CLTreeView_LEVEL2_Model *nodeData = node2.nodeData;
            
            if ([nodeData.name rangeOfString:text].location != NSNotFound){
                node2.nodeshowLevel = 1;
                [dataArray addObject:node2];
                
            }
        }
        else{   // 机构
            if (node2.totalDevCnt > 0 ) {
                [self searchChildDisplayArray:node2 Array:dataArray searchText:text];
            }
        }
        
    }
}
// 搜索孩子节点
-(void)searchOnlineArray:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray searchText:(NSString*)text
{
    if ( tree_node.sonNodes == nil )
        return;
    
    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
        if (node2.type == 2 ){  // 设备
            CLTreeView_LEVEL2_Model *nodeData = node2.nodeData;
            if (nodeData.isOnline) {
                node2.nodeshowLevel = 1;
                [dataArray addObject:node2];
            }
//            if ([nodeData.name rangeOfString:text].location != NSNotFound){
//                node2.nodeshowLevel = 1;
//                [dataArray addObject:node2];
//
//            }
        }
        else{   // 机构
            if (node2.totalDevCnt > 0 ) {
                [self searchChildDisplayArray:node2 Array:dataArray searchText:text];
            }
        }
        
    }
}

-(void)gotoMainPage:(id)gesture
{
    BaseTabbarViewController *tab = [[BaseTabbarViewController alloc]init];
    
    
    NSDictionary *device= gesture;
    
    
    NSDictionary *term=[self getState:[gesture objectForKey:@"termList"]];
    TermModel *model = [TermModel new];
    [model setValuesForKeysWithDictionary:term];
    DeviceModel *dev = [DeviceModel new];
    [dev setValuesForKeysWithDictionary:device];
//    tab.term = model;
//    tab.device = dev;
//    tab.tepTerm = term;
//    tab.tepDevice = device;
    SharedUserInfo.device = dev;
    SharedUserInfo.term = model;
    SharedUserInfo.termSn = [term objectForKey:@"termSn"];
    [self presentViewController:tab animated:YES completion:nil];
    //    HDPreviewView * firstVC=[[HDPreviewView alloc] init];
    //    firstVC.device=device;
    //    [firstVC setTermSnInfo:[term objectForKey:@"termSn"]];
    //    [self.navigationController pushViewController:firstVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
