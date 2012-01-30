//
//  Shape.h
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ShapeTypeRect = 1,
    ShapeTypeEllipse,
    SHAPE_TYPE_COUNT
} ShapeType;


@interface Shape : NSObject

+ (id)randomShapeInBounds:(CGRect)maxBounds;
+ (id)shapeWithPath:(UIBezierPath *)path lineColor:(UIColor *)lineColor;
- (id)initWithPath:(UIBezierPath *)path lineColor:(UIColor *)lineColor;

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor *lineColor;

@end
