//
//  ViewController.m
//  keychainDeviceID
//
//  Created by C.K.Lian on 16/3/11.
//  Copyright © 2016年 C.K.Lian. All rights reserved.
//

#import "ViewController.h"

#import "keychainDeviceID.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *UUID = [keychainDeviceID getUUID];
    NSLog(@"uuid = %@",UUID);
    
    NSString *openUDID = [keychainDeviceID getOpenUDID];
    NSLog(@"openUdid = %@",openUDID);
    self.uuidLable.text = [NSString stringWithFormat:@"UUID\n%@",UUID];
    self.openUdidLable.text = [NSString stringWithFormat:@"openUDID\n%@",openUDID];;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
