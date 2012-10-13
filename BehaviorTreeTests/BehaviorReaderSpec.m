#import "Kiwi.h"
#import "BehaviorTree.h"
#import "BehaviorReader.h"
#import "TestAction.h"
#import "TestCondition.h"

SPEC_BEGIN(BehaviorReaderSpec)

describe(@"BehaviorReader", ^{
    context(@"when reading behavior json", ^{
        __block BehaviorReader *reader;
        
        beforeEach(^{
            reader = [[BehaviorReader alloc] init];
        });
        
        it(@"should build task", ^{
            NSString *jsonPath = [[NSBundle bundleForClass:[BehaviorReaderSpec class]] pathForResource:@"action" ofType:@"json"];
            BehaviorTree *tree = [reader buildTreeWithFile:jsonPath];
            
            [[[tree.root class] should] equal:[TestAction class]];
        });
        
        it(@"should populate task properties", ^{
            NSString *jsonPath = [[NSBundle bundleForClass:[BehaviorReaderSpec class]] pathForResource:@"action" ofType:@"json"];
            BehaviorTree *tree = [reader buildTreeWithFile:jsonPath];
            
            [[[tree.root class] should] equal:[TestAction class]];
            TestAction *task = tree.root;
            [[theValue(task.intProperty) should] equal:theValue(3)];
            [[theValue(task.boolProperty) should] equal:theValue(YES)];
        });
        
        it(@"should build selector", ^{
            NSString *jsonPath = [[NSBundle bundleForClass:[BehaviorReaderSpec class]] pathForResource:@"selector" ofType:@"json"];
            BehaviorTree *tree = [reader buildTreeWithFile:jsonPath];
            
            [[[tree.root class] should] equal:[Selector class]];
            Selector *selector = tree.root;
            [[theValue(selector.children.count) should] equal:theValue(2)];
            [[[[selector.children objectAtIndex:0] class] should] equal:[TestAction class]];
            [[[[selector.children objectAtIndex:0] class] should] equal:[TestAction class]];
        });

        it(@"should build sequence", ^{
            NSString *jsonPath = [[NSBundle bundleForClass:[BehaviorReaderSpec class]] pathForResource:@"sequence" ofType:@"json"];
            BehaviorTree *tree = [reader buildTreeWithFile:jsonPath];
            
            [[[tree.root class] should] equal:[Sequence class]];
            Sequence *selector = tree.root;
            [[theValue(selector.children.count) should] equal:theValue(2)];
            [[[[selector.children objectAtIndex:0] class] should] equal:[TestAction class]];
            [[[[selector.children objectAtIndex:0] class] should] equal:[TestAction class]];
        });
        
        it(@"should build condition", ^{
            NSString *jsonPath = [[NSBundle bundleForClass:[BehaviorReaderSpec class]] pathForResource:@"condition" ofType:@"json"];
            BehaviorTree *tree = [reader buildTreeWithFile:jsonPath];
            
            [[[tree.root class] should] equal:[TestCondition class]];
            Condition *condition = tree.root;
            [[[condition.task class] should] equal:[TestAction class]];
        });

        context(@"and task type not found", ^{
            it(@"should raise exception", ^{
                NSDictionary *data = @{@"type":@"UnknownAction"};
                
                [[theBlock(^{
                    [reader buildTree:data];
                }) should] raiseWithName:@"Unknown task type"];
            });
        });
        
    });
    
});

SPEC_END