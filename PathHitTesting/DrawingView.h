//
//  DrawingView.h
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawingViewDataSource;

@interface DrawingView : UIView

@property (nonatomic, weak) IBOutlet id <DrawingViewDataSource> dataSource;

- (void)reloadData;
- (void)reloadDataInRect:(CGRect)rect;

@end


@protocol DrawingViewDataSource <NSObject>

@required
- (NSUInteger)numberOfShapesInDrawingView:(DrawingView *)drawingView;
- (UIBezierPath *)drawingView:(DrawingView *)drawingView pathForShapeAtIndex:(NSUInteger)shapeIndex;
- (UIColor *)drawingView:(DrawingView *)drawingView lineColorForShapeAtIndex:(NSUInteger)shapeIndex;

@optional
- (NSUInteger)indexOfSelectedShapeInDrawingView:(DrawingView *)drawingView;

@end