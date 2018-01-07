//
//  TalkViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/3.
//  Copyright © 2018年 曾洪磊. All rights reserved.
//

#import "TalkViewController.h"
#import "HDTalkback.h"
@interface TalkViewController ()
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIImageView *talkImaegView;
@property (nonatomic, strong) HDTalkback *talk;
@end

@implementation TalkViewController
{
    BOOL isBegin;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"对讲");
    self.view.backgroundColor = LRRGBColor(243, 243, 243);
    [self setUp];
    _talk = [SharedSDK TalkView:self.view TalkImg:self.talkImaegView TalkBtn:self.voiceBtn TermSn:SharedUserInfo.termSn];
    
    _talk.hudImgH = [UIImage imageNamed:@"对讲麦克风"].size.height;
    _talk.hudImgY = self.talkImaegView.frame.origin.y;
    
}
- (void)setUp {
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-(tabBarHeight));
        make.height.equalTo(@80);
    }];
    
    UIButton *voiceBtn = [[UIButton alloc]init];
    LRViewBorderRadius(voiceBtn, 3, 0, [UIColor clearColor]);
    _voiceBtn = voiceBtn;
    [bottomView addSubview:voiceBtn];
    voiceBtn.backgroundColor = ThemeColor;
    [voiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [voiceBtn setTitle:Localized(@"请按住对讲") forState:UIControlStateNormal];
    [voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).with.offset(15);
        make.right.equalTo(bottomView.mas_right).with.offset(-15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.equalTo(@45);
    }];
    [voiceBtn addTarget:self action:@selector(tops) forControlEvents:UIControlEventTouchDown];
    [voiceBtn addTarget:self action:@selector(cancleTouch) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
//    voiceBtn.userInteractionEnabled = NO;
//    voiceBtn.enabled = NO;
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对讲麦克风"]];
    [topView addSubview:topImage];
    _talkImaegView = topImage;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topView);
    }];
    topImage.contentMode = UIViewContentModeCenter;
    [voiceBtn setTitleColor:LRRGBColor(230, 230, 230) forState:UIControlStateHighlighted];
    
}
- (void)tops {
    
        //开始对讲
    [self.voiceBtn setHighlighted:YES];
    isBegin = YES;
//    [_talk startTalkback];
    [SharedSDK startTalk:_talk BaseUrl:SharedUserInfo.baseUrl];
    
    
}
- (void)cancleTouch {
    if (isBegin) {
        //结束对讲
        [self.voiceBtn setHighlighted:NO];
        [_talk stopTalkback];
    }
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
