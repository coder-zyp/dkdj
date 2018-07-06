//
//  NSDictionary+ZJson.m
//  ZNmenjin
//
//  Created by 高帅 on 2016/12/25.
//  Copyright © 2016年 HebeiTiboshi. All rights reserved.
//

#import "NSDictionary+ZJson.h"

@implementation NSDictionary (ZJson)

-(NSString*)dicToJson

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+(NSDictionary *)jsonStrToDic:(NSString *)jsonString
{
    
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    return dic;
    
}


@end
