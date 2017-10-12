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
% Purpose:  Revolves the points in the array 'points' about the chosen center
%           point (cx,cy) by 'dtheta' degrees. Returns 0x0 vector if the rotated
%           points leave the area of interest. Bounds (0,0), (0,2cy), (2cx,2cy)
%           and (2cx,0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ new_points ] = RotatePoints( cx, cy, points, D, dtheta )
[N,~] = size(points);
new_points = zeros(N,2);
if(dtheta == 0)
    return;
end

polar = zeros(N,2);
for i = 1:N
    % convert coordinates from cartesian to polar
    dx = points(i,1)-cx;
    dy = points(i,2)-cy;
    r = sqrt((dx)^2 + (dy)^2);
    theta = atand(dy/dx);
    if(dx < 0 && dy < 0)
        theta = theta + 180;
    elseif(dx < 0)
        theta = theta + 180;
    elseif(dy < 0)
        theta = theta + 360;
    end
    theta = theta + dtheta;
    polar(i,1) = r;
    polar(i,2) = theta;

    % convert changed coordinates back to cartesian
    x = r*cosd(theta) + cx;
    y = r*sind(theta) + cy;
    if(0 < x - D/2 && x + D/2 < 2*cx && 0 < y - D/2 && y + D/2 < 2*cy)
        new_points(i,1) = x;
        new_points(i,2) = y;
    else
        clear new_points;
        new_points = [];
    break;
    end
end
new_points = sortrows(new_points);
end
