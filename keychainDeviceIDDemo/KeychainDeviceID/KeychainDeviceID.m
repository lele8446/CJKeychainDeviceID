//
//  KeychainDeviceID.m
//  KeychainDeviceID
//
//  Created by C.K.Lian on 16/3/11.
//  Copyright © 2016年 C.K.Lian. All rights reserved.
//

#import "KeychainDeviceID.h"
#import <Security/Security.h>
#include "OpenUDID.h"

//在Keychain中的标识，这里取bundleIdentifier + UUID / OpenUDID
#define KEYCHAIN_IDENTIFIER(a)  ([NSString stringWithFormat:@"%@_%@",[[NSBundle mainBundle] bundleIdentifier],a])

#define KCIDisNull(a) (a==nil ||\
                   a==NULL ||\
                   (NSNull *)(a)==[NSNull null] ||\
                   ((NSString *)a).length==0)

@implementation KeychainDeviceID

+ (NSString *)getUUID
{
    //读取keychain缓存
    NSString *deviceID = [self load:KEYCHAIN_IDENTIFIER(@"UUID")];
    //不存在，生成UUID
    if (KCIDisNull(deviceID))
    {
        CFUUIDRef uuid_ref = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuid_string_ref= CFUUIDCreateString(kCFAllocatorDefault, uuid_ref);
        
        CFRelease(uuid_ref);
        deviceID = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
        deviceID = [deviceID lowercaseString];
        if (!KCIDisNull(deviceID))
        {
            [self save:KEYCHAIN_IDENTIFIER(@"UUID") data:deviceID];
        }
        CFRelease(uuid_string_ref);
    }
    if (KCIDisNull(deviceID)) {
        NSLog(@"get deviceID error!");
    }
    return deviceID;
}

+ (NSString *)getOpenUDID
{
    //读取keychain缓存
    NSString *deviceID = [self load:KEYCHAIN_IDENTIFIER(@"OpenUDID")];
    if (KCIDisNull(deviceID))
    {
        //不存在，生成openUDID
        deviceID = [OpenUDID value];
        
        if (!KCIDisNull(deviceID))
        {
            [self save:KEYCHAIN_IDENTIFIER(@"OpenUDID") data:deviceID];
        }
    }
    if (KCIDisNull(deviceID)) {
        NSLog(@"get deviceID error!");
    }
    return deviceID;
}

+ (void)deleteDeviceID
{
    [self delete:KEYCHAIN_IDENTIFIER(@"UUID")];
    [self delete:KEYCHAIN_IDENTIFIER(@"OpenUDID")];
}


#pragma mark - Private Method Keychain相关
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service
{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)(kSecClassGenericPassword),kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
            kSecAttrAccessibleAfterFirstUnlock,kSecAttrAccessible,nil];//第一次解锁后可访问，备份
}

+ (void)save:(NSString *)service data:(id)data
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]
                      forKey:(__bridge id<NSCopying>)(kSecValueData)];
    SecItemAdd((__bridge CFDictionaryRef)(keychainQuery), NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [keychainQuery setObject:(__bridge id)(kSecMatchLimitOne) forKey:(__bridge id<NSCopying>)(kSecMatchLimit)];
    
    CFTypeRef result = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)keychainQuery, &result) == noErr)
    {
        ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)result];
    }
    return ret;
}

+ (void)delete:(NSString *)service
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)(keychainQuery));
}

@end
