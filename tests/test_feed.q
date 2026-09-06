/ Unit test for feed parser and normalizer

\l feed/parser.q
\l feed/normalizer.q

.test.mockJSON: "{\"event_type\":\"quotes\",\"asset_id\":\"1001\",\"market\":\"0x99\",\"bids\":[{\"price\":\"0.45\",\"size\":\"100\"}],\"asks\":[{\"price\":\"0.47\",\"size\":\"200\"}]}";

.test.run:{[]
    parsed: .feed.parseJSON .test.mockJSON;
    if[not count parsed; '"FAILED: JSON parsing"];
    
    norm: .feed.normalize["quotes"; parsed];
    if[not count norm; '"FAILED: Normalization"];
    
    if[not (first norm`bidPrice) = 0.45; '"FAILED: Price calculation mismatch"];
    
    0N! "All polyQ Unit Tests Passed Successfully.";
 };

.test.run[];
exit 0;
