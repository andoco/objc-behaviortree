#import "Kiwi.h"
#import "Task.h"
#import "CompositeTask.h"

SPEC_BEGIN(CompositeTaskSpec)

describe(@"CompositeTask", ^{
    __block CompositeTask *task;
    
    beforeEach(^{
        task = [[CompositeTask alloc] init];
    });

    context(@"when initialized", ^{
        it(@"children should be empty", ^{
            [task.children shouldNotBeNil];
            [[theValue(task.children.count) should] equal:theValue(0)];
        });
    });
    
    context(@"when child added", ^{
        it(@"should be added to children", ^{
            id action1 = [KWMock nullMockForProtocol:@protocol(Task)];
            id action2 = [KWMock nullMockForProtocol:@protocol(Task)];
            
            [task addChild:action1];
            [task addChild:action2];
            
            [[theValue(task.children.count) should] equal:theValue(2)];
            [[[task.children objectAtIndex:0] should] equal:action1];
            [[[task.children objectAtIndex:1] should] equal:action2];
        });
    });
    
    context(@"when initialized with children", ^{
        
        it(@"arguments should be added to children", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            
            task = [[CompositeTask alloc] initWithChildren:task1, task2, nil];

            [[theValue(task.children.count) should] equal:theValue(2)];
        });
    });
    
    context(@"when run", ^{
        __block NSMutableDictionary *blackboard;
        
        beforeEach(^{
            blackboard = [NSMutableDictionary dictionary];
        });
        
        it(@"should start all child tasks with status Ready", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Ready)] status];
            [[task1 should] receive:@selector(start:)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 stubAndReturn:theValue(Running)] status];
            [[task2 shouldNot] receive:@selector(start)];
            
            [task addChild:task1];
            [task addChild:task2];
            
            [task run:blackboard];
        });
        
        it(@"should stop child task that returns Success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Ready)] status];
            [[task1 stubAndReturn:theValue(Success)] run:blackboard];
            [[task1 should] receive:@selector(stop:)];
            
            [task addChild:task1];
            
            [task run:blackboard];
        });
        
        it(@"should stop child task that returns Failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Ready)] status];
            [[task1 stubAndReturn:theValue(Failure)] run:blackboard];
            [[task1 should] receive:@selector(stop:)];
            
            [task addChild:task1];
            
            [task run:blackboard];
        });

        it(@"should not stop child task that returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Ready)] status];
            [[task1 stubAndReturn:theValue(Pending)] run:blackboard];
            [[task1 shouldNot] receive:@selector(stop)];
            
            [task addChild:task1];
            
            [task run:blackboard];            
        });
        
        context(@"child task returns Success", ^{
            it(@"should change task status to Ready", ^{
                id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
                [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                
                [task addChild:task1];
                
                [task run:blackboard];
            });
        });

        context(@"child task returns Failure", ^{
            it(@"should change task status to Ready", ^{
                id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
                [[task1 should] receive:@selector(run:) andReturn:theValue(Failure)];
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(Ready)];
                
                [task addChild:task1];
                
                [task run:blackboard];
            });
        });

        context(@"child task returns Pending", ^{
            it(@"should change task status to Running", ^{
                id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
                [[task1 should] receive:@selector(run:) andReturn:theValue(Pending)];
                [[task1 should] receive:@selector(setStatus:) withArguments:theValue(Running)];
                
                [task addChild:task1];
                
                [task run:blackboard];
            });
        });

    });
});

SPEC_END