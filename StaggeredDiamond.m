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
% Purpose:  Returns a list of points in the staggered diamond configuration
%           specified by the imput parameters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ points, C ] = StaggeredDiamond(A,B,C,C0,N,D,W,h)
% StaggeredDiamond - Returns an array of coordinates for drill holes for a
% staggered-diamond rivet configuration with the given parameters.
% A: min vertical edge distance
% B: rivet pitch
% C: row spacing
% C0: spacing between middle rows
% N: Number of rivets on base row
% D: Diameter of rivet shaft
% W: Width of stock
% h: height of stock

% Make sure there is enough width for the configuration (with 1/16in space
% between bar edges and hole edges.
points = [];
if(W - (D + (N - 1)*B) <= 0.0625)
    return;
end

% Find how many rows on either side of the center are possible
L = 2*A + C0;  % [in] Amount of vertical space needed for configuration;
m = 1;  % [] Number of rows allowable after base row;
while( L <= h && m < N )
    m = m + 1;
    L = L + 2*C;
end
m = m - 1;
if(m == 0)
    return;
elseif(m > 1)
    Le = h/2 - A - C0/2;
    C = Le/(m-1);
end

y = h/2 + C0/2;
x = W/2;
n = 1; % Index of currently modified point
% Top half procedure
for i = N:-1:N+1-m
    % Placement of first/first two point(s)
    if(mod(i,2) == 0) % If there are an even number of holes this line
        % |    O  O    |
        points(n,1) = x + B/2;
        points(n,2) = y;
        n = n + 1;
        points(n,1) = x - B/2;
        points(n,2) = y;
        n = n + 1;
        i = i - 2;

        % Placement of rest of points
        for j = 1:i/2
           points(n,1) = x + B*(.5 + j);
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - B*(0.5 + j);
           points(n,2) = y;
           n = n + 1;
        end
    else              % If there are an odd number
        % |    O    |
        points(n,1) = x;
        points(n,2) = y;
        n = n + 1;
        i = i - 1;
        % Placement of rest of points
        for j = 1:i/2
           points(n,1) = x + B*(j);
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - B*(j);
           points(n,2) = y;
           n = n + 1;
        end
    end


    y = y + C;
end

y = h/2 - C0/2;
% Bottom half procedure
for i = N:-1:N+1-m
    % Placement of first/first two point(s)
    if(mod(i,2) == 0) % If there are an even number of holes this line
        % |    O  O    |
        points(n,1) = x + B/2;
        points(n,2) = y;
        n = n + 1;
        points(n,1) = x - B/2;
        points(n,2) = y;
        n = n + 1;
        i = i - 2;

        % Placement of rest of points
        for j = 1:i/2
           points(n,1) = x + B*(.5 + j);
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - B*(0.5 + j);
           points(n,2) = y;
           n = n + 1;
        end
    else              % If there are an odd number
        % |    O    |
        points(n,1) = x;
        points(n,2) = y;
        n = n + 1;
        i = i - 1;
        % Placement of rest of points
        for j = 1:i/2
           points(n,1) = x + B*(j);
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - B*(j);
           points(n,2) = y;
           n = n + 1;
        end
    end


    y = y - C;
end
end
