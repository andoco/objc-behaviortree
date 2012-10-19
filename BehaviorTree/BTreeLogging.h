#ifdef DEBUG
    #ifdef BTREE_NSLog
        #define BTreeNSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #else
        #define BTreeNSLog(...)
    #endif
    #ifdef BTREE_NSLogger
        #import "LoggerClient.h"
        #define BTreeNSLogger(fmt, ...) LogMessageCompat((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #else
        #define BTreeNSLogger(...)
    #endif
    #define DLog(fmt, ...) \
        BTreeNSLog(fmt, ##__VA_ARGS__); \
        BTreeNSLogger(fmt, ##__VA_ARGS__);
#else
    #define DLog(...)
#endif
