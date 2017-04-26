//
//  NSTransView.m
//  ITSpider
//
//  Created by zoolsher on 2017/4/26.
//  Copyright © 2017年 zoolsher. All rights reserved.
//

#import "NSTransView.h"

@implementation NSTransView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRect:dirtyRect];
    
    NSGradient *g=[[NSGradient alloc] initWithStartingColor:[NSColor colorWithRed:0.98 green:0.82 blue:0.54 alpha:1.00] endingColor:[NSColor colorWithRed:0.17 green:0.32 blue:0.50 alpha:1.00]];
    [g drawFromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, self.frame.size.height) options:2];
//    [g drawInRect:dirtyRect relativeCenterPosition:NSMakePoint(0, 0)];
    // Drawing code here.
}

@end
