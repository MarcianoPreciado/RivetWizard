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
% Purpose:  Returns a list of points in the staggered chain configuration
%           specified by the imput parameters.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ points, C ] = StaggeredChain( A,B,C,C0,N,D,W,h )
% StaggeredChain - Returns an array of coordinates for drill holes for a
% staggered-chain rivet configuration with the given parameters.
% A: min vertical edge distance
% B: rivet pitch
% C: row spacing
% C0: spacing between middle rows
% N: Number of rivets on each row
% D: Diameter of rivet shaft
% W: Width of stock
% h: height of stock

B01 = B/4;
B02 = 3*B/4;
% Make sure there is enough width for the configuration (with 1/16 in space
% between bar edges and hole edges)
points = [];
if(W/2 - (N/2 - 1)*B - B02 - D/2 < 1/16)
    return;
end

% Find how many rows on either side of the center are possible
L = 2*A + C0;  % [in] Amount of vertical space needed for configuration;
m = 1;  % [] Number of rows on either side of half line base row;
while( L <= h )
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
n = 1;      % Index of currently modified point
f = false;  % Is this row flipped about the Y axis
for i = 1:m
    if(~f)
        offset1 = B01;
        offset2 = B02;
        f = true;
    else
        offset1 = B02;
        offset2 = B01;
        f = false;
    end

    % Placement of first/first two point(s)
    if(mod(N,2) == 0) % If there are an even number of holes this line
        % |  O  O|  O  O |
        % | O  O | O  O  |
        %  --------------
        % First point placement
        points(n,1) = x + offset1;
        points(n,2) = y;
        n = n + 1;
        points(n,1) = x - offset2;
        points(n,2) = y;
        n = n + 1;
        % Placement of rest of points
        for j = 1:(N-1)/2
           points(n,1) = x + offset1 + j*B;
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - offset2 - j*B;
           points(n,2) = y;
           n = n + 1;
        end

    else% If there are an odd number
        % | O  O|  O   |
        % |   O |O  O  |
        %  ------------
        if(~f)
            for j = 0:((N-1)/2 - 1)
              points(n,1) = x + offset1 + j*B;
              points(n,2) = y;
              n = n + 1;
            end
            for j = 0:((N+1)/2 - 1)
               points(n,1) = x - offset2 - j*B;
               points(n,2) = y;
               n = n + 1;
            end
        else
            for j = 0:((N-1)/2 - 1)
              points(n,1) = x - offset2 - j*B;
              points(n,2) = y;
              n = n + 1;
            end
            for j = 0:((N+1)/2 - 1)
               points(n,1) = x + offset1 + j*B;
               points(n,2) = y;
               n = n + 1;
            end
        end

    end
    y = y + C;
end

% Bottom Half

y = h/2 - C0/2;
f = true;  % Is this row flipped about the Y axis
for i = 1:m
    if(~f)
        offset1 = B01;
        offset2 = B02;
        f = true;
    else
        offset1 = B02;
        offset2 = B01;
        f = false;
    end

    % Placement of first/first two point(s)
    if(mod(N,2) == 0) % If there are an even number of holes this line
        % |  O  O|  O  O |
        % | O  O | O  O  |
        %  --------------
        % First point placement
        points(n,1) = x + offset1;
        points(n,2) = y;
        n = n + 1;
        points(n,1) = x - offset2;
        points(n,2) = y;
        n = n + 1;
        % Placement of rest of points
        for j = 1:(N-1)/2
           points(n,1) = x + offset1 + j*B;
           points(n,2) = y;
           n = n + 1;
           points(n,1) = x - offset2 - j*B;
           points(n,2) = y;
           n = n + 1;
        end

    else% If there are an odd number
        % | O  O|  O   |
        % |   O |O  O  |
        %  ------------
        if(~f)
            for j = 0:((N-1)/2 - 1)
              points(n,1) = x + offset1 + j*B;
              points(n,2) = y;
              n = n + 1;
            end
            for j = 0:((N+1)/2 - 1)
               points(n,1) = x - offset2 - j*B;
               points(n,2) = y;
               n = n + 1;
            end
        else
            for j = 0:((N-1)/2 - 1)
              points(n,1) = x - offset2 - j*B;
              points(n,2) = y;
              n = n + 1;
            end
            for j = 0:((N+1)/2 - 1)
               points(n,1) = x + offset1 + j*B;
               points(n,2) = y;
               n = n + 1;
            end
        end

    end
    y = y - C;
end
end
