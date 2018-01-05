//
//  HDDeviceStatus.h
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDeviceStatus : NSObject
{
    //标识属性
	NSInteger id;
	//设备编号
	NSString* devIdno;
	//网络类型，1表示3G，2表示WIFI
	NSInteger network;
	//网络名称
	NSString* netName;		//wifi情况下表示wifi的ssid
	//网关服务器编号
	NSString* gwsvrIdno;
	//在线状态
	NSInteger online;
	//状态
	NSInteger status1;
	//状态
	NSInteger status2;
	//状态
	NSInteger status3;
	//状态
	NSInteger status4;
	//温度传感器
	NSInteger tempSensor1;
	NSInteger tempSensor2;
	NSInteger tempSensor3;
	NSInteger tempSensor4;
	//速度
	NSInteger speed;
	//方向
	NSInteger huangXiang;
	//经度
	NSInteger jingDu;
	//纬度
	NSInteger weiDu;
	//高度
	NSInteger gaoDu;
	//源地图类型
	NSInteger srcMapType;
	//源地图经度
	NSInteger srcMapJingDu;
	//源地图纬度
	NSInteger srcMapWeiDu;
	//经度	地图上使用的
	NSString* mapJingDu;
	//纬度
	NSString* mapWeiDu;
	//停车时长
	NSInteger parkTime;
	//里程
	NSInteger liCheng;
	//GPS时间
    NSDate* gpsTime;
	//地址
	NSString* ip;
	NSInteger port;
	//更新时间
	NSDate* updateTime;
}

//标识属性
@property (nonatomic, assign) NSInteger id;
//设备编号
@property (nonatomic, copy) NSString* devIdno;
//网络类型，1表示3G，2表示WIFI
@property (nonatomic, assign) NSInteger network;
//网络名称
@property (nonatomic, copy) NSString* netName;		//wifi情况下表示wifi的ssid
//网关服务器编号
@property (nonatomic, copy) NSString* gwsvrIdno;
//在线状态
@property (nonatomic, assign) NSInteger online;
//状态
@property (nonatomic, assign) NSInteger status1;
//状态
@property (nonatomic, assign) NSInteger status2;
//状态
@property (nonatomic, assign) NSInteger status3;
//状态
@property (nonatomic, assign) NSInteger status4;
//温度传感器
@property (nonatomic, assign) NSInteger tempSensor1;
@property (nonatomic, assign) NSInteger tempSensor2;
@property (nonatomic, assign) NSInteger tempSensor3;
@property (nonatomic, assign) NSInteger tempSensor4;
//速度
@property (nonatomic, assign) NSInteger speed;
//方向
@property (nonatomic, assign) NSInteger huangXiang;
//经度
@property (nonatomic, assign) NSInteger jingDu;
//纬度
@property (nonatomic, assign) NSInteger weiDu;
//高度
@property (nonatomic, assign) NSInteger gaoDu;
//源地图类型
@property (nonatomic, assign) NSInteger srcMapType;
//源地图经度
@property (nonatomic, assign) NSInteger srcMapJingDu;
//源地图纬度
@property (nonatomic, assign) NSInteger srcMapWeiDu;
//经度	地图上使用的
@property (nonatomic, copy) NSString* mapJingDu;
//纬度
@property (nonatomic, copy) NSString* mapWeiDu;
//停车时长
@property (nonatomic, assign) NSInteger parkTime;
//里程
@property (nonatomic, assign) NSInteger liCheng;
//GPS时间
@property (nonatomic, retain) NSDate* gpsTime;
//地址
@property (nonatomic, copy) NSString* ip;
@property (nonatomic, assign) NSInteger port;
//更新时间
@property (nonatomic, retain) NSDate* updateTime;

@end
