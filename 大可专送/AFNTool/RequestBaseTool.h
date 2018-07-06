//
//  RequestBaseTool.h
//  Reader
//
//  Created by ios2 on 2017/12/8.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//api文件
#import "APIFile.h"

@interface RequestBaseTool : NSObject

@property (nonatomic,strong)AFHTTPSessionManager *afmanager;


//---------------加密---------------——|请求---------——|

+(NSURLSessionDataTask *)ecodePostUrlStr:(NSString *)urlstr
                                andParms:(id)parms
                            andParamData:(NSString*)paramData
                           andCompletion:(void(^)(id obj))completion
                                   Error:(void(^)(NSError *errror))anerror;


//------------------基础非加密请求---------------------|
+(NSURLSessionDataTask *)getUrlStr:(NSString *)urlstr
                          andParms:(NSDictionary *)parms
                     andCompletion:(void(^)(id obj))completion
                             Error:(void(^)(NSError *errror))anerror;

+(NSURLSessionDataTask *)postUrlStr:(NSString *)urlstr
                           andParms:(id)parms
                      andCompletion:(void(^)(id obj))completion
                              Error:(void(^)(NSError *errror))anerror;


//------------------基础请求---------------------|
-(NSURLSessionDataTask *)__request:(NSString *)method
                            urlstr:(NSString *)url
                       requestData:(id)requestData
                        andIsEcode:(BOOL)isEcode
                            compod:(void(^)(id responseObject, NSError *aerrror))compoletion;

@end
