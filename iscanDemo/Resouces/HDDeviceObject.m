//
//  HDDeviceObject.m
//  iscanMC
//
//  Created by xsz on 21/8/14.
//  Copyright (c) 2014年 hongdian. All rights reserved.
//

#import "HDDeviceObject.h"

@implementation HDDeviceObject

@synthesize id;         //数据库生成的序号
@synthesize idno;		//设备编号，与用户账户信息里面的账号保持一致
@synthesize devType;	//设备类型
@synthesize devSubType;	//设备子类型
@synthesize factory;	//厂商
@synthesize icon;		//图标类型
@synthesize chnCount;	//通道数目
@synthesize devName;	//设备名称，名称间用,分隔
@synthesize chnName;	//通道名称，名称间用,分隔
@synthesize ioInCount;	//IO的数目
@synthesize ioInName;	//IO名称，名称间用,分隔
@synthesize tempCount;	//温度传感器数目
@synthesize tempName;	//温度传感器名称，名称间用,分隔
@synthesize simCard;		//SIM卡
@synthesize vehiBand;	//车辆品牌
@synthesize vehiType;	//车辆类型，大巴车 or 货运车
@synthesize vehiUse;		//车辆用途
@synthesize vehiColor;	//车辆颜色
@synthesize vehiCompany;	//车辆所属公司
@synthesize driverName;	//司机名称
@synthesize driverTele;	//司机电话
@synthesize dateProduct;	//生厂日期
@synthesize userID;		//拥有设备的客户账号
@synthesize devGroupId;	//设备所处的分组信息
@synthesize module;		//设备所拥有的模块信息
@synthesize userSex;		//性别
@synthesize userCardID;	//身份证
@synthesize userIDNO;		//用户编号
@synthesize userPost;		//用户职务		1队员，2队长
@synthesize userAddress;	//用户地址
@synthesize userEquip;	//所携带装备
@synthesize remarks;		//备注
@synthesize videoUrl;		//

/*
- (NSInteger)getUserSex {
    return userSex;
}
-(void)setUserSex: (NSInteger)_userSex {
    self.userSex = _userSex;
}
-(NSString*)getUserCardID {
    return userCardID;
}
-(void)setUserCardID: (NSString*)_userCardID {
    self.userCardID = _userCardID;
}
-(NSString*)getUserIDNO {
    return userIDNO;
}
-(void)setUserIDNO: (NSString*)_userIDNO {
    self.userIDNO = _userIDNO;
}
- (NSInteger)getUserPost {
    return userPost;
}
-(void)setUserPost: (NSInteger)_userPost {
    self.userPost = _userPost;
}
-(NSString*)getUserAddress {
    return userAddress;
}
-(void)setUserAddress: (NSString*)_userAddress {
    self.userAddress = _userAddress;
}
- (NSInteger)getUserEquip {
    return userEquip;
}
-(void)setUserEquip: (NSInteger)_userEquip {
    self.userEquip = _userEquip;
}
-(NSString*)getRemarks {
    return remarks;
}
-(void)setRemarks: (NSString*)_remarks {
    self.remarks = _remarks;
}
- (NSInteger)getId {
    return id;
}
-(void)setId: (NSInteger)_id {
    self.id = _id;
}
-(NSString*)getIdno {
    return idno;
}
-(void)setIdno: (NSString*)_idno {
    self.idno = _idno;
}
- (NSInteger)getDevType {
    return devType;
}
-(void)setDevType: (NSInteger)_devType {
    self.devType = _devType;
}
- (NSInteger)getFactory {
    return factory;
}
-(void)setFactory: (NSInteger)_factory {
    self.factory = _factory;
}
- (NSInteger)getChnCount {
    return chnCount;
}
-(void)setChnCount: (NSInteger)_chnCount {
    self.chnCount = _chnCount;
}
-(NSString*)getChnName {
    return chnName;
}
-(void)setChnName: (NSString*)_chnName {
    self.chnName = _chnName;
}
- (NSInteger)getIoInCount {
    return ioInCount;
}
-(void)setIoInCount: (NSInteger)_ioInCount {
    self.ioInCount = _ioInCount;
}
-(NSString*)getIoInName {
    return ioInName;
}
-(void)setIoInName: (NSString*)_ioInName {
    self.ioInName = _ioInName;
}
- (NSInteger)getTempCount {
    return tempCount;
}
-(void)setTempCount: (NSInteger)_tempCount {
    self.tempCount = _tempCount;
}
-(NSString*)getTempName {
    return tempName;
}
-(void)setTempName: (NSString*)_tempName {
    self.tempName = _tempName;
}
-(NSString*)getSimCard {
    return simCard;
}
-(void)setSimCard: (NSString*)_simCard {
    self.simCard = _simCard;
}
-(NSString*)getVehiBand {
    return vehiBand;
}
-(void)setVehiBand: (NSString*)_vehiBand {
    self.vehiBand = _vehiBand;
}
-(NSString*)getVehiType {
    return vehiType;
}
-(void)setVehiType: (NSString*)_vehiType {
    self.vehiType = _vehiType;
}
-(NSString*)getVehiUse {
    return vehiUse;
}
-(void)setVehiUse: (NSString*)_vehiUse {
    self.vehiUse = _vehiUse;
}
-(NSString*)getVehiColor {
    return vehiColor;
}
-(void)setVehiColor: (NSString*)_vehiColor {
    self.vehiColor = _vehiColor;
}
-(NSString*)getVehiCompany {
    return vehiCompany;
}
-(void)setVehiCompany: (NSString*)_vehiCompany {
    self.vehiCompany = _vehiCompany;
}
-(NSString*)getDriverName {
    return driverName;
}
-(void)setDriverName: (NSString*)_driverName {
    self.driverName = _driverName;
}
-(NSString*)getDriverTele {
    return driverTele;
}
-(void)setDriverTele: (NSString*)_driverTele {
    self.driverTele = _driverTele;
}
-(NSDate*)getDateProduct {
    return dateProduct;
}
-(void)setDateProduct:(NSDate*)_dateProduct {
    self.dateProduct = _dateProduct;
}
- (NSInteger)getUserID {
    return userID;
}
-(void)setUserID: (NSInteger)_userID {
    self.userID = _userID;
}
- (NSInteger)getDevGroupId {
    return devGroupId;
}
-(void)setDevGroupId: (NSInteger)_devGroupId {
    self.devGroupId = _devGroupId;
}
- (NSInteger)getIcon {
    return icon;
}
-(void)setIcon: (NSInteger)_icon {
    self.icon = _icon;
}
- (NSInteger)getModule {
    return module;
}
-(void)setModule: (NSInteger)_module {
    self.module = _module;
}
- (NSInteger)getDevSubType {
    return devSubType;
}
- (void)setDevSubType: (NSInteger)_devSubType
{
    devSubType = _devSubType;
}
*/
@end
