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

#import "Kiwi.h"

#import "AOHasValue.h"
#import "AOTask.h"
#import "TestEntity.h"

SPEC_BEGIN(HasValueSpec)

describe(@"HasValue", ^{

    context(@"When run", ^{
        
        __block AOHasValue *task;
        __block id subtask;
        __block NSMutableDictionary *blackboard;

        beforeEach(^{
            subtask = [KWMock nullMockForProtocol:@protocol(AOTask)];
            task = [[AOHasValue alloc] initWithTask:subtask];
            blackboard = [NSMutableDictionary dictionary];
        });

        context(@"and configured property value matches blackboard value", ^{
            
            context(@"for NSString", ^{
                it(@"should run subtask", ^{
                    task.key = @"testString";
                    task.value = @"testStringVal";
                    [blackboard setObject:@"testStringVal" forKey:@"testString"];
                    
                    [[subtask should] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });

            context(@"for NSNumber", ^{
                it(@"should run subtask", ^{
                    task.key = @"testNumber";
                    task.value = [NSNumber numberWithInt:5];
                    [blackboard setObject:[NSNumber numberWithInt:5] forKey:@"testNumber"];
                    
                    [[subtask should] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });

            context(@"for Class", ^{
                it(@"should run subtask", ^{
                    task.key = @"testClass";
                    task.value = [TestEntity class];
                    [blackboard setObject:[TestEntity class] forKey:@"testClass"];
                    
                    [[subtask should] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });
            
            context(@"for object instance", ^{
                it(@"should run subtask", ^{
                    TestEntity *obj = [[TestEntity alloc] init];
                    
                    task.key = @"testObj";
                    task.value = obj;
                    [blackboard setObject:obj forKey:@"testObj"];
                    
                    [[subtask should] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });                
            });

        });

        context(@"and configured property value does not match blackboard value", ^{

            context(@"for NSString", ^{
                it(@"should run subtask", ^{
                    task.key = @"testString";
                    task.value = @"testStringVal";
                    [blackboard setObject:@"not testStringVal" forKey:@"testString"];
                    
                    [[subtask shouldNot] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });
            
            context(@"for NSNumber", ^{
                it(@"should run subtask", ^{
                    task.key = @"testNumber";
                    task.value = [NSNumber numberWithInt:5];
                    [blackboard setObject:[NSNumber numberWithInt:6] forKey:@"testNumber"];
                    
                    [[subtask shouldNot] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });
            
            context(@"for Class", ^{
                it(@"should run subtask", ^{
                    task.key = @"testClass";
                    task.value = [TestEntity class];
                    [blackboard setObject:[NSString class] forKey:@"testClass"];
                    
                    [[subtask shouldNot] receive:@selector(run:)];
                    
                    [task run:blackboard];
                });
            });
 
        });
        
        context(@"and configured key is keyPath", ^{

            it(@"should run subtask", ^{
                NSDictionary *d1 = [NSDictionary dictionaryWithObject:@"testStringVal" forKey:@"testString"];
                [blackboard setObject:d1 forKey:@"test"];
                
                task.key = @"test.testString";
                task.value = @"testStringVal";
                
                [[subtask should] receive:@selector(run:)];
                
                [task run:blackboard];
            });

        });
        
        context(@"and configured value not present in blackboard", ^{
            it(@"should not run subtask", ^{
                task.key = @"testNumber";
                task.value = [NSNumber numberWithInt:1];
                
                [[subtask shouldNot] receive:@selector(run:)];
                
                [task run:blackboard];
            });
        });

        context(@"and configured value type does not match actual value type", ^{
            it(@"should not run subtask", ^{
                task.key = @"testString";
                task.value = @"testStringVal";
                [blackboard setObject:[NSNumber numberWithInt:1] forKey:@"testString"];
                
                [[subtask shouldNot] receive:@selector(run:)];
                
                [task run:blackboard];
            });
        });
        
        context(@"for object instance", ^{
            it(@"should run subtask", ^{
                TestEntity *obj1 = [[TestEntity alloc] init];
                TestEntity *obj2 = [[TestEntity alloc] init];
                
                task.key = @"testObj";
                task.value = obj1;
                [blackboard setObject:obj2 forKey:@"testObj"];
                
                [[subtask shouldNot] receive:@selector(run:)];
                
                [task run:blackboard];
            });
        });
        
    });
    
});

SPEC_END