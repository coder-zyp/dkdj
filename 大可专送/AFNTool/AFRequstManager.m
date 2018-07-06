//
//  AFRequstManager.m
//  ZNmenjin
//
//  Created by 高帅 on 2016/12/23.
//  Copyright © 2016年 HebeiTiboshi. All rights reserved.
//

#import "AFRequstManager.h"


@implementation AFRequstManager

+(instancetype)shareInstance
{
   static AFRequstManager *anManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        anManager = [[AFRequstManager alloc]init];
    });
    return anManager;
}

+(NSURLSessionDataTask *)getUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror
{
   return [[AFRequstManager shareInstance] __request:@"GET" urlstr:urlstr requestData:parms compod:^(id responseObject, NSError *aerrror) {
       if (responseObject)
        {
           completion(responseObject);
       }else{
           anerror(aerrror);
       }
    }];
}
+(NSURLSessionDataTask *)postUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror
{
    NSMutableDictionary *parmars = [[NSMutableDictionary alloc]initWithDictionary:parms];
    //设置token
    return  [[AFRequstManager shareInstance] __request:@"POST" urlstr:urlstr requestData:parmars compod:^(id responseObject, NSError *aerrror) {
        if (responseObject) {
            completion(responseObject);
        }else{
            anerror(aerrror);
        }
    }];
}

+(NSURLSessionDataTask *)deleteUrlStr:(NSString *)urlstr andParms:(NSDictionary *)parms andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror
{
    NSMutableDictionary *parmars = [[NSMutableDictionary alloc]initWithDictionary:parms];
    //设置token
    return  [[AFRequstManager shareInstance] __request:@"DELETE" urlstr:urlstr requestData:parmars compod:^(id responseObject, NSError *aerrror) {
        if (responseObject) {
            completion(responseObject);
        }else{
            anerror(aerrror);
        }
    }];
}

/**
 * 基础的网络请求
 */
-(NSURLSessionDataTask *)__request:(NSString *)method urlstr:(NSString *)url requestData:(id)requestData compod:(void(^)(id responseObject, NSError *aerrror))compoletion
{
#ifdef DEBUG_INTERNET
    NSLog(@"请求参数%@",requestData);
#else
#endif
    if ([url isEqualToString:@""])
      {
        NSError *error = [NSError errorWithDomain:@"-----400" code:400 userInfo:nil];
        compoletion(nil,error);
        return nil;
      }
#pragma mark GET请求
    if ([method isEqualToString:@"GET"])
      {
        return  [self.afManager GET:url parameters:requestData progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                compoletion(responseObject,nil);
              }
            else
              {
                id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              if (!comp) {
               NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
               comp = str;
              }
                compoletion(comp,nil);
                
              }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error)
              {
#ifdef DEBUG_INTERNET
                NSLog(@"%s get请求失败 %@",__FUNCTION__,url);
#endif
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
            NSError *error = [NSError errorWithDomain:@"-----909" code:900 userInfo:nil];
            
            compoletion(nil,error);
            return nil;
          }
        return  [self.afManager POST:url parameters:requestData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
              {
                compoletion(responseObject,nil);
              }else{
                  id comp =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  
                  compoletion(comp,nil);
#ifdef DEBUG_INTERNET
                  NSLog(@"--url-%@--%@",url,comp);
#endif

              }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error)
              {
#ifdef DEBUG_INTERNET
                NSLog(@"%s post请求失败 %@",__FUNCTION__,url);
#endif
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
        return  [self.afManager PUT:url parameters:requestData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
            if ([responseObject isKindOfClass:[NSDictionary class]])
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
        //发出delete请求
        return  [self.afManager DELETE:url parameters:requestData success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]])
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

#pragma mark MANAGER

-(AFHTTPSessionManager *)afManager
{
    if (_afmanager)
      {
        return _afmanager;
      }
    _afmanager = [AFHTTPSessionManager manager];
     _afmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"image/jpeg",@"image/png", @"application/octet-stream",@"text/json",nil];
    _afmanager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_afmanager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    
#ifdef SECURITY_REQUEST
    [self securityValidation:_afManager];
#endif
    //设置请求超时的时间
    _afmanager.requestSerializer.timeoutInterval = 10.0f;
    [_afmanager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    return _afmanager;
}
-(void)securityValidation:(AFHTTPSessionManager *)aManager
{
    NSString *certFilePath = [[NSBundle mainBundle] pathForResource:@"security" ofType:@"cer"];
    
    NSData *certData = [NSData dataWithContentsOfFile:certFilePath];
    if (!certData)
    {
        return;
    }
    NSSet *certSet = [NSSet setWithObject:certData];
    
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey withPinnedCertificates:certSet];
    policy.allowInvalidCertificates = YES;
    aManager.securityPolicy = policy;
}



#pragma mark uploadImage

-(NSURLSessionDataTask *)upload:(NSString *)url andParmrs:(id)parmrs uiimages:(NSArray *)images andCompletion:(void(^)(id obj))completion Error:(void(^)(NSError *errror))anerror
{
    __weak AFRequstManager *weakSelf = self;
   return  [self.afmanager POST:url parameters:parmrs constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
       for (int i = 0; i< images.count; i++)
        {
           UIImage *image = images[i];
           NSData *imageData =UIImageJPEGRepresentation(image,1);
          if (imageData.length>5000)
            {
              imageData = [weakSelf compressOriginalImage:image toMaxDataSizeKBytes:5];
            }
           NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
           formatter.dateFormat =@"yyyyMMddHHmmss";
           NSString *str = [formatter stringFromDate:[NSDate date]];
           NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
           [formData appendPartWithFileData:imageData name:@"mypic" fileName:fileName mimeType:@"image/jpg"];
       }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度 完成的大小
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            NSString *progressStr = [NSString stringWithFormat:@"%.2f",progress];
            //进度条
            [[NSNotificationCenter defaultCenter]postNotificationName:@"progressChange" object:progressStr];
#ifdef DEBUG_INTERNET
            NSLog(@"------%@",progressStr);
#endif
        });
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        NSError *anError = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&anError];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
             completion(obj);
            }
        });
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        dispatch_async(dispatch_get_main_queue(), ^{
            if (anerror)
            {
              anerror(error);
            }
        });
    }];
}
//-(NSURLSessionDataTask *)uploadUIimages:(UIImage *)image
//                          andCompletion:(void(^)(id obj))completion
//                                  Error:(void(^)(NSError *errror))anerror
//{
//    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:@{
//                                                        @"sid":[User shareInstance].Id,
//                                                        @"token":token
//                                                        }
//                               ];
//    return   [self upload:APPentApi(@"UploadFile", @"save_quan_logo") andParmrs:dic uiimages:@[image] andCompletion:^(id obj)
//    {
//        if (completion)
//        {
//            completion(obj);
//        }
//    } Error:^(NSError *errror)
//    {
//        if (anerror)
//        {
//            anerror(errror);
//        }
//    }];
//}
//
//-(NSURLSessionDataTask *)uploadHeaderImages:(UIImage *)image
//                          andCompletion:(void(^)(id obj))completion
//                                  Error:(void(^)(NSError *errror))anerror
//{
//    if ([User shareInstance].Id==nil)
//    {
//        return nil;
//    }
//    
//    NSMutableDictionary *dic =[[NSMutableDictionary alloc]initWithDictionary:@{
//                                                  @"sid":[User shareInstance].Id,
//                                                                               @"token":token
//                                                                               }];
//    
//    return   [self upload:APPentApi(@"UploadFile", @"set_shop_header") andParmrs:dic uiimages:@[image] andCompletion:^(id obj) {
//        if (completion) {
//            completion(obj);
//        }
//        
//    } Error:^(NSError *errror) {
//        if (anerror) {
//            anerror(errror);
//        }
//    }];
//    
//}

/**
 *  压缩图片到指定文件大小 kb计算
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
-(NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size
{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f)
      {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes)
        {
          break;
        }else{
            lastData = dataKBytes;
        }
      }
    return data;
}



-(void)ancelAllRequest
{
    NSArray *tasks = self.afManager.tasks;
    
    for (NSURLSessionDataTask *task in tasks)
      {
        [task cancel];
      }
}

-(void)dealloc
{
    [self ancelAllRequest];
}


@end
