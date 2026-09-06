/ Query high-level events (e.g. Election / Rate Cut macro buckets)
.api.getEvents:{[slug]
    url: "https://gamma-api.polymarket.com/events?slug=", string slug;
    raw: system "curl -s \"", url, "\"";
    .feed.parseJSON raze raw
 };
