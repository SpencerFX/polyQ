/ Calculates implied probabilities and overround (vig) across complementary binary tokens

.analytics.calcProbabilities:{[yesPrice; noPrice]
    overround: (yesPrice + noPrice) - 1.0;
    probYes: yesPrice % (yesPrice + noPrice);
    probNo: noPrice % (yesPrice + noPrice);
    `impliedProbYes`impliedProbNo`overround!(probYes; probNo; overround)
 };

/ Runs over quotes table to generate derived probability table
.analytics.updateMarketProb:{[mktSymbol]
    mktQuotes: select from quotes where market = mktSymbol;
    / Extract top bid/ask midpoint per token
    midTable: select mid: 0.5 * (bidPrice + askPrice) by sym from mktQuotes;
    / Assuming binary outcome tokens
    p: .analytics.calcProbabilities . midTable`mid;
    p
 };
