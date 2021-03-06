//
//  Switchee.m
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Switchee.h"


static NSString * SwitcheeDistributedNotification = @"SwitcheeDistributedNotification";

/* controller */
@implementation Switchee

- (id) init
{
    self = [super init];
    if (self != nil) 
    {
        id center;
        /* for Quicksilver Plugin */
        center = [NSDistributedNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(registerApplicationsByNotification:) 
                       name:SwitcheeDistributedNotification
                     object:nil];

        /* NSWorkspace であることに注意 */
        center = [[NSWorkspace sharedWorkspace] notificationCenter];
        [center addObserver:self
                   selector:@selector(receiveNSWorkspaceDidTerminateApplicationNotification:)
                       name:NSWorkspaceDidTerminateApplicationNotification
                     object:nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    applications = [[[NSWorkspace sharedWorkspace] launchedApplications] retain];
    [self setupTableViewCell];
    [self setupStatusBar];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    id keyComboPlist;
    PTKeyCombo *keyCombo;
    
    //Read our keycombo in from preferences
    keyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey: @"testKeyCombo"];
    keyCombo      = [[[PTKeyCombo alloc] initWithPlistRepresentation: keyComboPlist] autorelease];
    
    pt_hotkey = [[PTHotKey alloc] initWithIdentifier: @"testHotKey" keyCombo: keyCombo ];
    [pt_hotkey setName:@"Switchee"]; //This is typically used by PTKeyComboPanel
    [pt_hotkey setTarget:self];
    [pt_hotkey setAction:@selector(switchApplication)];
    
    [[PTHotKeyCenter sharedCenter] registerHotKey: pt_hotkey];
    [hotkey_string setStringValue:[keyCombo description]];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    //Save our keycombo to preferences
    [[NSUserDefaults standardUserDefaults] setObject: [[pt_hotkey keyCombo] plistRepresentation] forKey: @"testKeyCombo"];
    
    //Unregister our hot key (not required)
    [[PTHotKeyCenter sharedCenter] unregisterHotKey: pt_hotkey];
    
    //Memory cleanup
    [pt_hotkey release];
    pt_hotkey = nil;
}


- (void) dealloc
{
    [registry release];
    [super dealloc];
}

- (void)setupStatusBar
{
    NSStatusBar *bar   = [NSStatusBar systemStatusBar];
    NSStatusItem *item = [bar statusItemWithLength:NSVariableStatusItemLength];
    NSImage *icon      = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://d.hatena.ne.jp/images/diary/h/hiboma/favicon.ico"]];
    [item retain];	
    [item setTitle:@""];
    [item setToolTip:@"Switchee"];
    [item setHighlightMode:YES];
    [item setImage:icon];
    [item setMenu:menuBar];
}

- (void)setupTableViewCell
{
    /* for flag cell */
    NSButtonCell  *flag_cell   = [[NSButtonCell alloc] init];
    [flag_cell setButtonType:NSSwitchButton];
    [flag_cell setTitle:@""];
    [[tableView tableColumnWithIdentifier:@"flag"] setDataCell:flag_cell];
    [flag_cell release];
    
    /* for icon cell */
    NSButtonCell  *iconed_cell   = [[NSButtonCell alloc] init];
    [iconed_cell setButtonType:NSSwitchButton];
    [iconed_cell setTitle:@""];
    [[tableView tableColumnWithIdentifier:@"icon"] setDataCell:iconed_cell];    
    [iconed_cell release];
}

/* for notification */
- (void)registerApplicationsByNotification:(NSNotification *)note
{
    NSDictionary *info    = [note userInfo];
    NSArray *candidates   = [info allValues];
    
    [registry clear];
    
    int i, count = [candidates count];
    for (i = 0; i < count; i++) {
        NSString *application = [candidates objectAtIndex:i];
        [registry add:application];
    }
    
    [tableView reloadData];
}

/* for notification */
- (void)receiveNSWorkspaceDidTerminateApplicationNotification:(NSNotification *)note
{
    NSString *applicationPath = [[note userInfo] valueForKey:@"NSApplicationPath"];
    [registry remove:applicationPath];
    /* Todo: Viewの位置を見て処理 */
    [tableView reloadData];
}

- (BOOL)openFile:(NSString *)file
{
    return [[NSWorkspace sharedWorkspace] openFile:file];
}

- (IBAction)reset:(id)sender
{
    [registry clear];
    [tableView reloadData];
}

- (IBAction)setupHotKey:(id)sender
{
    PTKeyComboPanel* panel = [PTKeyComboPanel sharedPanel];
    [panel setKeyCombo:[pt_hotkey keyCombo]];
    [panel setKeyBindingName:[pt_hotkey name]];
    [panel runSheeetForModalWindow:[tableView window] target: self];
    
    [[PTHotKeyCenter sharedCenter] registerHotKey:pt_hotkey];
}

- (void)hotKeySheetDidEndWithReturnCode: (NSNumber*)resultCode
{
    if( [resultCode intValue] == NSOKButton )
    {   
        //Update our hotkey with the new keycombo
        [pt_hotkey setKeyCombo: [[PTKeyComboPanel sharedPanel] keyCombo]];
        
        //Re-register it (required)
        [[PTHotKeyCenter sharedCenter] registerHotKey: pt_hotkey];
        
        [hotkey_string setStringValue: [[[PTKeyComboPanel sharedPanel] keyCombo] description]];
    }   
}


- (void)switchApplication
{
    NSString * nextApp = [registry nextApplication];   
    if(nextApp){
        [self openFile:nextApp];
    }
}


/* NSTableView  Datasource */
- (int)numberOfRowsInTableView:(NSTableView *)view
{
    return [applications count];
}

- (void)tableView:(NSTableView *)view setObjectValue:(id)object forTableColumn:(NSTableColumn *)column row:(int)index
{
    if(![[column identifier] isEqualToString:@"flag"]) return;
	
	[self switchRegistryAt:index];
	[view reloadData];
}

- (void)switchRegistryAt:(int)index
{
	NSString *application = [[applications objectAtIndex:index] valueForKey:@"NSApplicationPath"];
    if([registry isRegisterd:application])
    {
        [registry remove:application];
    }
    else
    {
        [registry add:application];
    }
}

/* NSTableView  Datasource */
/* http://homepage.mac.com/mkino2/cocoaProg/AppKit/NSTableView/NSTableView.html */
- (id)tableView:(NSTableView *)view objectValueForTableColumn:(NSTableColumn *)column row:(int)index
{
    NSString *identifier  = [column identifier];
    if([identifier isEqualToString:@"flag"]) 
    {
        NSString *application_path = [[applications objectAtIndex:index] valueForKey:@"NSApplicationPath"];
        if([registry isRegisterd:application_path])
        {
            return [NSNumber numberWithInt:NSOnState];
        }
        else
        {
            return [NSNumber numberWithInt:NSOffState];            
        }
    }
    else if([identifier isEqualToString:@"icon"])
    {
        NSDictionary *application = [applications objectAtIndex:index];        
        NSCell   *cell            = [column dataCell];
        NSString *name            = [application valueForKey:@"NSApplicationName"];
        NSString *path            = [application valueForKey:@"NSApplicationPath"];        
        NSImage  *icon            = [[NSWorkspace sharedWorkspace] iconForFile:path];
        NSSize   icon_size;

        [cell setTitle:name];        
        icon_size.width  = 20;
        icon_size.height = 20;
        [icon setSize:icon_size];
        [cell setImage:icon];
    }
    else if([identifier isEqualToString:@"name"])
    {
        return [[applications objectAtIndex:index] valueForKey:@"NSApplicationName"];
    }
    
    return nil;
}


@end
