//
//  HDDeviceStatus.m
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import "HDDeviceStatus.h"

@implementation HDDeviceStatus

//标识属性
@synthesize id;
//设备编号
@synthesize devIdno;
//网络类型，1表示3G，2表示WIFI
@synthesize network;
//网络名称
@synthesize netName;		//wifi情况下表示wifi的ssid
//网关服务器编号
@synthesize gwsvrIdno;
//在线状态
@synthesize online;
//状态
@synthesize status1;
//状态
@synthesize status2;
//状态
@synthesize status3;
//状态
@synthesize status4;
//温度传感器
@synthesize tempSensor1;
@synthesize tempSensor2;
@synthesize tempSensor3;
@synthesize tempSensor4;
//速度
@synthesize speed;
//方向
@synthesize huangXiang;
//经度
@synthesize jingDu;
//纬度
@synthesize weiDu;
//高度
@synthesize gaoDu;
//源地图类型
@synthesize srcMapType;
//源地图经度
@synthesize srcMapJingDu;
//源地图纬度
@synthesize srcMapWeiDu;
//经度	地图上使用的
@synthesize mapJingDu;
//纬度
@synthesize mapWeiDu;
//停车时长
@synthesize parkTime;
//里程
@synthesize liCheng;
//GPS时间
@synthesize gpsTime;
//地址
@synthesize ip;
@synthesize port;
//更新时间
@synthesize updateTime;

@end
