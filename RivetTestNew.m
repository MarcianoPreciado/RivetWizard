%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Marciano C. Preciado
% October 2, 2017
% Rivet Placement Tester and Optimizer
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
tau_u = 680;%590;            % [lb] Shear Strength of Rivet

% Staggered Diamond Configuration Variables
% A = 0.222;   % [in] Edge distance
% B = 0.3955;     % [in] Pitch
% C = 0.4268;     % [in] Row separation
% Base = 5;   % [] Base number of rivets
A = 0;   % [in] Edge distance
B = 0.4368;     % [in] Pitch
C = 0.2533;     % [in] Row separation
Co = (D+Do)/2;
Base = 4;   % [] Base number of rivets

% Get hole coordinates for rivets in staggered configuration
holes = StaggeredChain(A,B,C,Co,Base, D, W,h); %[xin,yin]
[N,~] = size(holes);

res = 1000;  % [cells/in]
Block = zeros(round(res*h), round(res*W));  % Make lap joint section
Block = PlotHoles(Block,h,W,res,holes,D,1);   % Fill lap joint with rivets


%% Run down each horizontal and 
Lm_max = 0;
for y = 1:res*h
    Lm = 0;
    for x = 1:res*W
        Lm = Lm + Block(y,x);
    end
    if(Lm > Lm_max)
        Lm_max = Lm;
    end
end

P_tensile = sig_u * t * W - Lm_max/res
P_shear = tau_u * Ac * N
P_tearout = TearoutLoad(Block,t,tau_u,holes,D,res)
P_bearing = sig_u * t * D * N

%% Find Optimal Staggered Diamond Configuration
accuracy = 1/32;
B_range = (Do+1/32):accuracy:(Do+1/4);         % [in]
d = (Do+D)/2;

% Storage of high values
P_max_buf = zeros(1,30);
params = zeros(30,4);
buf = 30;

for i = 1:length(B_range)
    % Generate configuration'
    Base = 5;
    A = Do;
    B = B_range(i);
    C = sqrt(d^2 - B^2/4);
    holes = StaggeredDiamond(A,B,C,Co,Base, D, W,h); %[in,in]
    [N,~] = size(holes);
    if(N == 0);
        continue;
    end
    Block = zeros(round(res*h), round(res*W));  % Make lap joint section
    Block = PlotHoles(Block,h,W,res,holes,D,1);   % Fill lap joint with rivets
    drawnow;
    % Test configuration
    Lm_max = 0;
    for y = 1:res*h
        Lm = 0;
        for x = 1:res*W
            Lm = Lm + Block(y,x);
        end
        if(Lm > Lm_max)
            Lm_max = Lm;
        end
    end
    P_tensile = sig_u * t * W - Lm_max/res;
    P_shear = tau_u * Ac * N;
    P_tearout = TearoutLoad(Block,t,tau_u,holes,D,res);
    P_bearing = sig_u * t * D * N;
    P = [P_tensile, P_shear, P_tearout, P_bearing];
    P_fail = min(P);
    % If the failure load is larger than the current largest,
    % record the failure load and the parameters that made it.
    if(P_fail >= P_max_buf(i) || P_fail > 310)
    % Set next buffer location
        buf = buf + 1;
        if(buf > 30)
            buf = 0;
        end
        P_max_buf(i) = P_fail;
        params(i,1) = Base;
        params(i,2) = A;
        params(i,3) = B;
        params(i,4) = C;
    end
end

%% Find Optimal Staggered Diamond Configuration
accuracy = 1/32;
B_range = (Do+1/32):accuracy:(Do+1/4);         % [in]
d = (Do+D)/2;

% Storage of high values
P_max_buf = zeros(1,30);
params = zeros(30,4);
buf = 30;

for i = 1:length(B_range)
    % Generate configuration'
    Base = 4;
    A = Do;
    B = B_range(i);
    C = sqrt(d^2 - B^2/4);
    holes = StaggeredDiamond(A,B,C,Co,Base, D, W,h); %[in,in]
    [N,~] = size(holes);
    if(N == 0);
        continue;
    end
    Block = zeros(round(res*h), round(res*W));  % Make lap joint section
    Block = PlotHoles(Block,h,W,res,holes,D,1);   % Fill lap joint with rivets
    drawnow;
    % Test configuration
    Lm_max = 0;
    for y = 1:res*h
        Lm = 0;
        for x = 1:res*W
            Lm = Lm + Block(y,x);
        end
        if(Lm > Lm_max)
            Lm_max = Lm;
        end
    end
    P_tensile = sig_u * t * W - Lm_max/res;
    P_shear = tau_u * Ac * N;
    P_tearout = TearoutLoad(Block,t,tau_u,holes,D,res);
    P_bearing = sig_u * t * D * N;
    P = [P_tensile, P_shear, P_tearout, P_bearing];
    P_fail = min(P);
    % If the failure load is larger than the current largest,
    % record the failure load and the parameters that made it.
    if(P_fail >= P_max_buf(i) || P_fail > 310)
    % Set next buffer location
        buf = buf + 1;
        if(buf > 30)
            buf = 0;
        end
        P_max_buf(i) = P_fail;
        params(i,1) = Base;
        params(i,2) = A;
        params(i,3) = B;
        params(i,4) = C;
    end
end