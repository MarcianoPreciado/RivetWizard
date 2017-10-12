%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Copyright 2017 Marciano C. Preciado
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
% Author:   Marciano C. Preciado
% Date:     October 2, 2017
% Purpose:  Adds representation of drilled holes into the 'Block' representation
%           of the overlapped specimen.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Block] = PlotHoles( Block,h,W, res, holes, D,plot)
% PlotHoles - Adds the holes from list of coordinates to the binary matrix
% and plots if <plot> is true
% Block: binary matrix representing the stock. 0 = stock, 1= hole
% h: stock height
% W: stock width
% res: resolution of Block in cells/in
% holes: list of coordinates for hole centers
% D: rivet shaft diameter
% plot: if true, will plot the new block, if false doesn not plot

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
