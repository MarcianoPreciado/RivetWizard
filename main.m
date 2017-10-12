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
% Date:     October 12, 2017
% Purpose:  Main Rivet Optimizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc
% Operational Parameters
res = 100;            % [cells/in] The number of nodes per inch
accuracy = 1/16;      % [in] The smallest variation between test parameters
graph = false;         % [boolean] If true, displays each iteration

% Material properties
% - Aluminum Plate Characteristics -
sig_u = 49475;          % [psi] Material ultimate tensile strength
tau_u = 30000;          % [psi] Material ultimate shear strength
E = 10296601;           % [psi] Elastic modulus
t = 0.0645;             % [in] Material thickness
W = 2.0515;             % [in] Material Width
h = 1.758;              % [in] Height of overlap
% - Rivet Characteristics -
D = 0.194;              % [in] Avg rivet hole diameter
Do = 0.3955;            % [in] Rivet outer diameter
Ac = pi * D^2 / 4;      % [in2] Rivet cross sectional area
V_max = 590;            % [lb] Rivet ultimate shear strength

% Staggered Diamond Configuration Variables
A = 0.1978*2;           % [in] Edge distance
B = 0.4580;             % [in] Pitch
C = 0.2624;             % [in] Row separation
Co = (D+Do)/2;          % [in] Separation between base rows

% Testing parameter ranges
A_range = (D * 1.5):accuracy:(D + 1/2);
B_range = (Do + 1/16):accuracy:(Do + 1/2);
C_range = (D + Do)/2:accuracy:((D + Do)/2 + 1/4);
Co_range = (D + Do)/2:accuracy:((D + Do)/2 + 1/4);
Base_range = 2:4;
phi_range = 0:0.1:45;

% Staggered Chain Testing
P_max = 0;
params = zeros(1,6);

for i = 1:length(Base_range)
    for j = 1:length(A_range)
        for k = 1:length(B_range)
            for l = 1:length(C_range)
                for m = length(Co_range)
                    for n = length(phi_range)
                        % Assign parameter values
                        Base = Base_range(i);
                        A = A_range(j);
                        B = B_range(k);
                        C = C_range(l);
                        Co = Co_range(m);
                        phi = phi_range(n);
                        % Generate configuration
                        holes = StaggeredDiamond(A,B,C,Co,Base, D, W,h); %[in,in]
                        holes = RotatePoints(W/2, h/2, holes, D+1/16, phi);
                        [N,~] = size(holes);
                        % Ensure configuration is valid
                        if(N == 0)
                            continue;
                        end
                        % Create "simulation" of lap joint
                        Block = zeros(round(res*h), round(res*W));
                        % Fill cut holes out of simulated lap joint
                        Block = PlotHoles(Block,h,W,res,holes,D,graph);
                        if(graph)
                            colormap('hot')
                            drawnow;
                        end
                        % Calculate failure loads
                        P_tensile = TensileLoad(Block,t,sig_u,res);
                        P_tearout = TearoutLoad(Block,t,tau_u,holes,D,res);
                        P_bearing = sig_u * t * D * N;
                        P_shear = V_max * N;
                        % Find the lowest failure load
                        P = [P_tensile, P_shear, P_tearout, P_bearing];
                        P_fail = min(P);

                        % If the failure load is larger than the current
                        % largest,record the failure load and the
                        % parameters that made it.
                        if(P_fail >= P_max)
                            P_max = P_fail;
                            params(1) = Base;
                            params(2) = A;
                            params(3) = B;
                            params(4) = C;
                            params(5) = Co;
                            params(6) = phi;
                        end
                    end
                end
            end
        end
    end
end
%%
% Display the best result
res = 1000;
Base = params(1);
A = params(2);
B = params(3);
C = params(4);
Co = params(5);
phi = params(6);

holes = StaggeredDiamond(A,B,C,Co,Base, D, W,h); %[in,in]
holes = RotatePoints(W/2, h/2, holes, D, phi);
holes = FormatCoordinates(holes,accuracy);
[N,~] = size(holes);
% Create "simulation" of lap joint
Block = zeros(round(res*h), round(res*W));
% Fill cut holes out of simulated lap joint
Block = PlotHoles(Block,h,W,res,holes,D,1);
P_tensile = TensileLoad(Block,t,sig_u,res);
P_tearout = TearoutLoad(Block,t,tau_u,holes,D,res);
P_bearing = sig_u * t * D * N;
P_shear = V_max * N;
fprintf(['Tensile: %.2f\tShear: %.2f\tTear: %.2f\tBearing:'...
        ' %.2f\n\n'], P_tensile,P_shear,P_tearout,P_bearing);
title('Best Calculated Rivet Configuration');
xlabel('Width');
ylabel('Height');
colormap('hot');

for i = 1:N
   fprintf('(%6.6f, %6.6f)\n',holes(i,1),holes(i,2)); 
end