//
//  NSDictionary+ZJson.h
//  ZNmenjin
//
//  Created by 高帅 on 2016/12/25.
//  Copyright © 2016年 HebeiTiboshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZJson)

//字典转json  字符串

-(NSString*)dicToJson;

/**
 * json字符串转字典
 */
+(NSDictionary *)jsonStrToDic:(NSString *)jsonString;


@end
