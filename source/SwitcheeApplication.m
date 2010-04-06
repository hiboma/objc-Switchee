//
//  SwitceeApplication.m
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SwitcheeApplication.h"

@implementation SwitcheeApplication

- (void)sendEvent:(NSEvent*)event
{
    [[PTHotKeyCenter sharedCenter] sendEvent: event];
    [super sendEvent: event];
}

@end
