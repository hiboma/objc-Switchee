//
//  SwitcheeRegistry.m
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SwitcheeRegistry.h"

/* as Model */
@implementation SwitcheeRegistry

- (id) init
{
    self = [super init];
    if (self != nil) {
        _registry = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)add:(NSString *)application
{
    [_registry setValue:application forKey:application];
}

- (void)remove:(NSString *)application
{
    [_registry removeObjectForKey:application];
}

- (BOOL)isRegisterd:(NSString *)application
{
    return [_registry valueForKey:application] ? YES : NO ;
}

- (void)clear
{
    if(_registry){
        [_registry release];
        _registry = nil;
    }
    _registry = [[NSMutableDictionary alloc] init];
}

- (NSString *)nextApplication
{
    NSString *curent_app_path = [self currentApplication];
    NSArray *apps             = [_registry allValues];
    int count                 = [_registry count];
    
    if(count == 0) return nil;
    
    for(int i = 0; i < count; i++){
        NSString *candidate = [apps objectAtIndex:i];
        
        if(![candidate isEqualTo:curent_app_path])
            continue;
        
        if(++i >= count)
            i = 0;
        
        return [apps objectAtIndex:i];
    }
    
    return [apps objectAtIndex:0];    
}

- (NSString *)currentApplication
{
    return [[[NSWorkspace sharedWorkspace] activeApplication] valueForKey:@"NSApplicationPath"];
}


@end
