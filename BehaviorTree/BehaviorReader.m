//
//  BehaviorReader.m
//  BehaviorTree
//
//  Created by Andrew O'Connor on 13/10/2012.
//  Copyright (c) 2012 Andrew O'Connor. All rights reserved.
//

#import "BehaviorReader.h"

#import "BehaviorTree.h"

@implementation BehaviorReader

-(id) buildTreeWithFile:(NSString*)jsonPath {
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error)
        [NSException raise:error.description format:nil];

    return [self buildTree:json];
}

-(id) buildTree:(NSDictionary*)jsonObj {
	id<Task> root = [self buildTask:jsonObj];
	
    BehaviorTree *tree = [[BehaviorTree alloc] initWithRootTask:root];
    
	return tree;
}

-(id) buildTask:(NSDictionary*)data {
	Class type = [self taskClass:data];
	
	id<Task> task;
    
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
    Composite *task = [[type alloc] init];

	NSDictionary *children = data[@"children"];
		
	for (NSDictionary *c in children) {
		id<Task> t = [self buildTask:c];
		[task addChild:t];
    }
		
	return task;
}

-(id) buildDecoratorTask:(Class)type data:(NSDictionary*)data {
    id<Task> subtask = [self buildTask:data[@"task"]];
    
    return [[type alloc] initWithTask:subtask];
}

-(Class) taskClass:(NSDictionary*)data {
	Class type = NSClassFromString(data[@"type"]);
    if (!type)
        [NSException raise:@"Unknown task type" format:@"%@", data[@"type"]];
    return type;
}

-(BOOL) isCompositeTask:(Class)type {
    return [type isSubclassOfClass:[Composite class]];
}

-(BOOL) isDecoratorTask:(Class)type {
    return [type isSubclassOfClass:[Condition class]];
}

-(void) populateProperties:(NSObject<Task>*)task fromData:(NSDictionary*)data {
    for (NSString *key in data.allKeys) {
        if (![self isReservedKey:key]) {
            id val = data[key];
            
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
