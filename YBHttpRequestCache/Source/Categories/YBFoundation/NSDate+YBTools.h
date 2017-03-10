//
//  NSDate+YBUtilities.h
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/7.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import <Foundation/Foundation.h>

static const unsigned int componentFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

//ps:大写H日期格式将默认为24小时制，小写的h日期格式将默认为12小时制
static NSString *kYBFormatFullDateWithTime          = @"MMM d, yyyy h:mm a";        // 12月 7, 2016 1:52 下午
static NSString *kYBFormatFullDate                  = @"MMM d, yyyy";               // 12月 7, 2016
static NSString *kYBFormatShortDateWithTime         = @"MMM d h:mm a";              // 12月 7 1:53 下午
static NSString *kYBFormatShortDate                 = @"MMM d";                     // 12月 7
static NSString *kYBFormatWeekday                   = @"EEEE";                      // Tuesday
static NSString *kYBFormatWeekdayWithTime           = @"EEEE h:mm a";               // Tuesday 11:30 am
static NSString *kYBFormatTime                      = @"h:mm a";                    // 11:30 am
static NSString *kYBFormatTimeWithPrefix            = @"'at' h:mm a";               // at 11:30 am
static NSString *kYBFormatSQLDate                   = @"yyyy-MM-dd";
static NSString *kYBFormatSQLTime                   = @"HH:mm:ss";
static NSString *kYBFormatSQLDateWithTime           = @"yyyy-MM-dd HH:mm:ss";
static NSString *kYBFormatSQLDateWithTimeChina      = @"yyyy年MM月dd日 hh时mm分ss秒";
/*
 NSDateFormatterStyle:
 NSDateFormatterNoStyle     = kCFDateFormatterNoStyle,
 NSDateFormatterShortStyle  = kCFDateFormatterShortStyle,//“11/23/37” or “3:30pm”
 NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,//\"Nov 23, 1937\"
 NSDateFormatterLongStyle   = kCFDateFormatterLongStyle,//\"November 23, 1937” or “3:30:32pm\"
 NSDateFormatterFullStyle   = kCFDateFormatterFullStyle//“Tuesday, April 12, 1952 AD” or “3:30:42pm PST”
 */

#define YB_MINUTE	60
#define YB_HOUR		3600
#define YB_DAY		86400
#define YB_WEEK		604800
#define YB_YEAR		31556926

@interface NSDate (YBTools)

+ (NSCalendar *)currentCalendar;

// 日期转时间戳
- (NSTimeInterval)timeInterval;
/**
 *  字符串日期转换时间戳
 *
 *  @param timeString 2016-12-12 12:12:12
 *
 *  @return 14343434
 */
+ (NSTimeInterval)timeInterval:(NSString *)timeString;
/**
 *  当前时间 格式化
 *
 *  @param format yyyy-MM-dd HH:mm:ss
 *
 *  @return 2016-12-12 12:12:12
 */
- (NSString*)nowDateWithFormat:(NSString *)format;
#pragma mark - Formatted Dates

#pragma mark Formatted With Style
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style;
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone;
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale;
/**
 *  时间格式化
 *
 *  @param style    样式
 *  @param timeZone 时区
 *  @param locale   系统所有本地化
 *
 *  @return
 */
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

#pragma mark Formatted With Format
- (NSString *)formattedDateWithFormat:(NSString *)format;
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;
- (NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale;
/**
 *  时间格式化
 *
 *  @param format   格式 exp:'YYMMDD hh:mm:ss'
 *  @param timeZone 时区
 *  @param locale   系统所有本地化
 *
 *  @return exp:'20161206 12:00:00'
 */
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
#pragma mark -  timeInterval to String
/**
 *  时间戳格式化
 *
 *  @param format       格式 exp:'YYMMDD hh:mm:ss'
 *  @param timeInterval 时间戳
 *
 *  @return exp:'20161206 12:00:00'
 */
+ (NSString *)formattedDateWithFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval;

#pragma mark -  string to NSDate
/** 日期字符串转date */
+ (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

+ (NSDate *)dateFromString:(NSString *)timeStr style:(NSDateFormatterStyle)style;
+ (NSDate *)dateFromString:(NSString *)timeStr style:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;


#pragma mark -  Comparing dates
/**
 *  当前日期在两个日期之间
 *
 *  @param date      当前日期
 *  @param beginDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return bool
 */
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

/** 当前日期 是否在此 日期内  */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
// 是否今天
- (BOOL)isToday;
// 是否明天
- (BOOL)isTomorrow;
// 是否明年
- (BOOL)isYesterday;
// 是否 闰年
- (BOOL)isInLeapYear;

// 当前日期 是否在指定日期 周内
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
/** 是否是这周  */
- (BOOL)isThisWeek;
// 是否是下周
- (BOOL)isNextWeek;
// 是否是上周
- (BOOL)isLastWeek;

// 当前日期 是否在指定日期 月内
- (BOOL)isSameMonthAsDate:(NSDate *)aDate;
// 是否是这个月
- (BOOL)isThisMonth;
// 是否是下一个月
- (BOOL)isNextMonth;
// 是否是上个月
- (BOOL)isLastMonth;

/** 当前日期 是否在指定日期 年内  */
- (BOOL)isSameYearAsDate:(NSDate *)aDate;
// 是否是今年
- (BOOL)isThisYear;
// 是否是下一年
- (BOOL)isNextYear;
// 是否是上一年
- (BOOL)isLastYear;

// 当前日期 是否在此日期之前
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
// 当前日期 是否在此日期之后
- (BOOL)isLaterThanDate:(NSDate *)aDate;

// 是否是 未来
- (BOOL)isInFuture;
// 是否是过去
- (BOOL)isInPast;

// 是否是工作日
- (BOOL)isTypicallyWorkday;
// 是否是休息日
- (BOOL)isTypicallyWeekend;

// 类方法 明天这个时候的日期
+ (NSDate *)dateTomorrow;
// 类方法 明年这个时候的日期
+ (NSDate *)dateYesterday;
// 类方法 增加 天数
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
// 类方法 减少 天数
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
// 类方法 增加 小时
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
// 类方法 减少 小时
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
// 类方法 增加 分钟
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
// 类方法 减少 分钟
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;

// 增加几年
- (NSDate *)dateByAddingYears:(NSInteger)dYears;
// 减少 几年
- (NSDate *)dateBySubtractingYears:(NSInteger)dYears;
// 增加几个月
- (NSDate *)dateByAddingMonths:(NSInteger)dMonths;
// 减少几个月
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;
// 增加几天
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
// 减少几天
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
// 增加几小时
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
// 减少 几小时
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
// 增加 几分钟
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
// 减少 几分钟
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;

/** 当前时间 开始时间 exp:20161207 00:00:00  */
- (NSDate *)dateAtStartOfDay;
/** 当前时间 结束时间 exp:20161207 23:59:59  */
- (NSDate *)dateAtEndOfDay;

/**
 *  当前时间  在此时间后多少分钟
 *
 *  @param aDate 时间
 *
 *  @return 分钟
 */
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
/**
 *  当前时间  在此时间前多少分钟
 *
 *  @param aDate 时间
 *
 *  @return 分钟
 */
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
/**
 *  当前时间  在此时间多少小时
 *
 *  @param aDate 时间
 *
 *  @return 小时
 */
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
/**
 *  当前时间  在此时间后多少小时
 *
 *  @param aDate 时间
 *
 *  @return 小时
 */
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
/**
 *  当前时间  在此时间后多少天
 *
 *  @param aDate 时间
 *
 *  @return 天
 */
- (NSInteger)daysAfterDate:(NSDate *)aDate;
/**
 *  当前时间  在此时间前多少天
 *
 *  @param aDate 时间
 *
 *  @return 天
 */
- (NSInteger)daysBeforeDate:(NSDate *)aDate;

// 两个时间点的时差 天数
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// 最近的 时间  是几点
@property (readonly)NSInteger nearestHour;
// 当前几点
@property (readonly)NSInteger hour;
// 当前几分
@property (readonly)NSInteger minute;
// 当前几秒
@property (readonly)NSInteger seconds;
// 当前几号
@property (readonly)NSInteger day;
// 当前几月
@property (readonly)NSInteger month;
// 当前年 第几个星期
@property (readonly)NSInteger week;
// 星期几
@property (readonly)NSInteger weekday;
// 当前月 1号是 星期几   1 星期日
@property (readonly)NSInteger nthWeekday;
// 当前年
@property (readonly)NSInteger year;
/** 此月天数  */
@property(readonly)NSInteger daysInMonth;
// 此年 已经进行了天数
@property(readonly)NSInteger dayOfYear;
// 全年天数
@property(readonly)NSInteger daysInYear;

#pragma mark - Time Ago

// 需要的日期 返回一个字符串时间单位  ex:30分钟前 过去有多远
+ (NSString*)timeAgoSinceDate:(NSDate*)date;
// 需要的日期 返回一个字符串时间单位  ex:30分钟 过去有多远
+ (NSString*)shortTimeAgoSinceDate:(NSDate*)date;
// 需要的日期 返回一个字符串时间单位  ex:周三orWed 过去有多远
+ (NSString *)weekTimeAgoSinceDate:(NSDate *)date;

// 返回一个字符串时间单位  ex:30分钟前 过去有多远
- (NSString*)timeAgoSinceNow;
// 返回一个字符串时间单位  ex:30分钟 过去有多远
- (NSString*)shortTimeAgoSinceNow;
// 返回一个字符串时间单位  ex:周三orWed 过去有多远
- (NSString*)weekTimeAgoSinceNow;

// 需要的日期 返回一个字符串时间单位  ex:30分钟前 过去有多远
- (NSString*)timeAgoSinceDate:(NSDate *)date;
// 是否 需要的日期 返回一个字符串时间单位  ex:30分钟前 or 30分钟 过去有多远
- (NSString*)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates;
/**
 *  时间描述   exp:30分钟前
 *
 *  @param date            描述时间
 *  @param useNumericDates 是否显示日期  yes:1年前,1星期前   NO:去年、上周
 *  @param useNumericTimes 是否显示成时间 yes:1分钟前 No:刚刚
 *
 *  @return 30分钟前- 30分钟-去年-1年前
 */
- (NSString*)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates numericTimes:(BOOL)useNumericTimes;

// exp:30分钟 去掉前
- (NSString*)shortTimeAgoSinceDate:(NSDate *)date;
/*
 
 "Mon" = "星期一";
 "Tue" = "星期二";
 "Wed" = "星期三";
 "Thu" = "星期四";
 "Fri" = "星期五";
 "Sat" = "星期六";
 "Sun" = "星期日";
 
 "周一" = "星期一";
 "周二" = "星期二";
 "周三" = "星期三";
 "周四" = "星期四";
 "周五" = "星期五";
 "周六" = "星期六";
 "周日" = "星期日";
 */
- (NSString*)weekTimeAgoSinceDate:(NSDate *)date;

@end
