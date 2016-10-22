# keychainDeviceIDDemo
通过KeyChain获取设备唯一标识符

#### 类中包含三个方法：
```objective-c
/**
 *  获取UUID作为设备唯一标志符
 *
 *  @return
 */
+ (NSString *)getUUID;

/**
 *  获取OpenUDID作为设备唯一标志符
 *
 *  @return
 */
+ (NSString *)getOpenUDID;

/**
 *  从keychain删除DeviceID，一般不会用到
 */
+ (void)deleteDeviceID;
```

调用getUUID和getOpenUDID会从KeyChain中读取对应的标识符，如果是初次读取，则会先生成标识符存入KeyChain再返回。deleteDeviceID是删除标识符，很少情况会使用到。

#### 库的引用：
下载demo，将keychainDeviceID文件夹引用到项目中即可，代码示例：
```objective-c
 #import "keychainDeviceID.h"

 NSString *UUID = [keychainDeviceID getUUID];
 NSString *openUDID = [keychainDeviceID getOpenUDID];
 ```
