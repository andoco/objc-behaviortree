# Introduction

obj-behaviortree is an implementation of a behavior tree for iOS. Supported tasks include:

* Selector
* Sequence
* Concurrent
* Condition

Behavior trees can be built programatically, or by reading from a JSON file.

# JSON Reader

A behavior tree can be built from a JSON representation:

```json
{"type":"Selector","children":[
    {"type":"ShouldFlee","task":
    	{"type":"Flee"}
	},
	{"type":"ShouldSeek":"task":
		{"type":"Seek"}
	}
]}
```

The JSON is read by _AOBehaviorReader_ which builds an instance of _AOBehaviorTree_:

```objective-c
NSString *json;
...
AOBehaviorReader *reader = [[AOBehaviorReader alloc] init];
AOBehaviorTree *behavior = [reader buildTreeWithFile:json];
```

The reader supports setting properties on task instances:

```json
{"type":"MyAction","someBoolean":true}
```

If you want to set a property of type "Class", you can use the syntax:

```json
{"type":"Flee","fromClassType":"class:MyEnemy"}
```

# Task Class Prefixes

Task types read in from JSON are used to instantiate an objective-c class. To avoid polluting the JSON with class prefixes, you can register your own class prefixes that will be automatically searched when attempting to instantiate a task.

For example, if you register the prefix "AB" with the BehaviorReader:

```objective-c
AOBehaviorReader *reader = [[AOBehaviorReader alloc] init];
[reader registerPrefix:@"AB"];
```

and your JSON contains the task:

```json
{"type":"MyTask"}
```

then the BehaviorReader will first attempt to find a class named "MyTask", and then if that class does not exist it will attempt to find a class named "ABMyTask".

# Logging

Logging can be enabled by setting preprocessor macro flags on the BehaviorTree target.

    BTree_NSLog

Logs to console window using standard NSLog
 
    BTree_NSLogger
    
Logs to an [NSLogger] client using the [NSLogger] client library, which is much faster than using NSLog.

[NSLogger]: https://github.com/fpillet/NSLogger