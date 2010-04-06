//
//  SwitceeApplication.h
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTHotKeyCenter.h"

@interface SwitcheeApplication : NSApplication 
{
    NSData *_hotkey;
}

@end
