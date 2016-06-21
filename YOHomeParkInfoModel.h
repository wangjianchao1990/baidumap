//
//  YOHomeParkInfoModel.h
//  OnlineParking
//
//  Created by MAC on 15/12/4.
//  Copyright © 2015年 北京麦芽田网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YOHomeParkInfoModel : NSObject

@property (nonatomic,copy) NSString *parkingInfoState;
@property (nonatomic,copy) NSString *parkingInfoName;
@property (nonatomic,copy) NSString *parkingInfoRestParkingSpaces;
@property (nonatomic,copy) NSString *parkingInfoAddress;
@property (nonatomic,copy) NSString *parkingInfoCreateManagerType;
@property (nonatomic,copy) NSString *parkingInfoCreateTime;
@property (nonatomic,copy) NSString *parkingInfoId;
@property (nonatomic,copy) NSString *parkingInfoLatitude;
@property (nonatomic,copy) NSString *parkingInfoLongitude;
@property (nonatomic,copy) NSString *parkingInfoParkingSpaces;
@property (nonatomic,copy) NSString *parkingInfoCreateManagerId;

@property (nonatomic, copy) NSString * parkingInfojuliFromMe;

@end
