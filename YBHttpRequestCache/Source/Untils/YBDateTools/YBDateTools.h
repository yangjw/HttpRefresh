//
//  YBDateTools.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>
static const unsigned int allCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

@interface YBDateTools : NSObject

+ (instancetype)shareManager;


/** 日期转时间戳 */
- (NSTimeInterval)getTimeIntervalWithDate:(NSDate *)date;

/** 日期转日期字符串*/
- (NSString *)datestrFromDate:(NSDate *)date
withDateFormat:(NSString *)format;

/** 时间戳转日期字符串 */
- (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp withDateFormat:(NSString *)format;

/** 日期字符串转date */
- (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format;

/** 日期字符串转时间戳 */
/**
 *  日期字符串输出标准的Unix时间戳
 *
 *  @param timeTmp   字符串日期 默认 当前时间字符串
 *  @return 标准的Unix时间戳
 */
- (NSTimeInterval)fTime:(NSString *)timeTmp;

/**
 *  输出当前日期时间字符串
 *
 *  @param formater  转化格式 默认 yyyy-MM-dd  HH:mm:ss
 *  @return 标准的日期字符串
 */
- (NSString *)DT:(NSString *)formater;

/**
 *  获取两个时间的间隔
 *
 *  @param part  时间差单位
 *  @param beginTime  开始时间
 *  @param beginTime  结束时间
 *  @return 时间间隔
 */
- (NSString *)DateDiffWithPart:(NSString *)part beginTime:(NSString *)beginTime endTime:(NSString *)endTime;

/**
 *  加上或减去某时间后的时间
 *
 *  @param part  加的时间的单位 年、月、星期、天、时、分、秒
 *  @param changeDate  增加的时间
 *  @param date  本身时间
 *  @return 修改过后的时间
 */
- (NSDate *)DateAddWithPart:(NSString *)part changeTimeInterval:(NSUInteger)changeTimeInterval date:(NSDate *)date;


/**
 *  返回特定格式时间
 <15分钟 显示 刚刚
 是今天的 显示 09:23
 是今年的 显示 9-21
 以前的    显示 2015-09-22
 *
 *  @param dateStr  对应时间
 
 *  @return 修改过后的时间
 */
- (NSString *)getDisplaySpecialDateStrWith:(NSString *)dateStr;

/**
 *  输出中文日期
 *
 *  @param timeTmp  时间字符串
 
 *  @return 中文日期   如2016年9月22日 或者 2016年9月22日 11时20分18秒
 */
- (NSString *)CDate:(NSString *)timeTmp;

/**
 *  输出中文星期
 *
 *  @param timeTmp  时间字符串 支持2015/09/01 或者2015-09-01
 
 *  @return 中文星期   如 日 一 二 三 四 五 六
 */
- (NSString *)CWeek:(NSString *)timeTmp;

/**
 *
 *  将全角数字转换为半角数字
 */
- (NSString *)fNum:(NSString *)numStr;

/**
 *
 *  将数字转为汉字
 */
- (NSString *)Num2Str:(NSString *)numStr;

/**
 *
 *  输入$strLen长度的随机字符
 */
- (NSString *)RndStrWithStrLen:(NSInteger)strLen;

/**
 *
 *  随机生成16位随机数
 */
- (NSString *)getHexRandomToken;

/**
 *
 *  随机生成numLen位随机数
 */
- (NSString *)RanNumWithNumlen:(NSInteger)numLen;

/**
 *
 *  去除回车 换行
 */
- (NSString *)str_qhcWithStr:(NSString *)str;

/**
 *
 *  去除引号
 */
- (NSString *)str_qyhWithStr:(NSString *)str;

/**
 *  去除指定的连续符号 使只存在一个
 *  @param removeStr  指定符号
 */
- (NSString *)str_qlxWithRemmoveStr:(NSString *)removeStr str:(NSString *)str;

/**
 *
 *  去除首尾指定字符
 */
- (NSString *)str_qswWithStr:(NSString *)str removeStr:(NSString *)removeStr;


/**
 *  去掉str中重复的 比如 aaa,bd,bd,g,s 分隔符,
 *  @param partitionStr  分隔符
 */
- (NSString *)str_qcfWithStr:(NSString *)str partitionStr:(NSString *)partitionStr;
/** 判断是否是今天 */
- (BOOL)isToday:(NSDate *)date;
@end
