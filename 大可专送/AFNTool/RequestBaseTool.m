//
//  RequestBaseTool.m
//  Reader
//
//  Created by ios2 on 2017/12/8.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "RequestBaseTool.h"
#import "CommonFunc.h"

//设置请求超时时长
#define requestTimeoutInterval 20.0f

#define ISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )


#define DESKEY_VOTE    @"6V94Ru3T0"
//编码
#define CommonFunc_encode_DESKEY(known, key) [CommonFunc encode:known withKey:key]
//解码
#define CommonFunc_decode_DESKEY(known, key) [CommonFunc decode:known withKey:key]







@implementation RequestBaseTool




+(instancetype)shareInstance
{
    
    static RequestBaseTool *anManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anManager = [[RequestBaseTool alloc]init];
    });
    
    return anManager;
}


+(NSURLSessionDataTask *)ecodePostUrlStr:(NSString *)urlstr
                                andParms:(id)parms
                            andParamData:(NSString*)paramData
                           andCompletion:(void(^)(id obj))completion
                                   Error:(void(^)(NSError *errror))anerror
{
    
    NSMutableDictionary *dic = [parms mutableCopy];
      NSString *ss = [[[paramData stringByReplacingOccurrencesOfString:@"\"" withString:@"”"]stringByReplacingOccurrencesOfString:@";" withString:@"；" ] stringByReplacingOccurrencesOfString:@"'" withString:@"‘"];
    // 加密参数
    NSString * paramData_encode = CommonFunc_encode_DESKEY(ss, DESKEY_VOTE);
    
    NSString *sendString = [NSString stringWithFormat:@"%@",paramData_encode];
    
     [dic setValue:sendString forKey:@"paramData"];
    
    return  [[RequestBaseTool shareInstance] __request:@"POST"
                                                urlstr:urlstr
                                           requestData:dic
                                            andIsEcode:YES
                                                compod:^(id responseObject,
                                                         NSError *aerrror) {
                                                    if (responseObject)
                                                    {
                                                        completion(responseObject);
                                                    }else{
                                                        anerror(aerrror);
                                                    }
                                                }];
    
}

+(NSURLSessionDataTask *)getUrlStr:(NSString *)urlstr
                          andParms:(NSDictionary *)parms
                     andCompletion:(void(^)(id obj))completion
                             Error:(void(^)(NSError *errror))anerror
{
    return  [[RequestBaseTool shareInstance] __request:@"GET"
                                                urlstr:urlstr
                                           requestData:parms
                                              andIsEcode:NO
                                                compod:^(id responseObject, NSError *aerrror) {
        if (responseObject)
        {
            completion(responseObject);
        }else{
            anerror(aerrror);
        }
    }];
}
+(NSURLSessionDataTask *)postUrlStr:(NSString *)urlstr
                           andParms:(id)parms
                      andCompletion:(void(^)(id obj))completion
                              Error:(void(^)(NSError *errror))anerror
{
    id parmars = parms;
    if ([parms isKindOfClass:[NSDictionary class]])
    {
        parmars = [[NSMutableDictionary alloc]initWithDictionary:parms];
    }
    
    return  [[RequestBaseTool shareInstance] __request:@"POST"
                                             urlstr:urlstr
                                        requestData:parmars
                                            andIsEcode:NO
                                             compod:^(id responseObject,
                                                      NSError *aerrror) {
                                                 if (responseObject)
                                                 {
                                                     completion(responseObject);
                                                 }else{
                                                     anerror(aerrror);
                                                 }
                }];
}

/**
 * 基础的网络请求
 */
-(NSURLSessionDataTask *)__request:(NSString *)method
                            urlstr:(NSString *)url
                       requestData:(id)requestData
                        andIsEcode:(BOOL)isEcode
                            compod:(void(^)(id responseObject, NSError *aerrror))compoletion;
{
#ifdef DEBUG
    NSLog(@"请求参数--------- %@",requestData);
#endif
    if (ISNullString(url))
    {
        NSError *error = [NSError errorWithDomain:@"-----400" code:400 userInfo:nil];
        compoletion(nil,error);
        return nil;
    }
#pragma mark GET请求
    if ([method isEqualToString:@"GET"])
    {
        return  [self.afmanager GET:url parameters:requestData progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isEcode)
            {
                //加密回执解密
                NSData *responseData;
                NSString *string = [[NSString alloc] initWithData:responseObject encoding: NSUTF8StringEncoding];
                responseData = [CommonFunc_decode_DESKEY(string, DESKEY_VOTE) dataUsingEncoding:NSUTF8StringEncoding];
                id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
                compoletion(result,nil);
                
            }else  if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                compoletion(responseObject,nil);
            }
            else
            {
                id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                compoletion(comp,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error)
            {
                if (compoletion)
                {
                    compoletion(nil,error);
                }
            }
        }];
    }
#pragma mark POST请求
    if([method isEqualToString:@"POST"])
    {
        //发出post请求
        if (requestData ==nil)
        {
            NSLog(@"请求参数为空");
            NSError *error = [NSError errorWithDomain:@"-----909" code:400 userInfo:nil];
            compoletion(nil,error);
            return nil;
        }
        return  [self.afmanager POST:url parameters:requestData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (isEcode)
            {
                //加密回执解密
                NSData *responseData;
                NSString *string = [[NSString alloc] initWithData:responseObject encoding: NSUTF8StringEncoding];
                responseData = [CommonFunc_decode_DESKEY(string, DESKEY_VOTE) dataUsingEncoding:NSUTF8StringEncoding];
                id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
                compoletion(result,nil);
                
            }else  if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                compoletion(responseObject,nil);
            }else{
                id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                compoletion(comp,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error)
            {
                if (compoletion)
                {
                    compoletion(nil,error);
                }
            }
        }];
        
    }
#pragma mark PUT请求
    if([method isEqualToString:@"PUT"]){
        //发出PUT请求
        return  [self.afmanager PUT:url parameters:requestData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            
            if (isEcode)
            {
                NSData *responseData;
                NSString *string = [[NSString alloc] initWithData:responseObject encoding: NSUTF8StringEncoding];
                 responseData = [CommonFunc_decode_DESKEY(string, DESKEY_VOTE) dataUsingEncoding:NSUTF8StringEncoding];
                 id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
                compoletion(result,nil);
                
            }else if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                compoletion(responseObject,nil);
            }
            else
            {
                id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                compoletion(comp,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            compoletion(nil,error);
        }];
    }
#pragma mark DELETE请求
    
    if([method isEqualToString:@"DELETE"])
    {
        return  [self.afmanager DELETE:url parameters:requestData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isEcode)
            {
                //加密回执解密
                NSData *responseData;
                NSString *string = [[NSString alloc] initWithData:responseObject encoding: NSUTF8StringEncoding];
                responseData = [CommonFunc_decode_DESKEY(string, DESKEY_VOTE) dataUsingEncoding:NSUTF8StringEncoding];
                id result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
                compoletion(result,nil);
                
            }else  if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                compoletion(responseObject,nil);
            }
            else
            {
                id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                compoletion(comp,nil);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            compoletion(nil,error);
        }];
        
    }
    return nil;
}

-(AFHTTPSessionManager *)afmanager
{
    if (_afmanager==nil)
    {
        _afmanager = [AFHTTPSessionManager manager];
    }
    _afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                            @"text/html",
                                                            @"image/jpeg",
                                                            @"image/png",
                                                            @"text/json",
                                                            @"xml",nil];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_afmanager.requestSerializer willChangeValueForKey:@"timeoutInterval"];

    //设置请求超时的时间
    _afmanager.requestSerializer.timeoutInterval = requestTimeoutInterval;
    [_afmanager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return _afmanager;
}

@end
