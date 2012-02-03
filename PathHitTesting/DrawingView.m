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

@synthesize dataSource = _dataSource;

- (void)reloadData
{
    [self setNeedsDisplay];
}

- (void)reloadDataInRect:(CGRect)rect
{
    [self setNeedsDisplayInRect:rect];
}

- (void)drawRect:(CGRect)rect
{
    NSUInteger numberOfShapes = [self.dataSource numberOfShapesInDrawingView:self];
    NSUInteger indexOfSelectedShape = NSNotFound;
    if ([self.dataSource respondsToSelector:@selector(indexOfSelectedShapeInDrawingView:)]) {
        indexOfSelectedShape = [self.dataSource indexOfSelectedShapeInDrawingView:self];
    }
    
    for (NSUInteger shapeIndex = 0; shapeIndex < numberOfShapes; shapeIndex++) 
    {
        UIBezierPath *path = [self.dataSource drawingView:self pathForShapeAtIndex:shapeIndex];
        if (CGRectIntersectsRect(rect, CGRectInset(path.bounds, -(path.lineWidth + 1.0f), -(path.lineWidth + 1.0f)))) 
        {
            UIColor *lineColor = [self.dataSource drawingView:self lineColorForShapeAtIndex:shapeIndex];
            [lineColor setStroke];
            [path stroke];

            if (shapeIndex == indexOfSelectedShape) {
                UIBezierPath *pathCopy = [path copy];
                CGPathRef cgPathSelectionRect = CGPathCreateCopyByStrokingPath(pathCopy.CGPath, NULL, pathCopy.lineWidth, pathCopy.lineCapStyle, pathCopy.lineJoinStyle, pathCopy.miterLimit);
                UIBezierPath *selectionRect = [UIBezierPath bezierPathWithCGPath:cgPathSelectionRect];
                CGPathRelease(cgPathSelectionRect);

                CGFloat dashStyle[] = { 5.0f, 5.0f };
                [selectionRect setLineDash:dashStyle count:2 phase:0];
                [[UIColor blackColor] setStroke];
                [selectionRect stroke];
            }
        }
    }
}

@end
