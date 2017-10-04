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
while( L <= h )
    m = m + 1;
    L = L + 2*C;
end
m = m - 1;
if(m == 0)
    return;
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

