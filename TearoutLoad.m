function [ P ] = TearoutLoad( Block, t, tau, points, D, res )
% TearoutStress - Returns the minimum amount of stress required to cause
% tear-out in a rivet configuration.
% Block: binary area representing the stock. 0 = solid, 1 = hole
% t: stock thickness
% tau: ultimate shear stress of rivet
% points: list of hole center coordinates
% D: rivet shaft diameter
% res: resolution, units: cells/in

% The tear-out load is found by taking the sum of two times the ultimate
% shear stress of each riveet multiplied by the vertical length to the next
% nearest edge multiplied by the thickness of the thinnest sheet.
[rmax,~] = size(Block);
P = 0;
for i = 1:length(points)
    r = int32(res * points(i,2));
    c = int32(res * points(i,1));
    d = 0;
    n = int32(res*D/2 + res*1/32);
    % Start looking upward an downward
    while(true)
        if(r-n < 1 || r + n > rmax)
            d = n;
            break;
        end
        edge = Block(r-n,c) || Block(r+n,c);
        if(edge)
            d = n;
            break;
        end
        n = n + 1;
    end
    L = double(d)/res;          % Calculate length
    P = P + 2*tau*L*t;  % Add onto summation of load
end


end

