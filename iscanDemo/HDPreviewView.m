

#import "HDPreviewView.h"
#import "HDAppDelegate.h"
#import "iscanMCSdk.h"
#import "HDDeviceBase.h"
#import "CommanUtils.h"
@interface HDPreviewView (){
    UILabel *tipTxt;
    NSThread* myThread;
    CommanUtils *util;
}
- (void)initResource;
- (void)setCtrlPos;
- (void)onBtnPtz;
- (void)onBtnPlay;
- (void)onBtnCapture;
- (void)onBtnSound;
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
        tipTxt.text = [NSString stringWithFormat:@"更新时间%@\nGPS:%@,%@  Speed:%@", tm,longitude , altitude , speed ];
    }
    
    
}
-(void)GetError:(ASIHTTPRequest *) requst{
    tipTxt.text =@"GPS:服务器响应失败";
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
CGRect rc = [[UIScreen mainScreen] bounds];
   
    if (!IOS7_OR_LATER)
    {
        self.view.frame = CGRectMake( 0, 0, rc.size.width, rc.size.height );
    }
    else
    {
        self.view.frame = CGRectMake( 0, 0, rc.size.width, rc.size.height );
        UIColor *bgColor= [UIColor colorWithRed:221/255.0 green:221/255.0 blue:220/255.0 alpha:1];
        self.view.backgroundColor =  bgColor;
    }
    tipTxt = [UILabel new];
    tipTxt.text = @"正在加载GPS...";
    tipTxt.textAlignment = NSTextAlignmentLeft;
    tipTxt.numberOfLines = 0;
    tipTxt.textColor = [UIColor blackColor];
    tipTxt.font = [UIFont systemFontOfSize:15];
    tipTxt.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    [self.view addSubview:tipTxt];
    
    videoView = [sdk createVideoViewWithDelegate:self];
    [self.view addSubview:videoView.view ];
    videoView.termSn = self.termSn;
    [videoView setBaseURl:BASE_URL];
    
    videoCtrl = [[HDVideoCtrl alloc] init ];
    videoCtrl.backgroundColor = [UIColor colorWithRed: 18 / 255.0 green: 19 / 255.0 blue: 26 / 255.0 alpha:1.0 ];
    [self.view addSubview: videoCtrl];
    videoCtrl.delegate = self;

    ptzView = [[ HDPtzView alloc]init ];
    ptzView.view.backgroundColor = [ UIColor lightGrayColor ];
    ptzView.view.alpha = 1;
    ptzView.view.hidden = YES;
    [self.view addSubview: ptzView.view ];
    ptzView.delegate = self;
    
    [self setCtrlPos ];
}

- (void)setCtrlPos
{
    CGRect rcClient = self.view.bounds;
    
    int yPos = rcClient.origin.y;
    yPos+=60;

    NSLog(@"system version %@",[[UIDevice currentDevice] systemVersion]);
    
    
    const int CTRL_BAR_HEIGHT = 60;//50;//45; //播放控制栏高度
    const int INFO_BAR_HEIGHT = 40;//45; //信息提示栏高度
    CGRect rcVideo = rcClient;
    rcVideo.origin.y = yPos;
    rcVideo.size.height = rcClient.size.height - (CTRL_BAR_HEIGHT + INFO_BAR_HEIGHT + yPos - rcClient.origin.y);
    videoView.view.frame = rcVideo;
    [videoView setCtrlPos ];
    yPos += rcVideo.size.height;
    
    CGRect rcCtrlBar = rcClient;
    rcCtrlBar.origin.y = yPos;
    rcCtrlBar.size.height = CTRL_BAR_HEIGHT;
    videoCtrl.frame = rcCtrlBar;
    [videoCtrl setCtrlPos ];

    //云台控制
    CGRect rcPtz;
    if( isPad )
    {//如果是iPad,取1/4屏幕，居中
        rcPtz = rcClient;
        rcPtz.size.width = 200 ;//rcClient.size.width / 2;
        rcPtz.size.height = 160 ;
        rcPtz.origin.x += rcVideo.size.width/2 - rcPtz.size.width/2;
        rcPtz.origin.y = rcVideo.size.height/2 - rcPtz.size.height/2 ;
    }
    else //如果不是iPad
    {
        rcPtz = rcVideo;
    }
    ptzView.view.frame = rcPtz;
    [ptzView setCtrlPos ];
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
    BOOL bHidden = ptzView.view.hidden;
    if( bHidden )
    {
        if( ![sdk isVideoPlaying:videoView] && bHidden )
        {
            [util showTips:self.view Title:@"视频播放时才能进行云台控制"];
            return;
        }
        ptzView.view.hidden = NO;
    }
    else
    {
        ptzView.view.hidden = YES;
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
        [util showTips:self.view Title:@"视频播放时才能进行截图"];
        return;
    }
    NSString  *imagePath = [sdk getFileName:@"temp" extend:@"bmp" ];
    [sdk snapPicture:videoView FilePath:imagePath];
    [util showTips:self.view Title:[NSString stringWithFormat:@"图片已保存到%@" , imagePath]];
}

- (void)onBtnSound
{
    if( ![sdk isVideoPlaying:videoView])
    {
        [util showTips:self.view Title:@"视频播放时才能切换声音"];
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
    
    if (![sdk isAudioOpen:videoView]) {
        [videoCtrl.btnSound setBackgroundImage:[UIImage imageNamed:@"sound_open.png"] forState:UIControlStateNormal ];
    } else {
        [videoCtrl.btnSound setBackgroundImage:[UIImage imageNamed:@"sound_close.png"] forState:UIControlStateNormal ];
    }

}
//
////HDPtzViewDelegate--begin--
- (void)onPtzCtrl:(NSInteger)nCmd speed:(NSInteger)nSpeed param:(NSInteger)nParam
{
    [videoView ptzControl:nCmd speed:nSpeed param:nParam];
}

@end
