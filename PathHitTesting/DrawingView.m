//
//  DrawingView.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView

@synthesize paths;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    for (UIBezierPath *path in self.paths) {
        [path stroke];
    }
}

@end
