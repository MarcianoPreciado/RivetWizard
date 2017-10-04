function [ ind ] = ClosestIndex( nindex, value)
if(value >= nindex(end))
    ind = length(nindex);
    return;
elseif(value <= nindex(1))
    ind = 0;
    return;
end

ind = 0;
u = length(nindex);
l = 1;
while l <= u
    mid = int32(u+l)/2;
    if(value < nindex(mid))
        u = mid - 1;
    elseif(value > nindex(mid))
        l = mid + 1;
    else
        ind = mid;
        return;
    end
end
ind = mid;
end

