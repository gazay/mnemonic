# memory_logger
Simple logger to show where is leaking by many-many puts

Example of output:
```
ENTRY 4 :: [2015-09-18 16:59:25 +0800]: #<Social::Activity::Vkontakte:0x007fcc8c4bdcb8>, pub 2456056, finished

    STAT NAME          CURRENT diff:  PREVIOUS|     BEGIN

  MAIN_STATS:

    MEM:                796.82 diff:  +603.336|  +664.031 MB
    OBJ_SIZE:           98.317 diff:    -8.583|    +10.76 MB
    OBJ_CNT:           1662162 diff:         0|   +547796

  GC_STATS:

    GC (m/M):            435/76
    OLD_OBJ:            413640 diff:    +11118|    +83427
    HEAP_LIVE:          446362 diff:    -64913|     +2339
    HEAP_AVLBL:         831081 diff:         0|   +273898
    MALLOC_INC:          4.574                            MB

  OBJECTS:

    FREE:               384651 diff:    +64912|   +271492
    TOTAL:              831081 diff:         0|   +273898

    T_CLASS:             12640 diff:       +14|     +2068
    T_COMPLEX:               1 diff:         0|         0
    T_RATIONAL:            889 diff:         0|     -2484
    T_SYMBOL:             1701 diff:         0|      +548
    T_ICLASS:             3972 diff:         0|     +1495
    T_MODULE:             1969 diff:         0|      +313
    T_FLOAT:                 9 diff:         0|         0
    T_BIGNUM:               13 diff:         0|        -1
    T_FILE:                 11 diff:        -1|      -117
    T_REGEXP:             3660 diff:        -1|      +309
    T_STRUCT:             1253 diff:        -4|      +480
    T_MATCH:                15 diff:      -159|      -121
    T_OBJECT:            22106 diff:     -1604|     +9016
    T_NODE:              46644 diff:     -3173|    -25435
    T_HASH:              14338 diff:     -6133|     +4642
    T_DATA:              76145 diff:     -7288|    +18246
    T_ARRAY:             74829 diff:    -17285|      +766
    T_STRING:           186235 diff:    -29278|     -7319
```
