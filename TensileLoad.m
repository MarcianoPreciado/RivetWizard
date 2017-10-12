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
% Purpose:  Calculates the max allowable tensile load of a given configuration.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ P_tensile ] = TensileLoad( Block, t, sig_u, res )
%TensileLoad - Calculates the maximum allowable tensile load on the given
%block with given thickness, ultimate tensile strength, and resolution.
% Block: binary matrix to represent block. 0 = stock, 1 = hole
% t: thickness of stock
% sig_u: ultimate tensile strength of material
% res: resolution of Block in cells/in

% Get dimensions of the block
[h,W] = size(Block);
h = h/res;
W = W/res;

LN_max = 0; % Highest count of negative space cells so far
for y = 1:int32(res*h)
    LN = 0; % Count of negative space cells in this horizontal so far
    for x = 1:int32(res*W)
        LN = LN + Block(y,x);
    end
    if(LN > LN_max)
        LN_max = LN;
    end
end

P_tensile = sig_u * t * (W - LN_max/res);
end
