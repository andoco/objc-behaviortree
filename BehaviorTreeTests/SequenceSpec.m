#import "Kiwi.h"

#import "Action.h"
#import "Sequence.h"

SPEC_BEGIN(SequenceSpec)

describe(@"Sequence", ^{
    __block Sequence *sequence;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        sequence = [[Sequence alloc] init];
        blackboard = [NSMutableDictionary dictionary];
    });
    
    context(@"when run", ^{
        
        it(@"should run children until child returns failure", ^{
            
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];

            id task3 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task3 shouldNot] receive:@selector(run:)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            [sequence addChild:task3];
            
            [sequence run:blackboard];
        });
        
        it(@"should return success if no child returns failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Success)];
        });
        
        it(@"should return failure if any child returns failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];

            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Failure)];

            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should return running if child returns running", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success)];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
        });
                
        it(@"should stop running child if preceding child returns failure", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(Failure)];
            [[task2 should] receive:@selector(stop)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
        
        it(@"should stop running child if preceding child returns running", ^{
            id task1 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task1 should] receive:@selector(run:) andReturn:theValue(Success) withCount:2];
            
            id task2 = [KWMock nullMockForProtocol:@protocol(Task)];
            [[task2 should] receive:@selector(run:) andReturn:theValue(Pending)];
            
            [sequence addChild:task1];
            [sequence addChild:task2];
            
            [[theValue([sequence run:blackboard]) should] equal:theValue(Pending)];
            
            // second run setup
            [[task1 should] receive:@selector(run:) andReturn:theValue(Running)];
            [[task2 should] receive:@selector(stop)];
            [[theValue([sequence run:blackboard]) should] equal:theValue(Failure)];
        });
    });
});

SPEC_END