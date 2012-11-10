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

#import <UIKit/UIKit.h>

#import "AOTask.h"

@interface AODecorator : AOTask

@property (nonatomic, readonly) id<AOTask> task;

-(id) initWithTask:(id<AOTask>)task;

/** Called when decorator is started to indicate if decorated task should be started */
-(BOOL) willStart:(NSMutableDictionary*)blackboard;

/** Called when decorator is run to indicate if decorated task should be run */
-(BOOL) willRun:(NSMutableDictionary*)blackboard;

/** Called when decorator is stopped to indicate if decorated task should be stopped */
-(BOOL) willStop:(NSMutableDictionary*)blackboard;

/** Evaluates the result from decorated task and returns a new result */
-(AOResult) evaluateResult:(AOResult)result withBlackboard:(NSMutableDictionary*)blackboard;

@end
