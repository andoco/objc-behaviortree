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

#import "Prey.h"

#import "AOBehaviorTree.h"
#import "EatFood.h"
#import "Flee.h"
#import "Seek.h"
#import "PredatorDetected.h"
#import "TargetFood.h"

@implementation Prey

- (id)init
{
    self = [super init];
    if (self) {
        self.color = [UIColor blueColor];
        self.speed = 3;
        
        id fleeSeq = [[AOSequence alloc] init];
        [fleeSeq addChild:[[PredatorDetected alloc] initWithActor:self]];
        [fleeSeq addChild:[[Flee alloc] initWithActor:self]];
        
        id gatherSeq = [[AOSequence alloc] init];
        [gatherSeq addChild:[[TargetFood alloc] initWithActor:self]];
        [gatherSeq addChild:[[Seek alloc] initWithActor:self]];
        [gatherSeq addChild:[[EatFood alloc] initWithActor:self]];
        
        id selector = [[AOSelector alloc] init];
        [selector addChild:fleeSeq];
        [selector addChild:gatherSeq];
        
        self.behavior = [[AOBehaviorTree alloc] initWithRootTask:selector];
    }
    return self;
}

@end
