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
    self.navigationItem.title = SharedUserInfo.device.vin ? SharedUserInfo.device.vin : Localized(@"对讲");
//    self.navigationItem.title =
    self.view.backgroundColor = LRRGBColor(243, 243, 243);
    [self setUp];
    _talk = [SharedSDK TalkView:nil TalkImg:nil TalkBtn:nil TermSn:SharedUserInfo.termSn];
    

    
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
//    voiceBtn.backgroundColor = ThemeColor;
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"对讲按钮-默认状态"] forState:UIControlStateNormal];
    [voiceBtn setBackgroundImage:[UIImage imageNamed:@"对讲按钮-按下"] forState:UIControlStateHighlighted];
    [voiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [voiceBtn setTitleColor:LRRGBColor(149, 149, 149) forState:UIControlStateNormal];
    [voiceBtn setTitle:Localized(@"请按住对讲") forState:UIControlStateNormal];
    [voiceBtn setTitle:Localized(@"正在对讲") forState:UIControlStateHighlighted];
    [voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).with.offset(15);
        make.right.equalTo(bottomView.mas_right).with.offset(-15);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.equalTo(@45);
    }];
    [voiceBtn addTarget:self action:@selector(tops) forControlEvents:UIControlEventTouchDown];
    [voiceBtn addTarget:self action:@selector(cancleTouch) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside | UIControlEventTouchCancel];
//    voiceBtn.userInteractionEnabled = NO;
//    voiceBtn.enabled = NO;
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    UIImageView *topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对讲麦克风"]];
    CGSize size = CGSizeMake([UIImage imageNamed:@"对讲麦克风"].size.width, [UIImage imageNamed:@"对讲麦克风"].size.height);
    [topView addSubview:topImage];
    _talkImaegView = topImage;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(topView);
        make.height.mas_equalTo(size.height / 1.2);
        make.width.mas_equalTo(size.width / 1.2);
    }];
    topImage.contentMode = UIViewContentModeScaleAspectFit;
    [voiceBtn setTitleColor:LRRGBColor(230, 230, 230) forState:UIControlStateHighlighted];
    
}
- (void)tops {
    
        //开始对讲
    [self.voiceBtn setHighlighted:YES];
    isBegin = YES;
//    [_talk startTalkback];
    [SharedSDK startTalk:_talk BaseUrl:SharedUserInfo.baseUrl];
 
    [self begainAnimation];
    
}

- (void)begainAnimation{
    if (!self.talkImaegView.isAnimating){
        CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue=[NSNumber numberWithFloat:1.0];
        animation.toValue=[NSNumber numberWithFloat:1.2];
        animation.duration=.2;
        animation.autoreverses=YES;
        animation.repeatCount = NSIntegerMax;
        [self.talkImaegView.layer addAnimation:animation forKey:@"zoom"];
    }
}
    
- (void)cancleTouch {
    if (isBegin) {
        //结束对讲
        isBegin = NO;
        [self.voiceBtn setHighlighted:NO];
        [self.talkImaegView.layer removeAllAnimations];
        [_talk stopTalkback];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
