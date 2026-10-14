/ Calculates implied probabilities and overround (vig) across complementary binary tokens

.analytics.calcProbabilities:{[yesPrice; noPrice]
    overround: (yesPrice + noPrice) - 1.0;
    probYes: yesPrice % (yesPrice + noPrice);
    probNo: noPrice % (yesPrice + noPrice);
    `impliedProbYes`impliedProbNo`overround!(probYes; probNo; overround)
 };

/ Runs over quotes table to generate derived probability metrics for a market.
/ Assumes a binary market: exactly two complementary outcome tokens.
.analytics.updateMarketProb:{[mktSymbol]
    / Latest top-of-book midpoint per token
    midTable: select mid: last 0.5 * (bidPrice + askPrice) by sym from quotes where market = mktSymbol;
    mids: exec mid from midTable;
    if[2 <> count mids; '"updateMarketProb: expected 2 outcome tokens, got ", string count mids];
    .analytics.calcProbabilities . mids
 };
