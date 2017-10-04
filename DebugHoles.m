function [  ] = DebugHoles( W, h, points )
figure;
plot(points(:,1),points(:,2),'x');
hold on
corners = [0,0;0,h;W,h;W,0;0,0];
plot(corners(:,1), corners(:,2),'-');
plot([W/2,W/2],[h,0],'--.r');
plot([0,W],[h/2,h/2], '-.r');

end

