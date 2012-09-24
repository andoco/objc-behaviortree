#import "Kiwi.h"

#import "Condition.h"
#import "Task.h"

SPEC_BEGIN(ConditionSpec)

describe(@"Condition", ^{
    __block Condition *condition;
    __block id task;
    __block NSMutableDictionary *blackboard;
    
    beforeEach(^{
        task = [KWMock nullMockForProtocol:@protocol(Task)];
        condition = [[Condition alloc] initWithTask:task];
    });
    
    context(@"when run", ^{
        
        context(@"and evaluates to NO", ^{
            
            beforeEach(^{
                [[condition should] receive:@selector(evaluate) andReturn:theValue(NO)];
            });
            
            it(@"should return Failure", ^{
                [[theValue([condition run:blackboard]) should] equal:theValue(Failure)];
            });
            
            it(@"should not run task", ^{
                [[task shouldNot] receive:@selector(start)];
                [condition run:blackboard];
            });
        });
        
        context(@"and evaluates to YES", ^{

            beforeEach(^{
                [[condition should] receive:@selector(evaluate) andReturn:theValue(YES)];
            });

            it(@"should run task", ^{
                [[task should] receive:@selector(run:)];
                [condition run:blackboard];
            });
            
            it(@"should return Success if task returns Success", ^{
                [[task should] receive:@selector(run:) andReturn:theValue(Success)];
                [[theValue([condition run:blackboard]) should] equal:theValue(Success)];
            });

            it(@"should return Failure if task returns Failure", ^{
                [[task should] receive:@selector(run:) andReturn:theValue(Failure)];
                [[theValue([condition run:blackboard]) should] equal:theValue(Failure)];
            });

            it(@"should return Pending if task returns Pending", ^{
                [[task should] receive:@selector(run:) andReturn:theValue(Pending)];
                [[theValue([condition run:blackboard]) should] equal:theValue(Pending)];
            });

        });
        
    });
});

SPEC_END