//
//  SwitcheeTableView.m
//  Switchee
//
//  Created by 伊藤 洋也 on 09/09/03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SwitcheeTableView.h"


@implementation SwitcheeTableView

// http://jongampark.wordpress.com/2009/03/26/clickedrow-for-nstableview/
// rowAtPointでクリックされた列を取得できる

- (void)mouseDown:(NSEvent*)theEvent
{
    NSPoint event_location = [theEvent locationInWindow];  
    NSPoint local_point    = [self convertPoint:event_location toView:nil];  
	int index          = [self rowAtPoint:local_point];  	
	Switchee *switchee = [self delegate];

	[switchee switchRegistryAt:index];
	[self reloadData];
	[super mouseDown:theEvent];
}

@end
