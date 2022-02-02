function intPowers(x,n)
    BigFloat(x).^(1:n)
end

function firstdigit(x; base=10)
    parse(Int,string(x, base=base)[1],base=base)
end

function benfordCount(data; base=10)
    ds = firstdigit.(data, base=base)
    [count(isequal(d), ds) for d in 1:(base-1)]
end

function benfordFreq(data; base=10)
    bc = benfordCount(data, base=base)
    bc/sum(bc)
end

function benfordDist(base=10)
    DiscreteNonParametric(1:(base-1), [log(base, (d+1)/d) for d in 1:(base-1)])
end

function benfordChi2(data; base=10)
    if length(data)>0
        Ei = pdf(benfordDist(base))*length(data)
        Oi = benfordCount(data, base=base)
        sum((Oi-Ei).^2 ./ Ei)
    else
        1000000
    end
end

function chi2Pvalue(chi2; df=8)
    ccdf(Chisq(df), chi2)
end

function benfordPvalue(data; base=10)
    chi2Pvalue(benfordChi2(data), df=base-2)
end

function pMark(p)
    mark = ["ok","*","**","***"]
    level = sum(p .<= [0.001,0.01,0.05,1])
    mark[level]
end

function pComment(p)
    comment = ["Good fit","Fair fit","Poor fit","Bad fit"]
    level = sum(p .<= [0.001,0.01,0.05,1])
    comment[level]
end

function benfordMark(data; base=10)
    chi2Mark(benfordChi2(data, base=base))
end

function chi2Mark(chi2)
    pMark(chi2Pvalue(chi2))
end

function chi2Comment(chi2)
    pMark(chi2Pvalue(chi2))
end

;