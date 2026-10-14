/ Rest API Client helper to fetch active Polymarket Metadata from Gamma API
\l feed/parser.q

.api.getMarkets:{[]
    url: "https://gamma-api.polymarket.com/markets?limit=100&active=true";
    / Execute curl via system call for native Q HTTP fetching
    raw: system "curl -s \"", url, "\"";
    parsed: .feed.parseJSON raze raw;
    select id, question, conditionId, slug, outcomePrices from parsed
 };
