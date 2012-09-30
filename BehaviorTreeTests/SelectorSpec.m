#import "Kiwi.h"

#import "Action.h"
#import "Selector.h"

SPEC_BEGIN(SelectorSpec)

describe(@"Selector", ^{
    __block Selector *selector;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        selector = [[Selector alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run children until child returns success", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 shouldNot] receive:@selector(run:)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [selector run:blackboard];
        });
        
        it(@"should return success if any child returns success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];

            id task2 = [Action mock];
            [task1 stub:@selector(run:) andReturn:theValue(Success)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should return failure if no child returns success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            [selector addChild:task1];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should return running if any child returns running", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task1 stub:@selector(run:) andReturn:theValue(Failure)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [task2 stub:@selector(run:) andReturn:theValue(Pending)];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
        });
                
        it(@"should stop running child if preceding child returns success", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Failure)] run:blackboard];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 stubAndReturn:theValue(Pending)] run:blackboard];

            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(Success)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should stop running child if preceding child returns running", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 stubAndReturn:theValue(Failure)] run:blackboard];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 stubAndReturn:theValue(Pending)] run:blackboard];
            
            [selector addChild:task1];
            [selector addChild:task2];
            
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 stubAndReturn:theValue(Pending)] run:blackboard];
            [[task2 should] receive:@selector(stop:)];
            [[theValue([selector run:blackboard]) should] equal:theValue(Pending)];
        });
    });
});

SPEC_END