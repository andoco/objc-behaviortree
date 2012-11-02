# Introduction

obj-behaviortree is an implementation of a behavior tree for iOS. Supported tasks include:

* Selector
* Sequence
* Concurrent
* Condition

Behavior trees can be built programatically, or by reading from a JSON file.

# Task Class Prefixes

Task types read in from JSON are used to instantiate an objective-c class. To avoid polluting the JSON with class prefixes, you can register your own class prefixes that will be automatically searched when attempting to instantiate a task.

For example, if you register the prefix "AB" with the BehaviorReader:

```objective-c
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