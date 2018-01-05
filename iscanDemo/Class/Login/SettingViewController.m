//
//  SettingViewController.m
//  iVS-100
//
//  Created by 曾洪磊 on 2018/1/5.
//  Copyright © 2018年 hilook.com. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "BaseNaviViewController.h"
#define LanguageChanged   @"LANGUAGE_CHANGE_NOTIFICATION"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *setting;
@end

@implementation SettingViewController
{
    BOOL netSelect;
    BOOL laugSelect;
    BOOL mapSelect;
    
}
- (NSMutableDictionary *)setting {
    if (!_setting) {
        _setting = [NSMutableDictionary dictionary];
    }
    return _setting;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTab];
    self.view.backgroundColor = LRRGBColor(236, 236, 236);
    self.navigationItem.title = Localized(@"设置");
    SettingBean *setting = [SharedSDK getSettingInfo];
    self.setting[@"ip"] = setting.ip;
    self.setting[@"dk"] = setting.port;
    self.setting[@"picNum"] = setting.numbers;
    self.setting[@"tendS"] = setting.interval;
    NSInteger net = [setting.nettype intValue];
    if (net == 0) {
        self.setting[@"net"] = Localized(@"中国移动");
    } else if (net == 1) {
        self.setting[@"net"] = Localized(@"中国联通");
    } else {
        self.setting[@"net"] = Localized(@"中国电信");
    }
//    self.setting[@"net"] = setting.nettype;
    self.setting[@"map"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"map"]?Localized([[NSUserDefaults standardUserDefaults]objectForKey:@"map"]):Localized(@"高德地图");
//    NSString *laug = @"";
    self.setting[@"laug"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"laug"]?Localized([[NSUserDefaults standardUserDefaults]objectForKey:@"laug"]):Localized(@"简体中文");
//    [request startAsynchronous];
    //添加通知中心，监听语言改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:LanguageChanged object:nil];
}
- (void)setUpTab {
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.backgroundColor = LRRGBColor(1, 136, 251);
    LRViewBorderRadius(sureBtn, 5, 0, [UIColor clearColor]);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitle:Localized(@"确定") forState:UIControlStateNormal];
    [bottomView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(bottomView);
        make.width.equalTo(@(SCREEN_WIDTH - 30));
        make.height.equalTo(@45);
    }];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    bottomView.backgroundColor = [UIColor clearColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
}
- (void)sureClick {
    NSInteger i = 0;
    if ([self.setting[@"net"] isEqualToString:Localized(@"中国移动")]) {
        i = 0;
    } else if ([self.setting[@"net"] isEqualToString:Localized(@"中国联通")]) {
        i = 1;
    } else {
        i = 2;
    }
    [SharedSDK setSettingInfoIp:self.setting[@"ip"] Port:self.setting[@"dk"] Number:self.setting[@"picNum"] Interval:self.setting[@"tendS"] NetType:[NSString stringWithFormat:@"%d",i]];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.setting[@"map"] forKey:@"map"];
    [[NSUserDefaults standardUserDefaults] setValue:self.setting[@"laug"] forKey:@"laug"];
    [self showHUDWithText:Localized(@"保存成功")];
    [self performSelector:@selector(pop) withObject:nil afterDelay:1];
}
- (void)pop {
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"] isEqualToString:self.setting[@"laug"]]) {
//        NSString *str = @"";
        if ([self.setting[@"laug"] isEqualToString:@"简体中文"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        } else if ([self.setting[@"laug"] isEqualToString:@"繁体中文"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
        }
        
        //    [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];//发出通知-语言改变
//        [[NSNotificationCenter defaultCenter] postNotificationName:LanguageChanged object:nil];
        [self showLoadingHUDWithText:Localized(@"正在设置语言")];
        [self performSelector:@selector(loads) withObject:nil afterDelay:1];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
    
    
}
- (void)loads {
    [self hideHUD];
    self.view.window.rootViewController = [[BaseNaviViewController alloc]initWithRootViewController:[LoginViewController new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;
    if (section == 0) {
        if (netSelect) {
            num = 6;
        } else {
            num = 3;
        }
    } else if (section == 1) {
        if (laugSelect) {
            num += 4;
        } else {
            num += 1;
        }
        if (mapSelect) {
            num += 4;
        } else {
            num += 1;
        }
    } else {
        num = 2;
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *labelStr = @"";
    NSString *imageStr = @"";
    if (section == 0) {
        labelStr = Localized(@"服务器设置");
        imageStr = @"服务器";
    } else if (section == 1) {
        labelStr = Localized(@"客户端设置");
        imageStr = @"客户端";
    } else {
        labelStr = Localized(@"抓拍设置");
        imageStr = @"抓拍";
    }
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    UIButton *btn = [[UIButton alloc]init];
    [headView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).with.offset(15);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    [btn setTitleColor:LRRGBColor(28, 28, 28) forState:UIControlStateNormal];
    [btn setTitle:[@" " stringByAppendingString:labelStr] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"baseCell"];
    }
    UIView *sub1 = [cell viewWithTag:100];
    if (sub1) {
        [sub1 removeFromSuperview];
    }
    UIView *sub2 = [cell viewWithTag:101];
    if (sub2) {
        [sub2 removeFromSuperview];
    }
    UIView *sub3 = [cell viewWithTag:98];
    if (sub3) {
        [sub3 removeFromSuperview];
    }
    UIView *sub4 = [cell viewWithTag:99];
    if (sub4) {
        [sub4 removeFromSuperview];
    }
    UIView *sub5 = [cell viewWithTag:102];
    if (sub5) {
        [sub5 removeFromSuperview];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = LRRGBColor(59, 59, 59);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    NSString *titleStr = @"";
    NSString *detailStr = @"";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //ip
            titleStr = Localized(@"ip/域名");
            detailStr = @"";
            UITextField *input = [[UITextField alloc]init];
            input.tag = 98;
            [cell addSubview:input];
            [input mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.bottom.equalTo(cell);
                make.height.equalTo(@45);
                make.width.equalTo(@200);
            }];
            input.font = [UIFont systemFontOfSize:14];
            input.textAlignment = NSTextAlignmentRight;
            input.text = self.setting[@"ip"];
            input.placeholder = Localized(@"点击输入ip");
            [input addTarget:self action:@selector(inputChange:) forControlEvents:UIControlEventEditingChanged];
        } else if (indexPath.row == 1) {
            //端口
            titleStr = Localized(@"端口");
            detailStr = @"";
            UITextField *input = [[UITextField alloc]init];
            input.tag = 99;
            [cell addSubview:input];
            [input mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.bottom.equalTo(cell);
                make.height.equalTo(@45);
                make.width.equalTo(@200);
            }];
            input.font = [UIFont systemFontOfSize:14];
            input.textAlignment = NSTextAlignmentRight;
            input.text = self.setting[@"dk"];
            input.placeholder = Localized(@"点击输入端口");
        } else if (indexPath.row == 2) {
            if (netSelect) {
                //网络展开
                titleStr = Localized(@"网络设置");
                detailStr = @"";
                UIButton *zhankaiBtn = [[UIButton alloc]init];
                zhankaiBtn.tag = 102;
                [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [zhankaiBtn setTitle:[self.setting[@"net"] stringByAppendingString:@" "] forState:UIControlStateNormal];
                [zhankaiBtn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
                [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                zhankaiBtn.userInteractionEnabled = NO;
                [cell addSubview:zhankaiBtn];
                [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-15);
                    make.top.bottom.equalTo(cell);
                    make.height.equalTo(@45);
                }];
            } else {
                //网络未展开
                titleStr = Localized(@"网络设置");
                detailStr = @"";
                UIButton *zhankaiBtn = [[UIButton alloc]init];
                zhankaiBtn.tag = 102;
                [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [zhankaiBtn setTitle:[self.setting[@"net"] stringByAppendingString:@" "] forState:UIControlStateNormal];
                [zhankaiBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
                [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                zhankaiBtn.userInteractionEnabled = NO;
                [cell addSubview:zhankaiBtn];
                [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-15);
                    make.top.bottom.equalTo(cell);
                    make.height.equalTo(@45);
                }];
            }
        } else {
            if (indexPath.row == 3) {
                //移动
                titleStr = @"";
                detailStr = Localized(@"中国移动");
            } else if (indexPath.row == 4) {
                //联通
                titleStr = @"";
                detailStr = Localized(@"中国联通");
            } else {
                //电信
                titleStr = @"";
                detailStr = Localized(@"中国电信");
            }
        }
    } else if (indexPath.section == 1) {
        if (mapSelect) {
            if (indexPath.row == 0) {
                //地图展开
                titleStr = Localized(@"地图设置");
                detailStr = @"";
                UIButton *zhankaiBtn = [[UIButton alloc]init];
                zhankaiBtn.tag = 102;
                [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [zhankaiBtn setTitle:[Localized(self.setting[@"map"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                [zhankaiBtn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
                [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                zhankaiBtn.userInteractionEnabled = NO;
                [cell addSubview:zhankaiBtn];
                [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-15);
                    make.top.bottom.equalTo(cell);
                    make.height.equalTo(@45);
                }];
            } else if(indexPath.row == 1) {
                //高德
                titleStr = @"";
                detailStr = Localized(@"高德地图");
            } else if (indexPath.row == 2) {
                //百度
                titleStr = @"";
                detailStr = Localized(@"百度地图");
            } else if (indexPath.row == 3) {
                //谷歌
                titleStr = @"";
                detailStr = Localized(@"谷歌地图");
            } else {
                if (laugSelect) {
                    if (indexPath.row == 4) {
                        //语言展开
                        titleStr = Localized(@"系统语言");
                        detailStr = @"";
                        UIButton *zhankaiBtn = [[UIButton alloc]init];
                        zhankaiBtn.tag = 102;
                        [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                        zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [zhankaiBtn setTitle:[Localized(self.setting[@"laug"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                        [zhankaiBtn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
                        [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                        zhankaiBtn.userInteractionEnabled = NO;
                        [cell addSubview:zhankaiBtn];
                        [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(cell.mas_right).with.offset(-15);
                            make.top.bottom.equalTo(cell);
                            make.height.equalTo(@45);
                        }];
                    } else if (indexPath.row == 5) {
                        //简体中文
                        titleStr = @"";
                        detailStr = Localized(@"简体中文");
                    } else if (indexPath.row == 6) {
                        //繁体中文
                        titleStr = @"";
                        detailStr = Localized(@"繁体中文");
                    } else {
                        //英语
                        titleStr = @"";
                        detailStr = Localized(@"英语");
                    }
                } else {
                    //语言未展开
                    titleStr = Localized(@"系统语言");
                    detailStr = @"";
                    UIButton *zhankaiBtn = [[UIButton alloc]init];
                    zhankaiBtn.tag = 102;
                    [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                    zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [zhankaiBtn setTitle:[Localized(self.setting[@"laug"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                    [zhankaiBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
                    [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                    zhankaiBtn.userInteractionEnabled = NO;
                    [cell addSubview:zhankaiBtn];
                    [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.mas_right).with.offset(-15);
                        make.top.bottom.equalTo(cell);
                        make.height.equalTo(@45);
                    }];
                }
            }
        } else {
            if (indexPath.row == 0) {
                //地图未展开
                titleStr = Localized(@"地图设置");
                detailStr = @"";
                UIButton *zhankaiBtn = [[UIButton alloc]init];
                zhankaiBtn.tag = 102;
                [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [zhankaiBtn setTitle:[Localized(self.setting[@"map"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                [zhankaiBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
                [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                zhankaiBtn.userInteractionEnabled = NO;
                [cell addSubview:zhankaiBtn];
                [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).with.offset(-15);
                    make.top.bottom.equalTo(cell);
                    make.height.equalTo(@45);
                }];
            } else {
                if (laugSelect) {
                    if (indexPath.row == 1) {
                        //语言展开
                        titleStr = Localized(@"系统语言");
                        detailStr = @"";
                        UIButton *zhankaiBtn = [[UIButton alloc]init];
                        zhankaiBtn.tag = 102;
                        [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                        zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                        [zhankaiBtn setTitle:[Localized(self.setting[@"laug"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                        [zhankaiBtn setImage:[UIImage imageNamed:@"向上"] forState:UIControlStateNormal];
                        [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                        zhankaiBtn.userInteractionEnabled = NO;
                        [cell addSubview:zhankaiBtn];
                        [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.right.equalTo(cell.mas_right).with.offset(-15);
                            make.top.bottom.equalTo(cell);
                            make.height.equalTo(@45);
                        }];
                    } else if (indexPath.row == 2) {
                        //简体中文
                        titleStr = @"";
                        detailStr = Localized(@"简体中文");
                    } else if (indexPath.row == 3) {
                        //繁体中文
                        titleStr = @"";
                        detailStr = Localized(@"繁体中文");
                    } else {
                        //英语
                        titleStr = @"";
                        detailStr = Localized(@"英语");
                    }
                } else {
                    //语言未展开
                    titleStr = Localized(@"系统语言");
                    detailStr = @"";
                    UIButton *zhankaiBtn = [[UIButton alloc]init];
                    zhankaiBtn.tag = 102;
                    [zhankaiBtn setTitleColor:LRRGBColor(100, 100, 100) forState:UIControlStateNormal];
                    zhankaiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [zhankaiBtn setTitle:[Localized(self.setting[@"laug"]) stringByAppendingString:@" "] forState:UIControlStateNormal];
                    [zhankaiBtn setImage:[UIImage imageNamed:@"向下"] forState:UIControlStateNormal];
                    [zhankaiBtn setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                    zhankaiBtn.userInteractionEnabled = NO;
                    [cell addSubview:zhankaiBtn];
                    [zhankaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(cell.mas_right).with.offset(-15);
                        make.top.bottom.equalTo(cell);
                        make.height.equalTo(@45);
                    }];
                }
            }
        }
            
        
    
    } else {
        if (indexPath.row == 0) {
            //抓拍
            titleStr = Localized(@"抓拍张数");
            detailStr = @"";
            UITextField *input = [[UITextField alloc]init];
            input.tag = 100;
            [cell addSubview:input];
            [input mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.bottom.equalTo(cell);
                make.height.equalTo(@45);
                make.width.equalTo(@200);
            }];
            input.font = [UIFont systemFontOfSize:14];
            input.textAlignment = NSTextAlignmentRight;
            input.text = self.setting[@"picNum"];
            input.placeholder = Localized(@"点击输入抓拍张数");
        } else {
            //间隔
            titleStr = Localized(@"抓拍间隔（S）");
            detailStr = @"";
            UITextField *input = [[UITextField alloc]init];
            input.tag = 101;
            [cell addSubview:input];
            [input mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).with.offset(-15);
                make.top.bottom.equalTo(cell);
                make.height.equalTo(@45);
                make.width.equalTo(@200);
            }];
            input.font = [UIFont systemFontOfSize:14];
            input.textAlignment = NSTextAlignmentRight;
            input.text = self.setting[@"tendS"];
            input.placeholder = Localized(@"点击输入抓拍间隔时间");
        }
    }
    cell.detailTextLabel.text = detailStr;
    cell.textLabel.text = titleStr;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)inputChange:(UITextField *)textField {
    if (textField.tag == 98) {
        //ip
        self.setting[@"ip"] = textField.text;
    } else if (textField.tag == 99) {
        //端口
        self.setting[@"dk"] = textField.text;
    } else if (textField.tag == 100) {
        //张数
        self.setting[@"picNum"] = textField.text;
    } else {
        //间隔
        self.setting[@"tendS"] = textField.text;
    }
//    self.setting[@"ip"] = setting.ip;
//    self.setting[@"dk"] = setting.port;
//    self.setting[@"picNum"] = setting.numbers;
//    self.setting[@"tendS"] = setting.interval;
//    self.setting[@"net"] = setting.nettype;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //ip
            
        } else if (indexPath.row == 1) {
            //端口
           
        } else if (indexPath.row == 2) {
            if (netSelect) {
                //网络展开
                netSelect = NO;
                [self.tableView reloadData];
            } else {
                //网络未展开
                netSelect = YES;
                [self.tableView reloadData];
            }
        } else {
            if (indexPath.row == 3) {
                //移动
                self.setting[@"net"] = Localized(@"中国移动");
                [self.tableView reloadData];
            } else if (indexPath.row == 4) {
                //联通
                self.setting[@"net"] = Localized(@"中国联通");
                [self.tableView reloadData];
            } else {
                //电信
                self.setting[@"net"] = Localized(@"中国电信");
                [self.tableView reloadData];
            }
        }
    } else if (indexPath.section == 1) {
        if (mapSelect) {
            if (indexPath.row == 0) {
                //地图展开
                mapSelect = NO;
                [self.tableView reloadData];
            } else if(indexPath.row == 1) {
                //高德
                self.setting[@"map"] = @"高德地图";
                [self.tableView reloadData];
            } else if (indexPath.row == 2) {
                //百度
                self.setting[@"map"] = @"百度地图";
                [self.tableView reloadData];
            } else if (indexPath.row == 3) {
                //谷歌
                self.setting[@"map"] = @"谷歌地图";
                [self.tableView reloadData];
            } else {
                if (laugSelect) {
                    if (indexPath.row == 4) {
                        //语言展开
                        laugSelect = NO;
                        [self.tableView reloadData];
                    } else if (indexPath.row == 5) {
                        //简体中文
                        self.setting[@"laug"] = @"简体中文";
                        [self.tableView reloadData];
                    } else if (indexPath.row == 6) {
                        //繁体中文
                        self.setting[@"laug"] = @"繁体中文";
                        [self.tableView reloadData];
                    } else {
                        //英语
                        self.setting[@"laug"] = @"英语";
                        [self.tableView reloadData];
                    }
                } else {
                    //语言未展开
                    laugSelect = YES;
                    [self.tableView reloadData];
                }
            }
        } else {
            if (indexPath.row == 0) {
                //地图未展开
                mapSelect = YES;
                [self.tableView reloadData];
            } else {
                if (laugSelect) {
                    if (indexPath.row == 1) {
                        //语言展开
                        laugSelect = NO;
                        [self.tableView reloadData];
                       
                    } else if (indexPath.row == 2) {
                        //简体中文
                        self.setting[@"laug"] = @"简体中文";
                        [self.tableView reloadData];
                    } else if (indexPath.row == 3) {
                        //繁体中文
                        self.setting[@"laug"] = @"繁体中文";
                        [self.tableView reloadData];
                    } else {
                        //英语
                        self.setting[@"laug"] = @"英语";
                        [self.tableView reloadData];
                    }
                } else {
                    //语言未展开
                    laugSelect = YES;
                    [self.tableView reloadData];
                }
            }
        }
        
        
        
    } else {
        if (indexPath.row == 0) {
            //抓拍
            
        } else {
            //间隔
            
        }
    }
}
@end
