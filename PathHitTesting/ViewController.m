//
//  ViewController.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "ViewController.h"
#import "DrawingView.h"
#import "Shape.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, strong) Shape *selectedShape;

- (void)addShape:(Shape *)newShape;
- (Shape *)hitTest:(CGPoint)point;

@end



@implementation ViewController

@synthesize drawingView = _drawingView;
@synthesize shapes = _shapes;
@synthesize selectedShape = _selectedShape;


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
    
    self.shapes = [NSMutableArray array];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.drawingView addGestureRecognizer:tapRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.drawingView addGestureRecognizer:panRecognizer];
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
    self.drawingView.shapes = self.shapes;
}


#pragma mark - Hit Testing

- (Shape *)hitTest:(CGPoint)point
{
    __block Shape *hitShape = nil;
    [self.shapes enumerateObjectsUsingBlock:^(id shape, NSUInteger idx, BOOL *stop) {
        if ([shape containsPoint:point]) {
            hitShape = [self.shapes objectAtIndex:idx];
            *stop = YES;
        }
    }];
    return hitShape;
}


#pragma mark - Touch handling

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.drawingView];
    self.selectedShape = [self hitTest:tapLocation];
}

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer
{
    switch (panRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint tapLocation = [panRecognizer locationInView:self.drawingView];
            self.selectedShape = [self hitTest:tapLocation];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [panRecognizer translationInView:self.drawingView];
            [self.selectedShape moveBy:translation];
            [self.drawingView setNeedsDisplay];
            [panRecognizer setTranslation:CGPointZero inView:self.drawingView];
        }
        default:
            break;
    }
}

@end