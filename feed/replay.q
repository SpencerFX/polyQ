/ Historic Log Replay Utility for feed backtesting

.replay.fromLog:{[logPath]
    h: hopen logPath;
    0N! "Replaying log file: ", string logPath;
    while[not -15!h;
        expr: -11!h;
        / Evaluate log commands
        @[eval; expr; {[err] 0N! "Replay error: ", err}];
    ];
    hclose h;
 };
