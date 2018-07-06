//
//  APIFile.h
//  Reader
//
//  Created by ios2 on 2017/12/8.
//  Copyright © 2017年 石家庄光耀. All rights reserved.


/**************************************************************
 ****                   api detail file                    ****
 **************************************************************
 */
#ifndef APIFile_h
#define APIFile_h

#import <UIKit/UIKit.h>
//宏定义文件
//#import "RMacro.h"
/**
 *  用于拼接api的宏定义
 */
#define AppendAPI(api) [[BaseUrl stringByAppendingString:api]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]

/**
 * 首页数据Api 能够获取首页轮播、热门小说 、精品推荐、最新上架 最近更新、热门收藏！但是获取不到热门搜索部分的内容！
 */
static NSString *shouye_Api = @"shouye/shouye.php?action=shouye";

/** Get 频道接口
 * common/pindao.php?action=pindao
 * 选择频道(1:完结；2：个性；3：男性；4：女性；5：漫画)
 */
static NSString *channel_Api = @"common/pindao.php?action=pindao";
/**
 * 热门搜索切换
 *  type 1（1：今日点击；2：本周点击；3：本周收藏；4：完本排行）
 */

static NSString *hotSearchChange_Api = @"shouye/shouye.php?action=changTab";



/**
 精选 api
 */
static NSString *jingxuan_Api = @"jingxuan/jingxuan.php?action=jingXuan";


/**
 *  解解释：  排行榜api
 *  GET方法  首页 需要请求 数据
 *  type  ：{1，3，4，7} (1:今日点击；2:人气榜；3:本周点击；4：本周收藏；5：总点击榜；6：总字数榜；7：完本排行榜；8：新书榜；9：最近阅读)
 */
static NSString *paihang_Api = @"common/paihang.php?action=paihang";


/**
 * 书籍详情  GET
 * bookedetail/bookedetail.php?action=bookedetail
 * 需要的参数： itemid 小说id
 * 返回参数中 isfinish  是否完结   1：连载中; 2：完结
 */
static NSString * bookdetail_Api = @"bookedetail/bookedetail.php?action=bookedetail";

/** GET
 *  获取书评的API
 *  itemid 书ID
 *  page  页码 默认 从 1 开始
 *  limit  显示数目 10   单个 10个
 * bookedetail/bookedetail.php?action=comment
 */
static NSString *comment_Api = @"bookedetail/bookedetail.php?action=comment";

/** GET
 * 获取书籍目录 bookedetail/bookedetail.php?action=mulu
 */
//---------------------------

static NSString *bookMulu_Api = @"bookedetail/bookedetail.php?action=mulu";

/** Post
 * 请求 频道中的更多书籍内容的接口
 * catid 分类id
 * sortname （1：点击量；2：收藏量；3：更新时间；4：字数）
 * isfinish （0：全部；1：连载；2：完本；）
 * sorttype DESC（ASC：正序；DESC：倒序）
 * limit 每页显示    8 默认使用8
 * page  当前页码 默认从  1 开始
 */
static NSString *  pindaoMore_Api  = @"common/pindao.php?action=more";

/**
 * 搜索结果  GET
 * common/search.php?action=search
 * 需要的参数： key 检索值   page 页码  limit 显示数目
 * 返回参数中 isfinish  是否完结   1：连载中; 2：完结
 */
static NSString *search_APi = @"common/search.php?action=search";

#endif /* APIFile_h */
