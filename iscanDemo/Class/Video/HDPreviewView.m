

#import "HDPreviewView.h"
#import "HDAppDelegate.h"
#import "iscanMCSdk.h"
#import "HDDeviceBase.h"
#import "CommanUtils.h"
@interface HDPreviewView (){
    NSThread* myThread;
    CommanUtils *util;
}
- (void)initResource;
- (void)setCtrlPos;
- (void)onBtnPtz;
- (void)onBtnPlay;
- (void)onBtnCapture;
- (void)onBtnSound;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isShowPt;
@end

@implementation HDPreviewView
-(void)doGetCarLL
{
    while(!myThread.isCancelled)
    {
        [self getCarLL];
        [NSThread sleepForTimeInterval:5];
       
    }
}
-(void)GetResult:(ASIHTTPRequest *) requst{
    NSData *data = [requst responseData];
    NSMutableDictionary *orgs = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSDictionary *obj=[orgs objectAtIndex:0];
    if (obj == nil) {
        return ;
    }
    NSString *tm = [obj objectForKey:@"time"];
    NSString *longitude = [obj objectForKey:@"longitude"];
    NSString *altitude = [obj objectForKey:@"latitude"];
    NSString *speed = [obj objectForKey:@"speed"];
    if(![util isBlankString:tm]){
        NSLog(@"%@",[NSString stringWithFormat:@"更新时间%@\nGPS:%@,%@  Speed:%@", tm,longitude , altitude , speed ]);
    }
    
    
}
-(void)GetError:(ASIHTTPRequest *) requst{
    NSLog(@"%@",@"GPS:服务器响应失败");
}
-(void)getCarLL
{
    ASIHTTPRequest *request =   [sdk getCarLocation:BASE_URL Vid:[self.device objectForKey:@"id"] Target:self Success:@selector(GetResult:) Failure:@selector(GetError:)];
    [request startAsynchronous];
}

-(void)startThread
{
    if (myThread==nil || (myThread.isCancelled && myThread.isFinished)) {
        myThread = [[NSThread alloc] initWithTarget:self
                                           selector:@selector(doGetCarLL)
                                             object:nil];
        
        [myThread start];
    }
    
}

-(void)stopThread
{
    
    if (myThread!=nil&&!myThread.isCancelled) {
        [myThread cancel];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [self stopThread];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title= @"视频播控";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        
    }
    self.videoIds=[[NSMutableArray alloc] init];
    sdk = [iscanMCSdk new];
    util = [CommanUtils new];
    [self setTermSnInfo:SharedUserInfo.termSn];
}

- (void)setTermSnInfo:(NSString *)termSn
{
    self.termSn = termSn;
    [self initResource];
    [self startThread];
    [videoView setSubViewsTermSn:termSn];
    
}
- (void)viewDidUnload
{
    [videoView release ];
    videoView = nil;
    [videoCtrl release ];
    videoCtrl = nil;
    [ptzView release];
    ptzView = nil;
    [super viewDidUnload];
}

- (void)initResource
{
    selDevIdno = @"";

    
    videoView = [sdk createVideoViewWithDelegate:self];
    [self.view addSubview:videoView.view ];
    videoView.termSn = self.termSn;
    [videoView setBaseURl:BASE_URL];
    
    


    
    [self setCtrlPos ];
}

- (void)setCtrlPos
{
    
    
    
    
    CGRect rcClient = self.view.bounds;
    
    NSLog(@"system version %@",[[UIDevice currentDevice] systemVersion]);
    
    
    const int CTRL_BAR_HEIGHT = 40;//50;//45; //播放控制栏高度
    CGRect rcVideo = rcClient;
    rcVideo.origin.y = 0;
    rcVideo.size.height = rcClient.size.height - tabBarHeight - navHight;
    videoView.view.backgroundColor = COLOR(247, 247, 247, 1);
    videoView.view.frame = rcVideo;
    [videoView setCtrlPos ];
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, SIZEHEIGHT - tabBarHeight - navHight - HEIGHT(80) - 10, SIZEWIDTH - 20, HEIGHT(80))];
    bottomView.backgroundColor = [UIColor whiteColor];
    LRViewBorderRadius(bottomView, 5, 0.5, [UIColor grayColor]);
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    
    ptzView = [[ HDPtzView alloc]init ];
    ptzView.view.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview: ptzView.view ];
    ptzView.delegate = self;
    ptzView.view.frame = CGRectMake(0, 0, SIZEWIDTH - 20, HEIGHT(300));
    [ptzView setCtrlPos ];

    videoCtrl = [[HDVideoCtrl alloc] init ];
    videoCtrl.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview: videoCtrl];
    videoCtrl.delegate = self;
    videoCtrl.frame = CGRectMake(0, 0, SIZEWIDTH - 20, HEIGHT(80));
    [videoCtrl setCtrlPos ];

//    //云台控制
//    CGRect rcPtz;
//    if( isPad )
//    {//如果是iPad,取1/4屏幕，居中
//        rcPtz = rcClient;
//        rcPtz.size.width = 200 ;//rcClient.size.width / 2;
//        rcPtz.size.height = 160 ;
//        rcPtz.origin.x += rcVideo.size.width/2 - rcPtz.size.width/2;
//        rcPtz.origin.y = rcVideo.size.height/2 - rcPtz.size.height/2 ;
//    }
//    else //如果不是iPad
//    {
//        rcPtz = rcVideo;
//    }

    
    
}

- (void)startWork
{
    
}

- (void)stopWork
{
    [videoView stopAllAV];
    selDevIdno = @"";
}


- (void)onBtnPtz
{
//    BOOL bHidden = ptzView.view.hidden;
//    if( bHidden )
//    {
//        if( ![sdk isVideoPlaying:videoView] && bHidden )
//        {
//            [util showTips:self.view Title:@"视频播放时才能进行云台控制"];
//            return;
//        }
//        ptzView.view.hidden = NO;
//    }
//    else
//    {
//        ptzView.view.hidden = YES;
//    }
    if (self.isShowPt) {
        self.isShowPt = NO;
        self.bottomView.frame = CGRectMake(10, SIZEHEIGHT - tabBarHeight - navHight - HEIGHT(80) - 10, SIZEWIDTH - 20, HEIGHT(80));
        videoCtrl.frame = CGRectMake(0, 0, SIZEWIDTH - 20, HEIGHT(80));
    }
    else{
        self.isShowPt = YES;
        self.bottomView.frame = CGRectMake(10, SIZEHEIGHT - tabBarHeight - navHight - HEIGHT(300) - 10, SIZEWIDTH - 20, HEIGHT(300));
        videoCtrl.frame = CGRectMake(0, HEIGHT(220), SIZEWIDTH - 20, HEIGHT(80));
    }
}

- (void)onBtnPlay
{
    [sdk stopVideo:videoView];
    
    [self updatePlayBar];
}

- (void)onBtnCapture
{
    if( ![sdk isVideoPlaying:videoView])
    {
        [util showTips:self.view Title:Localized(@"视频播放时才能进行截图")];
        return;
    }
    NSString  *imagePath = [sdk getFileName:@"temp" extend:@"bmp" ];
    [sdk snapPicture:videoView FilePath:imagePath];
    [util showTips:self.view Title:[NSString stringWithFormat:@"%@%@" , Localized(@"图片已保存到"),imagePath]];
}

- (void)onBtnSound
{
    if( ![sdk isVideoPlaying:videoView])
    {
        [util showTips:self.view Title:Localized(@"视频播放时才能切换声音")];
        return;
    }
    [sdk switchAudio:videoView];
}

////HDVideoCtrlDelegate--begin--
- (void)onCtrlBtnDown:(E_PlayCtrlBtn)type
{
    switch (type) {
        case E_PlayCtrlBtn_Ptz:
            [self onBtnPtz];
            break;
        case E_PlayCtrlBtn_Stop:
            [self onBtnPlay];
            break;
        case E_PlayCtrlBtn_Capture:
            [self onBtnCapture];
            break;
        case E_PlayCtrlBtn_Sound:
            [self onBtnSound];
            break;
        default:
            break;
    }
}

//HDVideoViewDelegate--begin--
- (void)updatePlayBar
{
    
//    if (![sdk isAudioOpen:videoView]) {
//        [videoCtrl.btnSound setBackgroundImage:[UIImage imageNamed:@"sound_open.png"] forState:UIControlStateNormal ];
//    } else {
//        [videoCtrl.btnSound setBackgroundImage:[UIImage imageNamed:@"sound_close.png"] forState:UIControlStateNormal ];
//    }

}
//
////HDPtzViewDelegate--begin--
- (void)onPtzCtrl:(NSInteger)nCmd speed:(NSInteger)nSpeed param:(NSInteger)nParam
{
    [videoView ptzControl:nCmd speed:nSpeed param:nParam];
}

@end
