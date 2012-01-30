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
@property (nonatomic, strong) NSMutableArray *tapTargets;

- (void)addShape:(Shape *)newShape;

@end



@implementation ViewController

@synthesize drawingView = _drawingView;
@synthesize shapes = _shapes;
@synthesize tapTargets = _tapTargets;


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
    self.tapTargets = [NSMutableArray array];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.drawingView addGestureRecognizer:tapRecognizer];
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
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(newShape.path.CGPath, NULL, fmaxf(25.0f, newShape.path.lineWidth), newShape.path.lineCapStyle, newShape.path.lineJoinStyle, newShape.path.miterLimit);
    if (tapTargetPath != NULL) {
        UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
        CGPathRelease(tapTargetPath);

        [self.shapes addObject:newShape];
        [self.tapTargets addObject:tapTarget];
        self.drawingView.shapes = self.shapes;
    }
    
}


#pragma mark - Touch handling

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.drawingView];
    [self.tapTargets enumerateObjectsUsingBlock:^(id tapTarget, NSUInteger idx, BOOL *stop) {
        if ([tapTarget containsPoint:tapLocation]) {
            Shape *hitShape = [self.shapes objectAtIndex:idx];
            NSLog(@"Hit shape: %@", hitShape);
            *stop = YES;
        }
    }];
}


@end