#import "Kiwi.h"
#import "Action.h"
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
            id action1 = [Action mock];
            id action2 = [Action mock];
            
            [task addChild:action1];
            [task addChild:action2];
            
            [[theValue(task.children.count) should] equal:theValue(2)];
            [[[task.children objectAtIndex:0] should] equal:action1];
            [[[task.children objectAtIndex:1] should] equal:action2];
        });
    });
});

SPEC_END