//
//  HDDeviceListViewController.m
//  iScanMC
//
//  Created by zqh on 14-8-22.
//  Copyright (c) 2014年 zqh. All rights reserved.
//

#import "HDDeviceListViewController.h"
//#import "CLTree.h"
#import "CommanUtils.h"
#import "iscanMCSdk.h"
#import "BaseTabbarViewController.h"

@interface HDDeviceListViewController (){

    NSInteger totalDeviceCount;
    CommanUtils *util;
    iscanMCSdk *sdk;
    MBProgressHUD *HUD;    
}

@property(strong,nonatomic) NSMutableArray* nodeArray; // 全部机构和设备
@property(strong,nonatomic) NSArray* displayNodeArray; // 需要显示的机构和设备

@property (strong,nonatomic) UITableView* tabView;

@end

@implementation HDDeviceListViewController

//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.title = @"list";
//        
//        self.numberOfRowsInSection0 = 0;
//        self.numberOfRowsInSection1 = 0;
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    util = [CommanUtils new];
//    sdk = [iscanMCSdk new];
//    [self InitTableView];
//    [self.nodeArray removeAllObjects];
//    
//    [self getOrganations];
//    
//}
//
//-(void) InitTableView
//{
//    self.nodeArray = [[NSMutableArray alloc] init];
//
//    if (TMO_UIKIT_APP_IS_IOS7) {
//
//        self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(self.tabView.frame.origin.x, 10, self.view.frame.size.width, TMO_UIKIT_APP_HEIGHT - 80) style:UITableViewStylePlain];
//    }else{
//
//        self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(self.tabView.frame.origin.x, 10, self.view.frame.size.width, TMO_UIKIT_APP_HEIGHT- 100) style:UITableViewStylePlain];
//    }
//    
//    self.tabView.delegate = self;
//    self.tabView.dataSource = self;
////    self.tabView.showsVerticalScrollIndicator = NO;
//    self.tabView.scrollEnabled = true;
//    //不要分割线
//    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tabView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1]];
//    [self.view addSubview:self.tabView];
//
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(void)GetOrgResult:(ASIHTTPRequest *) requst{
//    NSData *data = [requst responseData];
//    NSMutableDictionary *orgs = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    
//    if(true){
//        if ([orgs isEqual:[NSNull null] ]) {
//            bFinished = true;
//            return ;
//        }
//        for (NSDictionary *orgitem in orgs) {
//            // 保存机构，根机构不保存
//            if(![@"0" isEqualToString:[orgitem objectForKey:@"pId"]]){
//                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
//                t_node.nodeLevel = 0;//根层cell
//                t_node.nodeshowLevel = t_node.nodeLevel;
//                t_node.type = 1;//type 1的cell
//                t_node.sonNodes = [[NSMutableArray alloc] init];
//                t_node.isExpanded = FALSE;//关闭状态
//                t_node.nodeValue = orgitem;
//                CLTreeView_LEVEL1_Model *t_model_level1 =[[CLTreeView_LEVEL1_Model alloc]init];
//                t_model_level1.name = [orgitem objectForKey:@"name"];
//                t_model_level1.sonCnt = @"0/0";
//                t_node.nodeData = t_model_level1;
//                
//                [self.nodeArray addObject:t_node];
//                
//                [self getChildOrg:orgitem tree_node:t_node];
//            }
//        }
//        
//        [self getDeviceLists];
//    }
//    
//    [self hideHud];
//}
//-(void)GetOrgError:(ASIHTTPRequest *) requst{
//    [util showTips:self.view Title:@"服务器响应失败"];
//}
//-(void)hideHud{
//    [HUD removeFromSuperview];
//    [HUD release];
//    HUD = nil;
//}
//bool bFinished = false;
//-(void)getOrganations
//{
//    bFinished = false;
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.labelText = @"loading...";
//    HUD.mode = MBProgressHUDModeIndeterminate;
//    ASIHTTPRequest *request =  [sdk getOrganization:BASE_URL Recur:@"true" Target:self Success:@selector(GetOrgResult:) Failure:@selector(GetOrgError:)];
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        [request startAsynchronous];
//    }];
//}
//
//
//-(void)getChildOrg:(NSDictionary*) org tree_node:(CLTreeViewNode*)node
//{
//    
//    NSArray *children=[org valueForKey:@"children"];
//    if ([children count]==0) {
//        return;
//    }
//    else
//    {
//        for (NSDictionary *org_child in children) {
//            
//            CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
//            t_node.nodeLevel = node.nodeLevel+1;//节点层cell
//            t_node.nodeshowLevel = t_node.nodeLevel;
//            t_node.type = 1;//type 1的cell
//            t_node.sonNodes = [[NSMutableArray alloc] init];
//            t_node.isExpanded = FALSE;//关闭状态
//            t_node.nodeValue = org_child;
//            CLTreeView_LEVEL1_Model *t_model_level1 =[[CLTreeView_LEVEL1_Model alloc]init];
//            t_model_level1.name = [org_child objectForKey:@"name"];
//            t_model_level1.sonCnt = @"0/0";
//            t_node.nodeData = t_model_level1;
//            
//            [node.sonNodes addObject:t_node];
//            
//            // 获取子机构
//            [self getChildOrg:org_child tree_node:t_node];
//           
//        }
//        
//    }
//}
//
//-(void)getChildNodeDeviceList:(CLTreeViewNode*)node
//{
//    if ( node.sonNodes.count == 0 ) {
//        return;
//    }
//    
//    for (CLTreeViewNode *childNode in node.sonNodes) {
//        if (childNode.type != 2 ) {
//            [self getDeviceList:childNode];
//            node.onlineDevCnt += childNode.onlineDevCnt;
//            node.totalDevCnt += childNode.totalDevCnt;
//        }
//        
//        [self getChildNodeDeviceList:childNode];
//    }
//}
//
//// 获取设备列表
//-(void)getDeviceLists
//{
//    totalDeviceCount = 0;
//    for (CLTreeViewNode *node in self.nodeArray) {
//        [self getChildNodeDeviceList:node];
//        [self getDeviceList:node];
//        
//        
//    }
//}
//-(void)GetCarResult:(ASIHTTPRequest *) requst{
//    CLTreeViewNode *node = [[requst userInfo] objectForKey:@"node"];
//    NSData *data = [requst responseData];
//    NSDictionary *dic = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:nil];
//    if(dic){
//        NSArray *deviceList = dic[@"rows"];
//        if ([deviceList isEqual:[NSNull null] ]) {
//            bFinisheddev = true;
//            return ;
//        }
//        node.totalDevCnt += [deviceList count];
//        totalDeviceCount += node.totalDevCnt;
//        for (NSDictionary *item in deviceList) {
//            NSDictionary *term=[self getState:[item objectForKey:@"termList"]];
//            if([@"1" isEqualToString:[term objectForKey:@"online"]])
//            {
//                node.onlineDevCnt++;
//                
//                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
//                t_node.nodeLevel = node.nodeLevel+1;//节点层cell
//                t_node.nodeshowLevel = t_node.nodeLevel;
//                t_node.type = 2;//type 1的cell
//                t_node.sonNodes = nil;
//                t_node.isExpanded = FALSE;//关闭状态
//                t_node.nodeValue = item;
//                CLTreeView_LEVEL2_Model *t_model_level2 =[[CLTreeView_LEVEL2_Model alloc]init];
//                t_model_level2.name = [item objectForKey:@"vin"];
//                t_model_level2.headImgPath = @"online_on.png";
//                
//                NSString *type=[term objectForKey:@"netType"];
//                NSString *nettype=[type isKindOfClass:[NSNull class]]?@"1":([type rangeOfString:@"2G"].location!=NSNotFound)?@"":([type rangeOfString:@"3G"].location!=NSNotFound)?@"1":@"2";
//                NSString *csq=[term objectForKey:@"csq"];
//                
//                if([@"0" isEqualToString:csq])
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"0"];
//                }
//                else if([@"1" isEqualToString:csq])
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"1"];
//                }
//                else if([@"2" isEqualToString:csq])
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"2"];
//                }
//                else if([@"3" isEqualToString:csq])
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"3"];
//                }
//                else if([@"4" isEqualToString:csq])
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"4"];
//                }
//                else
//                {
//                    t_model_level2.tailImgPath=[NSString stringWithFormat:@"gps_phonecut_%@%@",nettype,@"5"];
//                }
//                
//                
//                t_node.nodeData = t_model_level2;
//                
//                [node.sonNodes addObject:t_node];
//            }
//            else   // 所有设备
//            {
//                // 添加不在线设备
//                CLTreeViewNode *t_node = [[CLTreeViewNode alloc]init];
//                t_node.nodeLevel = node.nodeLevel+1;//节点层cell
//                t_node.nodeshowLevel = t_node.nodeLevel;
//                t_node.type = 2;//type 1的cell
//                t_node.sonNodes = nil;
//                t_node.isExpanded = FALSE;//关闭状态
//                CLTreeView_LEVEL2_Model *t_model_level2 =[[CLTreeView_LEVEL2_Model alloc]init];
//                t_model_level2.name = [item objectForKey:@"vin"];
//                t_model_level2.headImgPath = @"online_off.png";
//                t_node.nodeData = t_model_level2;
//                
//                [node.sonNodes addObject:t_node];
//            }
//            
//        }
//        
//        bFinisheddev = true;
//        [self reloadDataForDisplayArray];
//        [self.tabView reloadData];
//    }
//    
//}
//-(void)GetCarError:(ASIHTTPRequest *) requst{
//    [util showTips:self.view Title:@"服务器响应失败"];
//}
//bool bFinisheddev = false;
////-(void)getDeviceList:(NSDictionary*) org tree_node:(CLTreeViewNode*)node /*online:(NSInteger*)pOnline total:(NSInteger*)nTotal*/
//-(void)getDeviceList:(CLTreeViewNode*)node
//{
//    bFinisheddev = false;
//    ASIHTTPRequest *request =  [sdk getCarList:BASE_URL OrgId:[node.nodeValue objectForKey:@"id"] Target:self Success:@selector(GetCarResult:) Failure:@selector(GetCarError:)];
//    NSDictionary *dicPa = [NSDictionary dictionaryWithObject:node forKey:@"node"];
//    [request setUserInfo:dicPa];
//    [request startAsynchronous];
//}
//
//-(NSDictionary*) getState:(NSArray*)list
//{
//    NSDictionary *term1=nil;
//    NSDictionary *term2=nil;
//    NSDictionary *term3=nil;
//    for (NSDictionary *item in list) {
//        if ([@"3" isEqualToString:[item objectForKey:@"termType"]])
//        {
//            term3=item;
//        }
//        else if([@"2" isEqualToString:[item objectForKey:@"termType"]])
//        {
//            term2=item;
//        }
//        else
//        {
//            term1=item;
//        }
//    }
//    if (term3!=nil) {
//        return term3;
//    }
//    if (term2!=nil) {
//        return term2;
//    }
//    return term1;
//}
////返回有多少个Sections
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
///*---------------------------------------
// cell高度默认为40
// --------------------------------------- */
//-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    return 30;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////    return [self.deviceList count];
//    if (self.tabView == self.searchDisplayController.searchResultsTableView)
//    {
//        return 1;
//    }
//    return [self.displayNodeArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *indentifier = @"level0cell";
//    static NSString *indentifier1 = @"level1cell";
//    static NSString *indentifier2 = @"level2cell";
//    CLTreeViewNode *node = [self.displayNodeArray objectAtIndex:indexPath.row];
//    
//    if(node.type == 0){//类型为0的cell
//        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
//        if(cell == nil){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
//        }
//        cell.node = node;
//        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
//        [cell setNeedsDisplay]; //重新描绘cell
//        return cell;
//    }
//    else if(node.type == 1){//类型为1的cell
//        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
//        if(cell == nil){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
//        }
//        cell.node = node;
//        [self loadDataForTreeViewCell:cell with:node];
//        [cell setNeedsDisplay];
//        return cell;
//    }
//    else{//类型为2的cell
//        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
//        if(cell == nil){
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
//        }
//        cell.node = node;
//        [self loadDataForTreeViewCell:cell with:node];
//        [cell setNeedsDisplay];
//        
//        return cell;
//    }
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
////     NSDictionary *item=[self.deviceList objectAtIndex:indexPath.row];
////    [self gotoMainPage:item];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    CLTreeViewNode *node = [self.displayNodeArray objectAtIndex:indexPath.row];
//    
//    if(node.type == 2){
//        // 点击了设备节点
////        NSDictionary *item ＝ node.nodeValue;
//        [self gotoMainPage:node.nodeValue];
//    }
//    else{
//        [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
//        
//        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
//        if(cell.node.isExpanded ){
//            [self rotateArrow:cell with:M_PI_2];
//        }
//        else{
//            [self rotateArrow:cell with:0];
//        }
//        
//        [self.tabView reloadData];
//    }
//}
//
///*---------------------------------------
// 旋转箭头图标
// --------------------------------------- */
//-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
//    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
//    } completion:NULL];
//}
//
///*---------------------------------------
// 为不同类型cell填充数据
// --------------------------------------- */
//-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
//    if(node.type == 0){
//        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
//        if (nodeData.name) {
//            ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
//        }
//        
//        if(nodeData.headImgPath != nil){
//            //本地图片
//            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
//        }
//        else if (nodeData.headImgUrl != nil){
//            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
//            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
//        }
//    }
//    
//    else if(node.type == 1){
//        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
//        if (![nodeData.name isEqual:[NSNull null]]) {
//            ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
//        }
////        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
////        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
//         ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = [NSString stringWithFormat:@"(%d/%d)", node.onlineDevCnt, node.totalDevCnt];
//    }
//    
//    else{
//        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
//        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
////        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
//        if(nodeData.headImgPath != nil){
//            //本地图片
//            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
//        }
//        else if (nodeData.headImgUrl != nil){
//            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
//            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
//        }
//        
//        if(nodeData.tailImgPath != nil){
//            //本地图片
//            [((CLTreeView_LEVEL2_Cell*)cell).tailImg setImage:[UIImage imageNamed:nodeData.tailImgPath]];
//        }
//        else if (nodeData.tailImgUrl != nil){
//            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
//            [((CLTreeView_LEVEL2_Cell*)cell).tailImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.tailImgUrl]]];
//        }
//    }
//}
//
//
///*---------------------------------------
// 初始化将要显示的cell的数据
// --------------------------------------- */
//-(void) reloadDataForDisplayArray{
//    NSMutableArray *tmp = [[NSMutableArray alloc]init];
//    for (CLTreeViewNode *node in self.nodeArray) {
//        if (node.type == 1 && node.totalDevCnt > 0 ){
//            [tmp addObject:node];
//            [self loadChildDisplayArray:node Array:tmp];
//        }
//        
//    }
//    self.displayNodeArray = [NSArray arrayWithArray:tmp];
//    
////    [self.tabView reloadData];
//}
//
//-(void)loadChildDisplayArray:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray
//{
//    if (tree_node.sonNodes == nil || !tree_node.isExpanded)
//        return;
//    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
//        bool bAddNode = true;
//        if ( bAddNode ){
//            [dataArray addObject:node2];
//            [self loadChildDisplayArray:node2 Array:dataArray];
//        }
//        
//    }
//}
//
///*---------------------------------------
// 修改cell的状态(关闭或打开)
// --------------------------------------- */
//-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
//    NSMutableArray *tmp = [[NSMutableArray alloc]init];
//    NSInteger cnt=0;
//    for (CLTreeViewNode *node in self.nodeArray) {
//        bool bAddNode = true;
//        
//        if (bAddNode) {
//            [tmp addObject:node];
//            if(cnt == row){
//                node.isExpanded = !node.isExpanded;
//            }
//            ++cnt;
//            
//            [self loadChildDisplayArrayChangeAt:node Array:tmp selrow:row index:&cnt];
//        
//        }
//    }
//    
//    self.displayNodeArray = [NSArray arrayWithArray:tmp];
//    
//}
//
//-(void)loadChildDisplayArrayChangeAt:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray selrow:(NSInteger)selrow index:(NSInteger*)pIndex
//{
//    if (tree_node.sonNodes == nil || !tree_node.isExpanded)
//        return;
//    
//    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
//        
//        bool bAddNode = true;
//        if (bAddNode){
//            [dataArray addObject:node2];
//            
//            if ( selrow == (*pIndex) )
//            {
//                node2.isExpanded = !node2.isExpanded;
//            }
//            ++(*pIndex);
//            
//            [self loadChildDisplayArrayChangeAt:node2 Array:dataArray selrow:selrow index:pIndex];
//        }
//    }
//}
//
//
///*---------------------------------------
// 搜索将要显示的cell的数据
// --------------------------------------- */
//-(void) searchForDisplayArray:(NSString*)text{
//    NSMutableArray *tmp = [[NSMutableArray alloc]init];
//    for (CLTreeViewNode *node in self.nodeArray) {
//        if (node.totalDevCnt > 0 ){
//            [self searchChildDisplayArray:node Array:tmp searchText:text];
//        }
//        
//    }
//    self.displayNodeArray = [NSArray arrayWithArray:tmp];
//}
//
//// 搜索孩子节点
//-(void)searchChildDisplayArray:(CLTreeViewNode *)tree_node Array:(NSMutableArray *)dataArray searchText:(NSString*)text
//{
//    if ( tree_node.sonNodes == nil )
//        return;
//    
//    for (CLTreeViewNode *node2 in tree_node.sonNodes) {
//        if (node2.type == 2 ){  // 设备
//            CLTreeView_LEVEL2_Model *nodeData = node2.nodeData;
//            
//            if ([nodeData.name rangeOfString:text].location != NSNotFound){
//                node2.nodeshowLevel = 1;
//                [dataArray addObject:node2];
//                
//            }
//        }
//        else{   // 机构
//            if (node2.totalDevCnt > 0 ) {
//                [self searchChildDisplayArray:node2 Array:dataArray searchText:text];
//            }
//        }
//        
//    }
//}
//
//-(void)gotoMainPage:(id)gesture
//{
//    BaseTabbarViewController *tab = [[BaseTabbarViewController alloc]init];
//    
//    
//    NSDictionary *device= gesture;
//    
//    
//    NSDictionary *term=[self getState:[gesture objectForKey:@"termList"]];
//    TermModel *model = [TermModel new];
//    [model setValuesForKeysWithDictionary:term];
//    DeviceModel *dev = [DeviceModel new];
//    [dev setValuesForKeysWithDictionary:device];
//    tab.term = model;
//    tab.device = dev;
//    tab.tepTerm = term;
//    tab.tepDevice = device;
//    SharedUserInfo.device = dev;
//    [self presentViewController:tab animated:YES completion:nil];
////    HDPreviewView * firstVC=[[HDPreviewView alloc] init];
////    firstVC.device=device;
////    [firstVC setTermSnInfo:[term objectForKey:@"termSn"]];
////    [self.navigationController pushViewController:firstVC animated:YES];
//}
//
//+ (NSString*)getPreferredLanguage
//{
//    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
//    
//    NSString * preferredLang = [allLanguages objectAtIndex:0];
//    
//    NSLog(@"当前语言:%@", preferredLang);
//    
//    return preferredLang;
//    
//}

@end
