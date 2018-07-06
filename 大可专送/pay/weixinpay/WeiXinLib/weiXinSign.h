//
//  weiXinSign.h
//  DKDJForIPhone
//
//  Created by 张允鹏 on 16/6/30.
//
//

#import <Foundation/Foundation.h>

@interface weiXinSign : NSObject

/**
 *  生成随机32位字符串
 *
 *  @return 32位字符串
 */
+(NSString *)ret32bitString;
/**
 *  获取用户终端IP
 *
 *  @return 用户终端IP
 */
- (NSString *)getIPAddress;
- (void)suiJiZiFuChuan;
-(NSString *)genPackage:(NSMutableDictionary*)packageParams;
/**
 *  返回sign
 *
 *  @param dict 字典
 *
 *  @return 返回sign
 */
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict;

@end
