//
//  NSDictionary+JSONString.m
//  Trafish
//
//  Created by ccxdd on 13-11-23.
//  Copyright (c) 2013年 ccxdd. All rights reserved.
//

#import "NSDictionary+JSONString.h"

@implementation NSDictionary (JSONString)

#pragma mark ------------JSONString---------------

- (NSString *)JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@", jsonString];
    } else {
        DLogError(@"dictionary to JSONString Error! error = %@", error);
        return nil;
    }

}

- (NSData *)JsonUTF8Data
{
    return [[self JSONString] dataUsingEncoding:NSUTF8StringEncoding];
}

- (instancetype)filterWithKeys:(NSArray *)keys non:(BOOL)non
{
    NSMutableDictionary *dict;
    
    if (!non) {
        dict = [NSMutableDictionary dictionary];
        [keys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
            [dict setValue:self[key] forKey:key];
        }];
    } else {
        dict = [NSMutableDictionary dictionaryWithDictionary:self];
        [dict removeObjectsForKeys:keys];
    }
    
    return dict;
}

@end
