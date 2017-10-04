function [Block] = PlotHoles( Block,h,W, res, holes, D,plot)
[n,~] = size(holes);
yindex = linspace(0,h,round(h*res));
xindex = linspace(0,W,round(res*W));
R = D/2;
for i = 1:n
    xx = holes(i,1);                % [in] x coordinate of centerpoint
    yy = holes(i,2);                % [in] y coordinate of centerpoint
    cx = ClosestIndex(xindex,xx);   % [ind] index x into column
    cy = ClosestIndex(yindex,yy);   % [ind] index y into row
    % Creat index bounds
    lx = cx - round(R*res); ux = cx + round(R*res);
    ly = cy - round(R*res); uy = cy + round(R*res);
    
    % Create square and cycle within square to find which points are part
    % of the hole
    for c = lx:ux
        for r = ly:uy
            % Find distance from center of current point
            d = (xx - xindex(c))^2 + (yy - yindex(r))^2;
            d = sqrt(d);
            if(d <= R)
                Block(r,c) = 1;
            end
        end
    end
    
end
if(plot)
    imagesc(Block);
end
end

