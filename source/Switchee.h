//
//  Switchee.h
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <HIToolbox/CarbonEvents.h>
#import "SwitcheeRegistry.h"
#import "SwitcheeApplication.h"
#import "PTKeyComboPanel.h"
#import "PTKeyCombo.h"
#import "PTHotKey.h"
#import "PTHotKeyCenter.h"

@interface Switchee : NSObject 
{
    IBOutlet SwitcheeRegistry *registry;
    IBOutlet id menuBar;
    IBOutlet id tableView;
    IBOutlet id hotKey;
    IBOutlet id hotkey_string;
    
    PTHotKey *pt_hotkey;
    
    NSArray *applications;
}

- (void)registerApplicationsByNotification:(NSNotification *)note;
- (IBAction)reset:(id)sender;
- (IBAction)setupHotKey:(id)sender;
- (BOOL)openFile:(NSString *)file;
- (void)setupStatusBar;
- (void)setupTableViewCell;
- (void)switchRegistryAt:(int)index;

@end
