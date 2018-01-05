//
//  HDDeviceObject.h
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int DEVICE_CLIENT_NULL = 0;

static const int DEVICE_TYPE_MDVR = 1;
static const int DEVICE_TYPE_MOBILE = 2;
static const int DEVICE_TYPE_DVS = 3;

static const int SEX_MALE = 1;		//男
static const int SEX_FEMALE = 2;	//女

static const int POST_MEMBER = 1;	//队员
static const int POST_CAPTAIN = 2;	//队长

static const int MAX_CHN_COUNT = 8;

@interface HDDeviceObject : NSObject
{
    NSInteger id;           //数据库生成的序号
    NSString* idno;         //设备编号，与用户账户信息里面的账号保持一致
    NSInteger devType;      //设备类型
    NSInteger devSubType;	//设备子类型
    NSInteger factory;      //厂商
    NSInteger icon;         //图标类型
    NSInteger chnCount;     //通道数目
    NSString* devName;
    NSString* chnName;		//通道名称，名称间用,分隔
    NSInteger ioInCount;	//IO的数目
    NSString* ioInName;     //IO名称，名称间用,分隔
    NSInteger tempCount;	//温度传感器数目
    NSString* tempName;     //温度传感器名称，名称间用,分隔
    NSString* simCard;		//SIM卡
    NSString* vehiBand;     //车辆品牌
    NSString* vehiType;     //车辆类型，大巴车 or 货运车
    NSString* vehiUse;		//车辆用途
    NSString* vehiColor;	//车辆颜色
    NSString* vehiCompany;	//车辆所属公司
    NSString* driverName;	//司机名称
    NSString* driverTele;	//司机电话
    NSDate* dateProduct;	//生厂日期
    NSInteger userID;		//拥有设备的客户账号
    NSInteger devGroupId;	//设备所处的分组信息
    NSInteger module;		//设备所拥有的模块信息
    NSInteger userSex;		//性别
    NSString* userCardID;	//身份证
    NSString* userIDNO;		//用户编号
    NSInteger userPost;		//用户职务		1队员，2队长
    NSString* userAddress;	//用户地址
    NSInteger userEquip;	//所携带装备
    NSString* remarks;		//备注
    NSString* videoUrl;		//
}

@property (nonatomic, assign) NSInteger id;		//数据库生成的序号
@property (nonatomic, copy) NSString* idno;		//设备编号，与用户账户信息里面的账号保持一致
@property (nonatomic, assign) NSInteger devType;	//设备类型
@property (nonatomic, assign) NSInteger devSubType;	//设备子类型
@property (nonatomic, assign) NSInteger factory;	//厂商
@property (nonatomic, assign) NSInteger icon;		//图标类型
@property (nonatomic, assign) NSInteger chnCount;	//通道数目
@property (nonatomic, copy) NSString* devName;		//设备名称，名称间用,分隔
@property (nonatomic, copy) NSString* chnName;		//通道名称，名称间用,分隔
@property (nonatomic, assign) NSInteger ioInCount;	//IO的数目
@property (nonatomic, copy) NSString* ioInName;	//IO名称，名称间用,分隔
@property (nonatomic, assign) NSInteger tempCount;	//温度传感器数目
@property (nonatomic, copy) NSString* tempName;	//温度传感器名称，名称间用,分隔
@property (nonatomic, copy) NSString* simCard;		//SIM卡
@property (nonatomic, copy) NSString* vehiBand;	//车辆品牌
@property (nonatomic, copy) NSString* vehiType;	//车辆类型，大巴车 or 货运车
@property (nonatomic, copy) NSString* vehiUse;		//车辆用途
@property (nonatomic, copy) NSString* vehiColor;	//车辆颜色
@property (nonatomic, copy) NSString* vehiCompany;	//车辆所属公司
@property (nonatomic, copy) NSString* driverName;	//司机名称
@property (nonatomic, copy) NSString* driverTele;	//司机电话
@property (nonatomic, retain) NSDate* dateProduct;	//生厂日期
@property (nonatomic, assign) NSInteger userID;		//拥有设备的客户账号
@property (nonatomic, assign) NSInteger devGroupId;	//设备所处的分组信息
@property (nonatomic, assign) NSInteger module;		//设备所拥有的模块信息
@property (nonatomic, assign) NSInteger userSex;		//性别
@property (nonatomic, copy) NSString* userCardID;	//身份证
@property (nonatomic, copy) NSString* userIDNO;		//用户编号
@property (nonatomic, assign) NSInteger userPost;		//用户职务		1队员，2队长
@property (nonatomic, copy) NSString* userAddress;	//用户地址
@property (nonatomic, assign) NSInteger userEquip;	//所携带装备
@property (nonatomic, copy) NSString* remarks;		//备注
@property (nonatomic, copy) NSString* videoUrl;		//
@end
