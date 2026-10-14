/ Historic Log Replay Utility for feed backtesting

/ Replays a kdb+ message log written by the RDB (records of the form
/ (`.feed.upd; evtType; payload)). Each record is executed via -11!, which
/ applies it against the current process - so load db/schema.q + feed code first.
.replay.fromLog:{[logPath]
    logPath: $[":" ~ first string logPath; logPath; hsym logPath];
    0N! "Replaying log file: ", string logPath;
    n: @[-11!; logPath; {[e] '"replay failed: ", e}];
    0N! "Replayed ", string[n], " messages from ", string logPath;
    n
 };
