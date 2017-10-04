%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Marciano C. Preciado
% October 2, 2017
% New Function tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc

sig_u = 49475;          % [psi] Material ultimate tensile strength
E = 10296601;           % [psi] Elastic modulus
t = 0.058;              % [in] Material thickness
W = 1.958;              % [in] Material Width
h = 1.74;               % [in] Height of overlap                

D = (0.192 + 0.196)/2;  % [in] Avg rivet hole diameter
Do = 0.3955;            % [in] Rivet outer diameter
Ac = pi * D^2 / 4;      % [in2] Rivet cross sectional area
tau_u = 590;            % [lb] Shear Strength of Rivet

% Staggered Diamond Configuration Variables
% A = 0.222;   % [in] Edge distance
% B = 0.3955;     % [in] Pitch
% C = 0.4268;     % [in] Row separation
% Base = 5;   % [] Base number of rivets
A = Do/4;   % [in] Edge distance
B = Do ;     % [in] Pitch
C = sqrt((Do*2/3)^2-(B/2)^2)+0.0625;     % [in] Row separation
Co = Do;
Base = 5;   % [] Base number of rivets

% Get hole coordinates for rivets in staggered configuration
holes = StaggeredChain(A,B,C,Co,Base, D, W,h); %[xin,yin]
[N,~] = size(holes);
if(N>0)
    DebugHoles(W,h,holes);
end

%%  Diamond
% Get hole coordinates for rivets in staggered configuration
holes = StaggeredDiamond(A,B,C,Co,Base, D, W,h); %[xin,yin]
[N,~] = size(holes);
DebugHoles(W,h,holes);