//
//  IconedCell.m
//  Switchee
//
//  Created by 伊藤 洋也 on 09/01/07.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "IconedCell.h"

@implementation IconedCell

/* Source via                                                                    */
/* http://homepage.mac.com/mkino2/cocoaProg/AppKit/NSCell/NSCell.html#iconedCell */
/*                                                                               */

- (void)drawInteriorWithFrame:(NSRect)cellFrame 
                       inView:(NSView*)controlView
{
#define ICON_SIZE_WIDTH  20
#define ICON_SIZE_HEIGHT 20    
#define MARGIN_X 10
    
    NSString* path;
    NSRect    pathRect;
    
    NSImage*  iconImage;
    NSSize    iconSize;
    NSPoint   iconPoint;
    
    // 画像を描く
    iconImage   = [self image];
    iconSize    = NSZeroSize;
    iconPoint.x = cellFrame.origin.x;
    iconPoint.y = cellFrame.origin.y;
    
    if(iconImage) 
    {
        iconSize.width  = ICON_SIZE_WIDTH;
        iconSize.height = ICON_SIZE_HEIGHT;
        iconPoint.x += MARGIN_X;
        
        if([controlView isFlipped]) {
            iconPoint.y += iconSize.height;
        }
        
        [iconImage setSize:iconSize];
        [iconImage compositeToPoint:iconPoint 
                          operation:NSCompositeSourceOver];
    }
    
    // テキストを描く
    path = [self stringValue];
    pathRect.origin.x = cellFrame.origin.x + MARGIN_X;
    if(iconSize.width > 0) 
    {
        pathRect.origin.x += iconSize.width + MARGIN_X;
    }
    pathRect.origin.y    = cellFrame.origin.y;
    pathRect.size.width  = cellFrame.size.width  - (pathRect.origin.x - cellFrame.origin.x);
    pathRect.size.height = cellFrame.size.height;
    
    if(path) 
    {
        [path drawInRect:pathRect withAttributes:nil];
    }
}

@end
