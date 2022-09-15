function [rankUvalueI, rankUvalueInitial] = rankUvalueFunc(APPs, appIndex, i, rankUvalueInitial, RSUs, rsuIndex)

if ~eq(rankUvalueInitial(i), 0)
    rankUvalueI = rankUvalueInitial(i);
else
    succArray = pickUpSuccFunc(APPs.E{appIndex},i);
    rankUvalueI = 0;
    if size(succArray, 2) > 1e-6
        for step = 1:size(succArray, 2)
            indexSucc = succArray(step);
            if eq(rankUvalueInitial(indexSucc), 0)
                succArray2 = pickUpSuccFunc(APPs.E{appIndex},indexSucc);
                if size(succArray2, 2) > 1e-6
                    [rankUvalueIndexSucc, rankUvalueInitial] = rankUvalueFunc(APPs, appIndex, indexSucc, rankUvalueInitial, RSUs, rsuIndex);
                    rankUvalueInitial(indexSucc) = rankUvalueIndexSucc;
                else
                    rankUvalueInitial(indexSucc) = ceil(mean(APPs.computation{appIndex}(indexSucc)./RSUs.capability(rsuIndex,:))); %计算量除以server的处理能力为计算时间
                end
            end
            rankUvalueI = max(rankUvalueI, APPs.E{appIndex}(i, indexSucc)+rankUvalueInitial(indexSucc));
        end
    end
    rankUvalueI = ceil(mean(APPs.computation{appIndex}(i)./RSUs.capability(rsuIndex,:))) + rankUvalueI; %计算量除以server的处理能力为计算时间
    rankUvalueInitial(i) = rankUvalueI;
end