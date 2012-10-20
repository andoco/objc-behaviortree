#import "Kiwi.h"

#import "Action.h"
#import "Concurrent.h"

SPEC_BEGIN(ConcurrentSpec)

describe(@"Concurrent", ^{
    __block Concurrent *concurrent;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        concurrent = [[Concurrent alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run all children", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];
            
            id task3 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task3 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            [concurrent addChild:task3];
            
            [concurrent run:blackboard];
        });
                
        it(@"should increment numFailedChildren for each failed child", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];
                        
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [concurrent run:blackboard];
            
            [[theValue(concurrent.numFailed) should] equal:theValue(1)];
        });
        
        it(@"should reset numFailedChildren when started", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [concurrent run:blackboard];
            
            [concurrent start:blackboard];
            
            [[theValue(concurrent.numFailed) should] equal:theValue(0)];
        });

        it(@"should return Success if failureLimit is zero and has failed children", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task2 stub:@selector(run:) andReturn:theValue(Success)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(Success)];
        });

        it(@"should return Failure if failed children is greater than or equal to failure limit", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task2 stub:@selector(run:) andReturn:theValue(Success)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            concurrent.failureLimit = 1;
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(Failure)];
        });

        it(@"should return Success if failed children is less than failure limit", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Success)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            concurrent.failureLimit = 2;
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should return Pending if any child returns Pending", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task2 stub:@selector(run:) andReturn:theValue(Pending)];
            
            [concurrent addChild:task1];
            [concurrent addChild:task2];
            
            [[theValue([concurrent run:blackboard]) should] equal:theValue(Pending)];
        });        
    });
});

SPEC_END