function [ points ] = StaggeredChain( A,B,C,C0,N,D,W,h )
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

