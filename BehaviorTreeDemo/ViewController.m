/*
 * objc-behaviortree: http://github.com/andoco/objc-behaviortree
 *
 * Copyright (c) 2012 Andrew O'Connor
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "ViewController.h"

#import "BehaviorTree.h"
#import "Food.h"
#import "Predator.h"
#import "Prey.h"
#import "World.h"

@interface ViewController () {
    NSTimer *timer_;
    World *world_;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    world_ = [[World alloc] init];
            
    timer_ = [NSTimer timerWithTimeInterval:1.0/60 target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer_ forMode:NSRunLoopCommonModes];
    
    NSTimer *foodTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(addFood:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:foodTimer forMode:NSRunLoopCommonModes];
    
    [self addPrey];
    [self addPredator];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(UIView*) viewForActor:(Actor*)actor {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    v.backgroundColor = actor.color;
    return v;
}

-(CGPoint) randPoint {
    float randX = arc4random_uniform((uint)self.view.frame.size.width);
    float randY = arc4random_uniform((uint)self.view.frame.size.height);
    
    return CGPointMake(randX, randY);
}

-(void) addFood:(NSTimer*)timer {
    Food *food = [[Food alloc] init];
    food.view = [self viewForActor:food];
    food.position = [self randPoint];
    food.world = world_;
    [self.view addSubview:food.view];
    
    [world_.food addObject:food];
    
    //NSLog(@"Added food at %@", NSStringFromCGPoint(food.position));
}

-(void) addPrey {
    Prey *prey = [[Prey alloc] init];
    prey.view = [self viewForActor:prey];
    prey.position = [self randPoint];
    prey.world = world_;
    [self.view addSubview:prey.view];
    
    world_.prey = prey;
    
    //NSLog(@"Added prey at %@", NSStringFromCGPoint(prey.position));
}

-(void) addPredator {
    Predator *predator = [[Predator alloc] init];
    predator.view = [self viewForActor:predator];
    predator.position = [self randPoint];
    predator.world = world_;
    [self.view addSubview:predator.view];
    
    world_.predator = predator;
    
    //NSLog(@"Added predator at %@", NSStringFromCGPoint(predator.position));
}

-(void) update:(NSTimer*)timer {
//    NSLog(@"tick");
    
    [world_ update];
    
}

@end
