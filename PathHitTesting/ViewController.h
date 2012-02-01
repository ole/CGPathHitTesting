//
//  ViewController.h
//  PathHitTesting
//
//  Created by Ole Begemann on 30.01.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"

@interface ViewController : UIViewController <DrawingViewDataSource>

@property (weak, nonatomic) IBOutlet DrawingView *drawingView;

- (IBAction)addButtonTapped:(id)sender;

@end
