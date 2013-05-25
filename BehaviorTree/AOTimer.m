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

#import "AOTimer.h"

NSString* const AOTimerCurrentTimeBlackboardKey = @"timerTask.currentTime";

@implementation AOTimer

- (id)init
{
    self = [super init];
    if (self) {
        self.time = 0;
        self.deltaKey = @"dt";
    }
    return self;
}

-(CGFloat) currentTime:(id)blackboard {
    return [blackboard[AOTimerCurrentTimeBlackboardKey] floatValue];
}

-(BOOL) timeElapsed:(CGFloat)currentTime {
    return currentTime >= self.time;
}

#pragma mark Task methods

-(void) start:(id)blackboard {
    blackboard[AOTimerCurrentTimeBlackboardKey] = [NSNumber numberWithFloat:0];
    [super start:blackboard];
}

#pragma mark Decorator methods

-(BOOL) willStart:(id)blackboard {
    return [self timeElapsed:[self currentTime:blackboard]];
}

-(BOOL) willRun:(id)blackboard {
    return [self timeElapsed:[self currentTime:blackboard]];
}

-(BOOL) willStop:(id)blackboard {
    return [self timeElapsed:[self currentTime:blackboard]];
}

-(AOResult) evaluateResult:(AOResult)result withBlackboard:(id)blackboard andDidRun:(BOOL)didRun {
    CGFloat currentTime = [self currentTime:blackboard];
    
    if ([self timeElapsed:currentTime]) {
        return result;
    }
    
    // time may elapse this update but need to wait for next update before allowing decorated task to be run
    currentTime += [blackboard[self.deltaKey] floatValue];
    blackboard[AOTimerCurrentTimeBlackboardKey] = [NSNumber numberWithFloat:currentTime];
    
    return AOResultPending;
}

@end
