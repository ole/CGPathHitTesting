//
//  DrawingView.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "DrawingView.h"
#import "Shape.h"


@implementation DrawingView

@synthesize shapes = _shapes;

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
    for (Shape *shape in self.shapes) {
        [shape.lineColor setStroke];
        [shape.path stroke];
    }
}

- (void)setShapes:(NSArray *)shapes
{
    _shapes = shapes;
    [self setNeedsDisplay];
}

@end
