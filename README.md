# Introduction

obj-behaviortree is an implementation of a behavior tree for iOS. Supported tasks include:

* Selector
* Sequence
* Concurrent
* Condition

Behavior trees can be built programatically, or by reading from a JSON file.

# Logging

Logging can be enabled by setting preprocessor macro flags on the BehaviorTree target.

    BTree_NSLog

Logs to console window using standard NSLog
 
    BTree_NSLogger
    
Logs to an [NSLogger] client using the [NSLogger] client library, which is much faster than using NSLog.

[NSLogger]: https://github.com/fpillet/NSLogger