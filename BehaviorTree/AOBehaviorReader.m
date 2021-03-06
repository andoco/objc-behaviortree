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

#import "AOBehaviorReader.h"

#import "AOBehaviorTree.h"

@implementation AOBehaviorReader

- (id)init
{
    self = [super init];
    if (self) {
        _prefixes = [NSArray array];
        [self registerPrefix:@"AO"];
    }
    return self;
}

-(void) registerPrefix:(NSString*)prefix {
    _prefixes = [_prefixes arrayByAddingObject:prefix];
}

-(id) buildTreeWithFile:(NSString*)jsonPath {
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error)
        [NSException raise:error.description format:nil];

    return [self buildTree:json];
}

-(id) buildTree:(NSDictionary*)jsonObj {
	id<AOTask> root = [self buildTask:jsonObj];
	
    AOBehaviorTree *tree = [[AOBehaviorTree alloc] initWithRootTask:root];
    
	return tree;
}

-(id) buildTask:(NSDictionary*)data {
	Class type = [self taskClass:data];
	
	id<AOTask> task;
    
	if ([self isDecoratorTask:type]) {
		task = [self buildDecoratorTask:type data:data];
    } else if ([self isCompositeTask:type]) {
		task = [self buildCompositeTask:type data:data];
	} else {
        task = [[type alloc] init];
    }
    
    [self populateProperties:task fromData:data];
	
	return task;
}

-(id) buildCompositeTask:(Class)type data:(NSDictionary*)data {
    AOComposite *task = [[type alloc] init];

	NSDictionary *children = [data objectForKey:@"children"];
		
	for (NSDictionary *c in children) {
		id<AOTask> t = [self buildTask:c];
		[task addChild:t];
    }
		
	return task;
}

-(id) buildDecoratorTask:(Class)type data:(NSDictionary*)data {
    id<AOTask> subtask = [self buildTask:[data objectForKey:@"task"]];
    
    return [[type alloc] initWithTask:subtask];
}

-(Class) taskClass:(NSDictionary*)data {
	Class type = NSClassFromString([data objectForKey:@"type"]);
    
    if (!type) {
        for (NSString *prefix in _prefixes) {
            NSString *prefixedType = [prefix stringByAppendingString:[data objectForKey:@"type"]];
            type = NSClassFromString(prefixedType);
            if (type)
                break;
        }
    }
    
    if (!type)
        [NSException raise:@"Unknown task type" format:@"%@", [data objectForKey:@"type"]];
    
    return type;
}

-(BOOL) isCompositeTask:(Class)type {
    return [type isSubclassOfClass:[AOComposite class]];
}

-(BOOL) isDecoratorTask:(Class)type {
    return [type isSubclassOfClass:[AODecorator class]];
}

-(void) populateProperties:(NSObject<AOTask>*)task fromData:(NSDictionary*)data {
    for (NSString *key in data.allKeys) {
        if (![self isReservedKey:key]) {
            id val = [data objectForKey:key];
            
            if ([val isKindOfClass:[NSString class]] && [val hasPrefix:@"class:"])
                val = NSClassFromString([val stringByReplacingOccurrencesOfString:@"class:" withString:@""]);
            
            [task setValue:val forKey:key];
        }
    }
}

-(BOOL) isReservedKey:(NSString*)key {
    return  [key isEqualToString:@"type"] ||
            [key isEqualToString:@"children"] ||
            [key isEqualToString:@"task"];
}

@end
