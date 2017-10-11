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

end

