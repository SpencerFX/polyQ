/ Parser Utility using kdb+ built-in JSON deserializer (.j.k)

.feed.parseJSON:{[strPayload]
    res: .j.k strPayload;
    :$[type[res] in (98h; 99h); res; ()];
 };
