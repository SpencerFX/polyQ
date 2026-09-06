/ Market Impact Estimation based on order book depth consumption

.analytics.estimateImpact:{[assetSym; orderSize; orderSide]
    bk: select from l2book where sym = assetSym, side = orderSide;
    bk: `price xdesc bk;
    / Calculate cumulative size depth
    bk: update cumSize: sums size from bk;
    impactPx: exec price from bk where cumSize >= orderSize;
    $[count impactPx; first impactPx; 0n]
 };
