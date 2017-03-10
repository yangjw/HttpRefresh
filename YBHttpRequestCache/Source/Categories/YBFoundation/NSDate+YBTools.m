//
//  NSDate+YBUtilities.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/7.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "NSDate+YBTools.h"

//static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
typedef NS_ENUM(NSUInteger, YBDateAgoValues){
    YBYearsAgo,
    YBMonthsAgo,
    YBWeeksAgo,
    YBDaysAgo,
    YBHoursAgo,
    YBMinutesAgo,
    YBSecondsAgo
};

typedef NS_ENUM(NSUInteger, YBDateAgoFormat){
    YBDateAgoLong,
    YBDateAgoLongUsingNumericDatesAndTimes,
    YBDateAgoLongUsingNumericDates,
    YBDateAgoLongUsingNumericTimes,
    YBDateAgoShort,
    YBDateAgoWeek,
};



@implementation NSDate (YBTools)

+ (NSCalendar *)currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

- (NSTimeInterval)timeInterval
{
    return [self timeIntervalSince1970];
}

+ (NSTimeInterval)timeInterval:(NSString *)timeString
{
    if (!timeString)
    {
        return [[NSDate date] timeInterval];
    }
    NSDate *date = [self dateFromString:timeString style:NSDateFormatterNoStyle];
    return [date timeInterval];
}

- (NSString*)nowDateWithFormat:(NSString *)format
{
    return  [[NSDate date] formattedDateWithFormat:format];
}

/**
 *  当前日期在两个日期之间
 *
 *  @param date      当前日期
 *  @param beginDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return bool
 */
- (BOOL)isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([self compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([self compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

#pragma mark - Formatted Dates
#pragma mark Formatted With Style

- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style{
    return [self formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone{
    return [self formattedDateWithStyle:style timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}

- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale{
    return [self formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:locale];
}

- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}
#pragma mark Formatted With Format

- (NSString *)formattedDateWithFormat:(NSString *)format{
    return [self formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone{
    return [self formattedDateWithFormat:format timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}
- (NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale{
    return [self formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:locale];
}

/**
 *  时间格式化
 *
 *  @param format   格式 exp:'YYMMDD hh:mm:ss'
 *  @param timeZone 时区
 *  @param locale   系统所有本地化
 *
 *  @return exp:'20161206 12:00:00'
 */
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

+ (NSString *)formattedDateWithFormat:(NSString *)format timeInterval:(NSTimeInterval)timeInterval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [date formattedDateWithFormat:format];
}

#pragma mark -  string to NSDate

+ (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format
{
    return [self dateFromString:timeStr format:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}

+ (NSDate *)dateFromString:(NSString *)timeStr format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

+ (NSDate *)dateFromString:(NSString *)timeStr style:(NSDateFormatterStyle)style
{
    return [self dateFromString:timeStr style:style timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}

+ (NSDate *)dateFromString:(NSString *)timeStr style:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter dateFromString:timeStr];
}

#pragma mark - Comparing Dates

- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year)&&
            (components1.month == components2.month)&&
            (components1.day == components2.day));
}

- (BOOL)isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL)isYesterday
{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

- (BOOL)isInLeapYear
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:componentFlags fromDate:self];
    
    if (dateComponents.year%400 == 0){
        return YES;
    }
    else if (dateComponents.year%100 == 0){
        return NO;
    }
    else if (dateComponents.year%4 == 0){
        return YES;
    }
    
    return NO;
}

- (BOOL)isSameWeekAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    
    if (components1.weekOfYear != components2.weekOfYear)return NO;
    return (fabs([self timeIntervalSinceDate:aDate])< YB_WEEK);
}

- (BOOL)isThisWeek
{
    return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL)isNextWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YB_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isLastWeek
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - YB_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

- (BOOL)isSameMonthAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month)&&
            (components1.year == components2.year));
}

- (BOOL)isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL)isLastMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

- (BOOL)isNextMonth
{
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

- (BOOL)isSameYearAsDate:(NSDate *)aDate
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

- (BOOL)isThisYear
{
    return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL)isNextYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

- (BOOL)isLastYear
{
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

- (BOOL)isEarlierThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL)isLaterThanDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL)isInFuture
{
    return ([self isLaterThanDate:[NSDate date]]);
}

- (BOOL)isInPast
{
    return ([self isEarlierThanDate:[NSDate date]]);
}
#pragma mark - Roles
- (BOOL)isTypicallyWeekend
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1)||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL)isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark - Adjusting Dates

#pragma mark - Relative Dates

+ (NSDate *)dateWithDaysFromNow:(NSInteger)days
{
    return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *)dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *)dateYesterday
{
    return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YB_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - YB_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YB_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - YB_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}


- (NSDate *)dateByAddingYears:(NSInteger)dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingYears:(NSInteger)dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *)dateByAddingMonths:(NSInteger)dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths
{
    return [self dateByAddingMonths:-dMonths];
}
- (NSDate *)dateByAddingDays:(NSInteger)dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *)dateBySubtractingDays:(NSInteger)dDays
{
    return [self dateByAddingDays:(dDays * -1)];
}

- (NSDate *)dateByAddingHours:(NSInteger)dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YB_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingHours:(NSInteger)dHours
{
    return [self dateByAddingHours:(dHours * -1)];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + YB_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes
{
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - Extremes

- (NSDate *)dateAtStartOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateAtEndOfDay
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; 
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - Retrieving Intervals

- (NSInteger)minutesAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / YB_MINUTE);
}

- (NSInteger)minutesBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / YB_MINUTE);
}

- (NSInteger)hoursAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / YB_HOUR);
}

- (NSInteger)hoursBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / YB_HOUR);
}

- (NSInteger)daysAfterDate:(NSDate *)aDate
{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / YB_DAY);
}

- (NSInteger)daysBeforeDate:(NSDate *)aDate
{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / YB_DAY);
}

- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - Decomposing Dates

- (NSInteger)nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + YB_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSDateComponents *)dateComponents
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components;
}

- (NSInteger)hour
{
    NSDateComponents *components = [self dateComponents];
    return components.hour;
}

- (NSInteger)minute
{
    NSDateComponents *components = [self dateComponents];
    return components.minute;
}

- (NSInteger)seconds
{
    NSDateComponents *components = [self dateComponents];
    return components.second;
}

- (NSInteger)day
{
    NSDateComponents *components = [self dateComponents];
    return components.day;
}

- (NSInteger)month
{
    NSDateComponents *components = [self dateComponents];
    return components.month;
}

- (NSInteger)week
{
    NSDateComponents *components = [self dateComponents];
    return components.weekOfYear;
}

- (NSInteger)weekday
{
    NSDateComponents *components = [self dateComponents];
    return components.weekday;
}

- (NSInteger)nthWeekday
{
    NSDateComponents *components = [self dateComponents];
    return components.weekdayOrdinal;
}

- (NSInteger)year
{
    NSDateComponents *components = [self dateComponents];
    return components.year;
}

- (NSInteger)daysInMonth
{
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:self];
    return days.length;
}

- (NSInteger)dayOfYear
{
    NSCalendar *calendar = [NSDate currentCalendar];
    return [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];;
}

- (NSInteger)daysInYear
{
    if (self.isInLeapYear) {
        return 366;
    }
    return 365;
}


+ (NSString*)timeAgoSinceDate:(NSDate*)date{
    return [date timeAgoSinceDate:[NSDate date]];
}

+ (NSString*)shortTimeAgoSinceDate:(NSDate*)date{
    return [date shortTimeAgoSinceDate:[NSDate date]];
}

+ (NSString*)weekTimeAgoSinceDate:(NSDate*)date{
    return [date weekTimeAgoSinceDate:[NSDate date]];
}


- (NSString*)timeAgoSinceNow{
    return [self timeAgoSinceDate:[NSDate date]];
}

- (NSString *)shortTimeAgoSinceNow{
    return [self shortTimeAgoSinceDate:[NSDate date]];
}

- (NSString *)weekTimeAgoSinceNow{
    return [self weekTimeAgoSinceDate:[NSDate date]];
}

- (NSString *)timeAgoSinceDate:(NSDate *)date{
    return [self timeAgoSinceDate:date numericDates:NO];
}

- (NSString *)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates{
    return [self timeAgoSinceDate:date numericDates:useNumericDates numericTimes:NO];
}

- (NSString *)timeAgoSinceDate:(NSDate *)date numericDates:(BOOL)useNumericDates numericTimes:(BOOL)useNumericTimes{
    if (useNumericDates && useNumericTimes) {
        return [self timeAgoSinceDate:date format:YBDateAgoLongUsingNumericDatesAndTimes];
    } else if (useNumericDates) {
        return [self timeAgoSinceDate:date format:YBDateAgoLongUsingNumericDates];
    } else if (useNumericTimes) {
        return [self timeAgoSinceDate:date format:YBDateAgoLongUsingNumericDates];
    } else {
        return [self timeAgoSinceDate:date format:YBDateAgoLong];
    }
}

- (NSString *)shortTimeAgoSinceDate:(NSDate *)date{
    return [self timeAgoSinceDate:date format:YBDateAgoShort];
}

- (NSString *)weekTimeAgoSinceDate:(NSDate *)date{
    return [self timeAgoSinceDate:date format:YBDateAgoWeek];
}

- (NSString *)timeAgoSinceDate:(NSDate *)date format:(YBDateAgoFormat)format {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    
    NSUInteger upToHours = NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour;
    NSDateComponents *difference = [calendar components:upToHours fromDate:earliest toDate:latest options:0];
    
    if (difference.hour < 24) {
        if (difference.hour >= 1) {
            return [self localizedStringFor:format valueType:YBHoursAgo value:difference.hour];
        } else if (difference.minute >= 1) {
            return [self localizedStringFor:format valueType:YBMinutesAgo value:difference.minute];
        } else {
            return [self localizedStringFor:format valueType:YBSecondsAgo value:difference.second];
        }
        
    } else {
        NSUInteger bigUnits = NSCalendarUnitTimeZone | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear;
        
        NSDateComponents *components = [calendar components:bigUnits fromDate:earliest];
        earliest = [calendar dateFromComponents:components];
        
        components = [calendar components:bigUnits fromDate:latest];
        latest = [calendar dateFromComponents:components];
        
        difference = [calendar components:bigUnits fromDate:earliest toDate:latest options:0];
        
        if (difference.year >= 1) {
            return [self localizedStringFor:format valueType:YBYearsAgo value:difference.year];
        } else if (difference.month >= 1) {
            return [self localizedStringFor:format valueType:YBMonthsAgo value:difference.month];
        } else if (difference.weekOfYear >= 1) {
            return [self localizedStringFor:format valueType:YBWeeksAgo value:difference.weekOfYear];
        } else {
            return [self localizedStringFor:format valueType:YBDaysAgo value:difference.day];
        }
    }
}

- (NSString *)localizedStringFor:(YBDateAgoFormat)format valueType:(YBDateAgoValues)valueType value:(NSInteger)value {
    BOOL isShort = format == YBDateAgoShort;
    BOOL isNumericDate = format == YBDateAgoLongUsingNumericDates || format == YBDateAgoLongUsingNumericDatesAndTimes;
    BOOL isNumericTime = format == YBDateAgoLongUsingNumericTimes || format == YBDateAgoLongUsingNumericDatesAndTimes;
    BOOL isWeek =  format == YBDateAgoWeek;
    
    switch (valueType) {
        case YBYearsAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@年" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@年前" withValue:value];
            } else if (isNumericDate) {
                return @"1年前";
            } else {
                return @"去年";
            }
        case YBMonthsAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@月" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@月前" withValue:value];
            } else if (isNumericDate) {
                return @"1个月前";
            } else {
                return @"上个月";
            }
        case YBWeeksAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@星期" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@星期前" withValue:value];
            } else if (isNumericDate) {
                return @"1星期前";
            } else {
                return @"上星期";
            }
        case YBDaysAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@天" withValue:value];
            } else if (value >= 2) {
                if (isWeek && value <= 7) {
                    NSDateFormatter *dayDateFormatter = [[NSDateFormatter alloc]init];
                    dayDateFormatter.dateFormat = @"EEE";
                    NSString *eee = [dayDateFormatter stringFromDate:self];
                    return eee;
                }
                return [self logicLocalizedStringFromFormat:@"%%d%@天前" withValue:value];
            } else if (isNumericDate) {
                return @"1天前";
            } else {
                return @"昨天";
            }
        case YBHoursAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@小时" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@小时前" withValue:value];
            } else if (isNumericTime) {
                return @"1小时前";
            } else {
                return @"1小时前";
            }
        case YBMinutesAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@分钟" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@分钟前" withValue:value];
            } else if (isNumericTime) {
                return @"1分钟前";
            } else {
                return @"1分钟前";
            }
        case YBSecondsAgo:
            if (isShort) {
                return [self logicLocalizedStringFromFormat:@"%%d%@秒" withValue:value];
            } else if (value >= 2) {
                return [self logicLocalizedStringFromFormat:@"%%d%@分钟前" withValue:value];
            } else if (isNumericTime) {
                return @"1分钟前";
            } else {
                return @"刚刚";
            }
    }
    return nil;
}

- (NSString *) logicLocalizedStringFromFormat:(NSString *)format withValue:(NSInteger)value{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:localeFormat, value];
}

- (NSString *)getLocaleFormatUnderscoresWithValue:(double)value{
    NSString *localeCode = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
    if([localeCode isEqualToString:@"ru-RU"] || [localeCode isEqualToString:@"uk"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) {
            return @"";
        }
        
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  {
            return @"_";
        }
        
        if(Y == 1 && XY != 11) {
            return @"__";
        }
    }
    return @"";
}

@end
