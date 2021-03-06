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
% Purpose:  Finds the index of the closest element to 'value' in a sorted
%           numerical vector.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ ind ] = ClosestIndex( vector, value)
if(value >= vector(end))
    ind = length(vector);
    return;
elseif(value <= vector(1))
    ind = 0;
    return;
end

ind = 0;
u = length(vector);
l = 1;
while l <= u
    mid = int32(u+l)/2;
    if(value < vector(mid))
        u = mid - 1;
    elseif(value > vector(mid))
        l = mid + 1;
    else
        ind = mid;
        return;
    end
end
ind = mid;
end
