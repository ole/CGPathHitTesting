//
//  ViewController.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "ViewController.h"
#import "Shape.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, assign) NSUInteger selectedShapeIndex;
@property (nonatomic, readonly) Shape *selectedShape;

- (void)addShape:(Shape *)newShape;
- (NSUInteger)hitTest:(CGPoint)point;

@end



@implementation ViewController

@synthesize drawingView = _drawingView;
@synthesize shapes = _shapes;
@synthesize selectedShapeIndex = _selectedShapeIndex;
@dynamic selectedShape;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _selectedShapeIndex = NSNotFound;
    self.shapes = [NSMutableArray array];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.drawingView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.drawingView addGestureRecognizer:panRecognizer];
    
    [self.drawingView reloadData];
}

- (void)viewDidUnload
{
    [self setDrawingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}


#pragma mark - Shape management

- (IBAction)addButtonTapped:(id)sender 
{
    CGRect maxBounds = CGRectInset(self.drawingView.bounds, 10.0f, 10.0f);
    Shape *newShape = [Shape randomShapeInBounds:maxBounds];
    [self addShape:newShape];
}

- (void)addShape:(Shape *)newShape
{
    [self.shapes addObject:newShape];
    [self.drawingView reloadDataInRect:newShape.totalBounds];
}

- (void)setSelectedShapeIndex:(NSUInteger)selectedShapeIndex
{
    CGRect oldSelectionBounds = self.selectedShape.totalBounds;
    _selectedShapeIndex = selectedShapeIndex;
    CGRect newSelectionBounds = self.selectedShape.totalBounds;
    CGRect rectToRedraw = CGRectUnion(oldSelectionBounds, newSelectionBounds);
    [_drawingView setNeedsDisplayInRect:rectToRedraw];
}

- (Shape *)selectedShape
{
    if (_selectedShapeIndex == NSNotFound) {
        return nil;
    }
    return [self.shapes objectAtIndex:_selectedShapeIndex];
}


#pragma mark - Hit Testing

- (NSUInteger)hitTest:(CGPoint)point
{
    __block NSUInteger hitShapeIndex = NSNotFound;
    [self.shapes enumerateObjectsUsingBlock:^(id shape, NSUInteger idx, BOOL *stop) {
        if ([shape containsPoint:point]) {
            hitShapeIndex = idx;
            *stop = YES;
        }
    }];
    return hitShapeIndex;
}


#pragma mark - Touch handling

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.drawingView];
    self.selectedShapeIndex = [self hitTest:tapLocation];
}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint tapLocation = [panRecognizer locationInView:self.drawingView];
            self.selectedShapeIndex = [self hitTest:tapLocation];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panRecognizer translationInView:self.drawingView];
            CGRect originalBounds = self.selectedShape.totalBounds;
            CGRect newBounds = CGRectApplyAffineTransform(originalBounds, CGAffineTransformMakeTranslation(translation.x, translation.y));
            CGRect rectToRedraw = CGRectUnion(originalBounds, newBounds);

            [self.selectedShape moveBy:translation];
            [self.drawingView reloadDataInRect:rectToRedraw];
            [panRecognizer setTranslation:CGPointZero inView:self.drawingView];
        }
        default:
            break;
    }
}


#pragma mark - DrawingViewDataSource

- (NSUInteger)numberOfShapesInDrawingView:(DrawingView *)drawingView
{
    return [self.shapes count];
}

- (UIBezierPath *)drawingView:(DrawingView *)drawingView pathForShapeAtIndex:(NSUInteger)shapeIndex
{
    Shape *shape = [self.shapes objectAtIndex:shapeIndex];
    return shape.path;
}

- (UIColor *)drawingView:(DrawingView *)drawingView lineColorForShapeAtIndex:(NSUInteger)shapeIndex
{
    Shape *shape = [self.shapes objectAtIndex:shapeIndex];
    return shape.lineColor;
}

- (NSUInteger)indexOfSelectedShapeInDrawingView:(DrawingView *)drawingView
{
    return self.selectedShapeIndex;
}

@end