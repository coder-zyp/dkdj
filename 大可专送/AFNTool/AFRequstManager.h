//
//  AFRequstManager.h
//  ZNmenjin
//
//  Created by 高帅 on 2016/12/23.
//  Copyright © 2016年 HebeiTiboshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFRequstManager : NSObject

//创建对象

+(instancetype)shareInstance;

@property (nonatomic, strong) AFHTTPSessionManager *afmanager;

//get请求

/**
 * @brief Get请求.
 *
 * @param  urlstr 请求url字符串.
 *
 * @param  parms 请求参数的字典.
 *
 * @param  completion 成功的回调
 *
 * @param  anerror 错误的回调
 *
 * @return task 会话对象.
 */

+(NSURLSessionDataTask *)getUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror;

/**
 * @brief Post请求.
 *
 * @param  urlstr 请求url字符串.
 *
 * @param  parms 请求参数的字典.
 *
 * @param  completion 成功的回调
 *
 * @param  anerror 错误的回调
 *
 * @return task 会话对象.
 */
+(NSURLSessionDataTask *)postUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror;
/**
 * @brief Delete请求.
 *
 * @param  urlstr 请求url字符串.
 *
 * @param  parms 请求参数的字典.
 *
 * @param  completion 成功的回调
 *
 * @param  anerror 错误的回调
 *
 * @return task 会话对象.
 */

+(NSURLSessionDataTask *)deleteUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror;

/** 
 * @brief 上传多张图片的方法.
 *
 * @param  url 上传图片的地址.
 *
 * @param  images 要上传图片的所有图片.
 *
 * @return NSURLSessionDataTask 会话task.
 */

-(NSURLSessionDataTask *)upload:(NSString *)url andParmrs:(id)parmrs uiimages:(NSArray *)images andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror;



//上传logo
-(NSURLSessionDataTask *)uploadUIimages:(UIImage *)image andCompletion:(void(^)(id obj))completion
                                  Error:(void(^)(NSError *errror))anerror;

-(NSURLSessionDataTask *)uploadHeaderImages:(UIImage *)image
                              andCompletion:(void(^)(id obj))completion
                                      Error:(void(^)(NSError *errror))anerror;

-(void)ancelAllRequest;

@end
