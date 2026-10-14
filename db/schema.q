/ Database Schema Definition for Polymarket Core Engine

/ Quotes (Level 1 / Top of Book)
quotes:([]
    time:`timestamp$();
    sym:`symbol$();          / Asset/Token ID as symbol
    market:`symbol$();       / Condition ID / Market Hash
    bidPrice:`float$();
    bidSize:`float$();
    askPrice:`float$();
    askSize:`float$()
 );

/ Trades (Execution reports)
trades:([]
    time:`timestamp$();
    sym:`symbol$();
    market:`symbol$();
    side:`symbol$();         / `buy or `sell
    price:`float$();
    size:`float$();
    maker:`symbol$();
    taker:`symbol$()
 );

/ Level 2 Order Book Updates
l2book:([]
    time:`timestamp$();
    sym:`symbol$();
    side:`symbol$();         / `bid or `ask
    price:`float$();
    size:`float$()
 );

/ Probability Tracking Table (Derived metrics)
probTrack:([]
    time:`timestamp$();
    market:`symbol$();
    tokenYes:`symbol$();
    tokenNo:`symbol$();
    impliedProbYes:`float$();
    impliedProbNo:`float$();
    overround:`float$()
 );
