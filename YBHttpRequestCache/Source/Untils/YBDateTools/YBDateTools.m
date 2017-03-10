//
//  YBDateTools.m
//  YBHttpRequestCache
//
//  Created by yangjw on 16/12/8.
//  Copyright © 2016年 yangjw. All rights reserved.
//

#import "YBDateTools.h"

@implementation YBDateTools

+ (instancetype)shareManager
{
    static YBDateTools *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dateFormatter = [[YBDateTools alloc] init];
    });
    
    return dateFormatter;
}
/** 时间戳转日期字符串 */
- (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [self datestrFromDate:date withDateFormat:format];
}

/** 日期转日期字符串*/
- (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

/** 日期转时间戳 */
- (NSTimeInterval)getTimeIntervalWithDate:(NSDate *)date
{
    return [date timeIntervalSince1970];
}

/** 日期字符串转date */
- (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}


/**
 *  输出标准的Unix时间戳
 *
 *  @param timeTmp   字符串日期 默认 当前时间字符串
 *  @return 标准的Unix时间戳
 */
- (NSTimeInterval)fTime:(NSString *)timeTmp
{
    if (!timeTmp)
    {
        return [[NSDate date] timeIntervalSince1970];
    }else
    {
        NSString *fromater;
        if (!fromater)
        {
            fromater = @"yyyy-MM-dd";
        }
        if (timeTmp.length > 10)
        {
            fromater = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDate *date = [self dateFromString:timeTmp format:fromater];
        return (long)[date timeIntervalSince1970];;
    }
}

/**
 *  输出标准日期时间字符串
 *
 *  @param formater  转化格式 默认 yyyy-MM-dd  HH:mm:ss
 *  @return 标准的Unix时间戳
 */
- (NSString *)DT:(NSString *)formater
{
    if (!formater)
    {
        formater = @"yyyy-MM-dd HH:mm:ss";
    }
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *resultDate = [self dateStrFromCstampTime:time withDateFormat:formater];
    return resultDate;
}


/**
 *  获取两个时间的间隔
 *
 *  @param part  时间差单位
 *  @param beginTime  开始时间
 *  @param beginTime  结束时间
 *  @return 时间间隔
 */
- (NSString *)DateDiffWithPart:(NSString *)part beginTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSString *format = @"yyyy-MM-dd";
    
    if (beginTime.length > 10 )
    {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDate *endDate = [self dateFromString:endTime format:format];
    NSDate *startDate = [self dateFromString:beginTime format:format];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *earliest = [endDate earlierDate:startDate];
    NSDate *latest = (earliest == endDate) ? startDate : endDate;
    NSInteger multiplier = (earliest == endDate) ? -1 : 1;
    NSDateComponents *components = [calendar components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    
    NSArray *arr = @[@"y",@"m",@"w",@"d",@"h",@"n",@"s"];
    NSInteger index = [arr  indexOfObject:part];
    //计算年、月、星期、时、分、秒
    switch (index)
    {
        case 0:
            return [NSString stringWithFormat:@"%ld",multiplier*components.year];
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld",multiplier*(components.month + 12*components.year)];
            break;
        case 2:
            return [NSString stringWithFormat:@"%d",(int)time/(60*60*24*7)];
            break;
        case 3:
            return [NSString stringWithFormat:@"%d",(int)time/(60*60*24)];
            break;
        case 4:
            return [NSString stringWithFormat:@"%d",(int)time/(60*60)];
            break;
        case 5:
            return [NSString stringWithFormat:@"%d",(int)time/(60)];
            break;
        default:
            return [NSString stringWithFormat:@"%d",(int)time];
            break;
    }
    
}

/**
 *  加上或减去某时间后的时间
 *
 *  @param part  加的时间的单位 年、月、星期、天、时、分、秒
 *  @param changeDate  增加的时间
 *  @param date  本身时间
 *  @return 修改过后的时间
 */
- (NSDate *)DateAddWithPart:(NSString *)part changeTimeInterval:(NSUInteger)changeTimeInterval date:(NSDate *)date
{
    // FIXME:排查下 comps 是否需要使用
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    NSArray *arr = @[@"y",@"m",@"w",@"d",@"h",@"n",@"s"];
    NSInteger index = [arr  indexOfObject:part];
    //计算年、月、星期、天、时、分、秒
    switch (index)
    {
        case 0:
            [adcomps setYear:changeTimeInterval];
            break;
        case 1:
            [adcomps setMonth:changeTimeInterval];
            break;
        case 2:
            [adcomps setWeekday:changeTimeInterval];
            break;
        case 3:
            [adcomps setDay:changeTimeInterval];
            break;
        case 4:
            [adcomps setHour:changeTimeInterval];
            break;
        case 5:
            [adcomps setMinute:changeTimeInterval];
            break;
        default:
            [adcomps setSecond:changeTimeInterval];
            break;
    }
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

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
- (NSString *)getDisplaySpecialDateStrWith:(NSString *)dateStr
{
    NSString *result;
    NSString *format = @"yyyy-MM-dd";
    if (dateStr.length > 10 )
    {
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    
    /** 当前时间字符串 */
    NSString *nowDate = [self DT:format];
    
    /** 与分钟间隔 */
    NSString *isJust = [self DateDiffWithPart:@"n" beginTime:dateStr endTime:nowDate];
    NSDate *date = [self dateFromString:dateStr format:format];
    
    if ([isJust integerValue] <= 15)
    {
        result = @"刚刚";
        return result;
        
    }else if ([self isToday:date])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        format = @"HH:mm";
        [dateFormatter setDateFormat:format];
        result = [dateFormatter stringFromDate:date];
        return result;
        
    }else if ([self isThisYear:date])
    {
        result = [dateStr substringToIndex:10];
        result = [result substringFromIndex:5];
        result = [NSString stringWithFormat:@"y%@",result];
        result = [result stringByReplacingOccurrencesOfString:@"y0" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"y" withString:@""];
        return result;
    }else
    {
        if (dateStr.length > 10)
        {
            return [dateStr substringToIndex:10];
        }
        return dateStr;
    }
}

- (BOOL)isThisYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return nowCmps.year == selfCmps.year;
}



/** 判断是否是今天 */
- (BOOL)isToday:(NSDate *)date
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:otherDate];
}

/**
 *  输出中文日期
 *
 *  @param timeTmp  时间字符串
 
 *  @return 中文日期   如2016年9月22日
 */

- (NSString *)CDate:(NSString *)timeTmp
{
    NSString *format = @"yyyy-MM-dd";
    NSString *format2 = @"yyyy年MM月dd日";
    if (timeTmp.length > 10 )
    {
        format = @"yyyy-MM-dd HH:mm:ss";
        format2 = @"yyyy年MM月dd日 HH时mm分ss秒";
    }
    
    NSDate *date = [self dateFromString:timeTmp format:format];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:format2];
    
    NSString *str= [outputFormatter stringFromDate:date];
    
    return str;
}

/**
 *  输出中文星期
 *
 *  @param timeTmp  时间字符串
 
 *  @return 中文星期   如 日 一 二 三 四 五 六
 */
- (NSString *)CWeek:(NSString *)timeTmp
{
    NSString *weekDayStr = nil;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    if (timeTmp.length >= 10)
    {
        NSString *nowString = [timeTmp substringToIndex:10];
        
        NSArray *array;
        if ([nowString containsString:@"-"])
        {
            array = [nowString componentsSeparatedByString:@"-"];
        }else
        {
            array = [nowString componentsSeparatedByString:@"/"];
        }
        
        if (array.count >= 3)
        {
            NSInteger year = [[array objectAtIndex:0] integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [[array objectAtIndex:2] integerValue];
            [comps setYear:year];
            [comps setMonth:month];
            [comps setDay:day];
        }
    }
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger week = [weekdayComponents weekday];
    switch (week)
    {
        case 1:
            weekDayStr = @"日";
            break;
        case 2:
            weekDayStr = @"一";
            break;
        case 3:
            weekDayStr = @"二";
            break;
        case 4:
            weekDayStr = @"三";
            break;
        case 5:
            weekDayStr = @"四";
            break;
        case 6:
            weekDayStr = @"五";
            break;
        case 7:
            weekDayStr = @"六";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
}

/**
 *
 *  将全角数字转换为半角数字
 */
- (NSString *)fNum:(NSString *)numStr
{
    numStr = [numStr stringByReplacingOccurrencesOfString:@"０" withString:@"0"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"１" withString:@"1"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"２" withString:@"2"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"３" withString:@"3"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"４" withString:@"4"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"５" withString:@"5"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"６" withString:@"6"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"７" withString:@"7"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"８" withString:@"8"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"９" withString:@"9"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"－" withString:@"-"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"—" withString:@"-"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"　" withString:@" "];
    return numStr;
}

/**
 *
 *  将数字转为汉字
 */
- (NSString *)Num2Str:(NSString *)numStr
{
    numStr = [numStr stringByReplacingOccurrencesOfString:@"0" withString:@"零"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"1" withString:@"一"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"2" withString:@"二"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"3" withString:@"三"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"4" withString:@"四"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"5" withString:@"五"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"6" withString:@"六"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"7" withString:@"七"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"8" withString:@"八"];
    numStr = [numStr stringByReplacingOccurrencesOfString:@"9" withString:@"九"];
    return numStr;
}

/**
 *
 *  输入$strLen长度的随机字符
 */
- (NSString *)RndStrWithStrLen:(NSInteger)strLen
{
    if (strLen == 0) strLen = arc4random()%10;
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:strLen];
    
    NSArray *array = @[@"0", @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"j",@"k",@"m",@"n",@"p",@"q",@"r",@"s",@"t",@"u",@"w",@"x",@"y",@"z"];
    for (int i = 0; i < strLen; i ++)
    {
        int random = arc4random()%32;
        [resultStr appendString:array[random]];
    }
    return resultStr;
}

/**
 *
 *  随机生成16位随机数
 */
- (NSString *)getHexRandomToken
{
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:16];
    NSArray *array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    for (int i = 0; i< 16; i++)
    {
        int random = arc4random()%16;
        [resultStr appendString:array[random]];
    }
    
    return resultStr;
}

/**
 *
 *  随机生成numLen位随机数
 */
- (NSString *)RanNumWithNumlen:(NSInteger)numLen
{
    if (numLen == 0) numLen = arc4random()%100;
    
    NSMutableString *resultStr = [NSMutableString stringWithCapacity:numLen];
    
    for(int i=0; i< numLen; i++)
    {
        if (i == 0)
        {
            resultStr = [NSMutableString stringWithFormat:@"%i",arc4random()%9 + 1];
        }else
        {
            [resultStr appendString:[NSMutableString stringWithFormat:@"%i",arc4random()%10]];
        }
    }
    return resultStr;
}


/**
 *
 *  去除回车 换行
 */
- (NSString *)str_qhcWithStr:(NSString *)str
{
    str =  [str stringByReplacingOccurrencesOfString: @"\r" withString:@""];
    str =  [str stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    return str;
}

/**
 *
 *  去除引号
 */
- (NSString *)str_qyhWithStr:(NSString *)str
{
    str =  [str stringByReplacingOccurrencesOfString: @"\"" withString:@""];
    return str;
}

/**
 *
 *  去除指定的连续符号 使只存在一个
 */
- (NSString *)str_qlxWithRemmoveStr:(NSString *)removeStr str:(NSString *)str
{
    if (str.length == 0 ) return str;
    NSArray  *startArray = [str componentsSeparatedByString:removeStr];
    
    NSMutableArray *handleArr = [NSMutableArray arrayWithArray:startArray];
    [handleArr removeObject:@""];
    
    NSString *ns=[handleArr componentsJoinedByString:removeStr];
    return ns;
}


/**
 *
 *  去除首尾指定字符
 */
- (NSString *)str_qswWithStr:(NSString *)str  removeStr:(NSString *)removeStr
{
    if (str.length == 0) return @"";
    /** 去除首尾空格 */
    if (removeStr.length == 0) return  [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *firstStr;
    NSString *lastStr;
    /** 首 */
    while (1)
    {
        firstStr = [str  substringToIndex:1];
        if (![firstStr isEqualToString:removeStr]) break;
        str =  [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    
    /** 尾 */
    while (1)
    {
        lastStr = [str  substringFromIndex:str.length - 1];
        if (![lastStr isEqualToString:removeStr]) break;
        str =  [str stringByReplacingCharactersInRange:NSMakeRange(str.length -1, 1) withString:@""];
    }
    return str ;
}

/**
 *
 *  去掉str中重复的数值 partitionStr是分隔符
 */
- (NSString *)str_qcfWithStr:(NSString *)str partitionStr:(NSString *)partitionStr
{
    if (str.length == 0) return str;
    if (partitionStr.length == 0) partitionStr = @",";
    /** 去除连续相同的字符 使之只存在一个 */
    str = [self str_qlxWithRemmoveStr:partitionStr str:str];
    
    NSArray  *startArray = [str componentsSeparatedByString:partitionStr];
    
    NSMutableArray *endArr = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [startArray count]; i++){
        if (![endArr containsObject:[startArray objectAtIndex:i]])
        {
            [endArr addObject:[startArray objectAtIndex:i]];
        }
    }
    
    NSString *ns=[endArr componentsJoinedByString:partitionStr];
    
    ns = [self str_qswWithStr:ns removeStr:partitionStr];
    return ns;
    
}


@end
