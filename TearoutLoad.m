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
% Purpose:  Calculates the max allowable load for tear-out of a configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ P ] = TearoutLoad( Block, t, tau, points, D, res )
% TearoutStress - Returns the minimum amount of stress required to cause
% tear-out in a rivet configuration.
% Block: binary area representing the stock. 0 = solid, 1 = hole
% t: stock thickness
% tau: ultimate shear stress of material surrounding rivet
% points: list of hole center coordinates
% D: rivet shaft diameter
% res: resolution, units: cells/in

% The tear-out load is found by taking the sum of two times the ultimate
% shear stress surrounding material multiplied by the vertical length to the
% next nearest edge multiplied by the thickness of the thinnest sheet.
[rmax,~] = size(Block);
P = 0;

% Cycle through all of the points and find the distance to the nearest edge
% in the direction of loading and calculate the tear-out load for that
% specific hole. The tear-out is then added to the summation of loads.
for i = 1:length(points)
    % Get coordinates of edge points of interest.
    yc = points(i,2);
    xc = points(i,1);
    top_points = [xc - D/2*sind(40), yc + D/2*cosd(40);
                 xc,yc + D/2;
                 xc + D/2*sind(40), yc + D/2*cosd(40)];
    bottom_points = [xc - D/2*sind(40), yc - D/2*cosd(40);
                     xc, yc - D/2;
                     xc + D/2*sind(40), yc - D/2*cosd(40)];
    % Convert to block cell indices
    rt = round(top_points(:,2).*res);
    ct = round(top_points(:,1).*res);
    rb = round(bottom_points(:,2).*res);
    cb = round(bottom_points(:,1).*res);
    % Adjust to make sure all points start at a 0 point
    for i = 1:3
        while(Block(rt(i),ct(i)))
            rt(i) = rt(i) + 1;
        end
        while(Block(rb(i),cb(i)))
            rb(i) = rb(i) - 1;
        end
    end
    % Algorithm searches in steps of 5 upward and downward from the holes.
    % If a hole/edge is found we back up to find the exact edge location
    % If we go past the edge, we call it.
    d = 1;
    n = 5;
    edge_found = false;
    [top_end, ~] = size(Block);
    while(~edge_found)
        for i = 1:3
           d = d + n;
           if(rt(2)+ d >= top_end) % If the new index reaches the top edge
               d = top_end - rt(2);
               edge_found = true;
               break;
           elseif(rb(2) - d <= 1) % If the new index reaches the bottom edge
               d = rb(2);
               edge_found = true;
               break;
           end
           if(Block(rt(i)+d,ct(i))) % If an edge is found going up
               % Backtrack to see if we passed the beginning of the edge
               while(~edge_found)
                   d = d - 1;
                   if(~Block(rt(i)+d,ct(i)))
                      edge_found = true;
                   end
               end
               break;
           elseif(Block(rb(i)-d,ct(i))) % If an edge is found going down
               % Backtrack to see if we passed the beginning of the edge
               while(~edge_found)
                   d = d - 1;
                   if(~Block(rb(i)-d,cb(i)))
                      edge_found = true;
                   end
               end
               break;
           end
        end
    end
    L = double(d)/res;          % Calculate length
    P = P + 2*tau*L*t;  % Add onto summation of load
end
end
