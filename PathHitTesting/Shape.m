//
//  Shape.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "Shape.h"

@interface Shape ()

@property (nonatomic, strong) UIBezierPath *tapTarget;

- (UIBezierPath *)tapTargetForPath:(UIBezierPath *)path;

+ (ShapeType)randomShapeType;
+ (CGRect)randomRectInBounds:(CGRect)maxBounds;
+ (UIColor *)randomColor;
+ (CGFloat)randomLineWidth;

@end


@implementation Shape

@synthesize path = _path;
@synthesize lineColor = _lineColor;
@synthesize tapTarget = _tapTarget;


+ (id)randomShapeInBounds:(CGRect)maxBounds
{
    UIBezierPath *path = nil;
    CGRect bounds = [self randomRectInBounds:maxBounds];
    ShapeType type = [self randomShapeType];
    switch (type) {
        case ShapeTypeRect:
            path = [UIBezierPath bezierPathWithRect:bounds];
            break;
        case ShapeTypeEllipse:
            path = [UIBezierPath bezierPathWithOvalInRect:bounds];
            break;
        default:
            path = [UIBezierPath bezierPathWithRect:bounds];
            break;
    }

    path.lineWidth = [self randomLineWidth];
    UIColor *lineColor = [self randomColor];
    
    return [[self alloc] initWithPath:path lineColor:lineColor];
}

+ (id)shapeWithPath:(UIBezierPath *)path lineColor:(UIColor *)lineColor
{
    return [[self alloc] initWithPath:path lineColor:lineColor];
}

- (id)initWithPath:(UIBezierPath *)path lineColor:(UIColor *)lineColor
{
    self = [super init];
    if (self != nil) {
        _path = path;
        _lineColor = lineColor;
        _tapTarget = [self tapTargetForPath:_path];
    }
    return self;
}

- (id)init
{
    UIBezierPath *defaultPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    UIColor *defaultLineColor = [UIColor blackColor];
    return [self initWithPath:defaultPath lineColor:defaultLineColor];
}


#pragma mark - Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Shape: %p - Bounds: %@ - Color: %@>", self, NSStringFromCGRect(self.path.bounds), self.lineColor   ];
}


#pragma mark - Hit Testing

- (UIBezierPath *)tapTargetForPath:(UIBezierPath *)path
{
    if (path == nil) {
        return nil;
    }
    
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(35.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);
    
    if (tapTargetPath == NULL) {
        return nil;
    }
    
    UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
    CGPathRelease(tapTargetPath);
    return tapTarget;
}

- (BOOL)containsPoint:(CGPoint)point
{
    return [self.tapTarget containsPoint:point];
}


#pragma mark - Modifying Shapes

- (void)moveBy:(CGPoint)delta
{
    CGAffineTransform transform = CGAffineTransformMakeTranslation(delta.x, delta.y);
    [self.path applyTransform:transform];
    [self.tapTarget applyTransform:transform];
}



#pragma mark - Random Shape Generator Methods

+ (ShapeType)randomShapeType
{
    return arc4random_uniform(SHAPE_TYPE_COUNT);
}

+ (CGRect)randomRectInBounds:(CGRect)maxBounds
{
    uint32_t minWidth = 44;
    uint32_t minHeight = 44;
    
    CGRect normalizedBounds = CGRectStandardize(maxBounds);
    uint32_t minOriginX = normalizedBounds.origin.x;
    uint32_t minOriginY = normalizedBounds.origin.y;
    uint32_t maxWidth = normalizedBounds.size.width;
    uint32_t maxHeight = normalizedBounds.size.height;
    
    uint32_t originX = arc4random_uniform(maxWidth - minWidth) + minOriginX;
    uint32_t originY = arc4random_uniform(maxHeight - minHeight) + minOriginY;
    uint32_t width = arc4random_uniform(maxWidth - minWidth - originX) + minWidth;
    uint32_t height = arc4random_uniform(maxHeight - minHeight - originY) + minHeight;
    
    return CGRectMake(originX, originY, width, height);
}

+ (UIColor *)randomColor
{
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor blueColor], 
                       [UIColor redColor], 
                       [UIColor greenColor], 
                       [UIColor yellowColor], 
                       [UIColor magentaColor], 
                       [UIColor brownColor], 
                       [UIColor purpleColor], 
                       [UIColor orangeColor], 
                       nil];
    uint32_t colorIndex = arc4random_uniform([colors count]);
    return [colors objectAtIndex:colorIndex];
}

+ (CGFloat)randomLineWidth
{
    uint32_t maxLineWidth = 15;
    CGFloat lineWidth = arc4random_uniform(maxLineWidth) + 1.0f; // avoid lineWidth == 0.0f
    return lineWidth;
}

@end
