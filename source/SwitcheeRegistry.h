//
//  SwitcheeRegistry.h
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SwitcheeRegistry : NSObject 
{
    NSMutableDictionary *_registry;
}

- (void)add:(NSString *)application;
- (void)remove:(NSString *)application;
- (BOOL)isRegisterd:(NSString *)application;
- (void)clear;
- (NSString *)nextApplication;
- (NSString *)currentApplication;

@end
