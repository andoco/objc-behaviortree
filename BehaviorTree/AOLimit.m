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

#import "AOLimit.h"

NSString* const AOLimitCountBlackboardKey = @"limitTask.count";

@implementation AOLimit

-(BOOL) willRun:(id)blackboard {
    id currentCount = blackboard[AOLimitCountBlackboardKey];
    
    if (!currentCount)
        return YES;
    
    return [currentCount intValue] < self.count;
}

-(AOResult) evaluateResult:(AOResult)result withBlackboard:(id)blackboard andDidRun:(BOOL)didRun {
    id currentCountVal = blackboard[AOLimitCountBlackboardKey];
    
    NSInteger currentCount = currentCountVal == nil ? 0 : [currentCountVal intValue];
    
    if (currentCount == self.count) {
        result = AOResultFailure;
    } else {
        currentCount++;
    }
    
    blackboard[AOLimitCountBlackboardKey] = [NSNumber numberWithInt:currentCount];
        
    return result;
}

@end
