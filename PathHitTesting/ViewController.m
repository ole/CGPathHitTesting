//
//  ViewController.m
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "ViewController.h"
#import "DrawingView.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *tapTargets;

@end



@implementation ViewController

@dynamic drawingView;
@synthesize paths;
@synthesize tapTargets;


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
    
    self.paths = [NSMutableArray array];
    self.tapTargets = [NSMutableArray array];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 500, 500)];
    path.lineWidth = 5.0f;
    
    CGPathRef tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(25.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);
    if (tapTargetPath != NULL) {
        UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
        CGPathRelease(tapTargetPath);
        [self.tapTargets addObject:tapTarget];
        [self.paths addObject:path];
    }
    
    self.drawingView.paths = self.paths;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    [self.drawingView addGestureRecognizer:tapRecognizer];
}

- (void)viewDidUnload
{
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


- (DrawingView *)drawingView
{
    return (DrawingView *)self.view;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint tapLocation = [tapRecognizer locationInView:self.drawingView];
    [self.tapTargets enumerateObjectsUsingBlock:^(id tapTarget, NSUInteger idx, BOOL *stop) {
        if ([tapTarget containsPoint:tapLocation]) {
            UIBezierPath *hitShape = [self.paths objectAtIndex:idx];
            NSLog(@"Hit path: %@", hitShape);
            *stop = YES;
        }
    }];
}

@end
