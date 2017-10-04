%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Marciano C. Preciado
% October 2, 2017
% Rivet Placement Tester and Optimizer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clear, clc

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
% A_range = (D/2+1/16):1/32:0.5;  % [in]
% B_range = Do:1/32:0.75;         % [in]
% C_range = (Do+1/32):1/32:0.6;   % [in]
% Base_range = 3:5;               % []
accuracy = 1/32;
A_range = (D+Do)/2:accuracy:(Do/2+1/4);            % [in]
B_range = (Do+1/32):accuracy:(Do+1/4);         % [in]
%C_range = (Do+1/32):accuracy:(Do/2+3/8);       % [in]
d_range = sqrt((Do+1/32)^2 - B_range.^2/4);
Base_range = 4:5;                               % []

% Storage of high values
P_max_buf = zeros(1,30);
params = zeros(30,4);
buf = 30;

for i = 1:length(Base_range)
    for j = length(A_range):-1:1
        for k = length(B_range):-1:1
            for l = length(d_range):-1:1
                % Generate configuration'
                Base = Base_range(i);
                A = A_range(j);
                B = B_range(k);
                C = d_range(l);
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
        end
    end
end

%% Find Optimal Staggered Chain Configuration
% A_range = (D/2+1/16):1/32:0.5;  % [in]
% B_range = Do:1/32:0.75;         % [in]
% C_range = (Do+1/32):1/32:0.6;   % [in]
% Base_range = 3:5;               % []
accuracy = 1/32;
A_range = (D+Do)/2:accuracy:(Do/2+1/4);            % [in]
B_range = (Do+1/32):accuracy:(Do+1/4);         % [in]
C_range = (D+1/32):accuracy:(Do/2+3/8);       % [in]
Base_range = 4:5;                               % []

% Storage of high values
P_max_buf = zeros(1,30);
params = zeros(30,4);
buf = 30;

for i = 1:length(Base_range)
    for j = length(A_range):-1:1
        for k = length(B_range):-1:1
            for l = length(C_range):-1:1
                % Generate configuration'
                Base = Base_range(i);
                A = A_range(j);
                B = B_range(k);
                C = C_range(l);
                holes = StaggeredChain(A,B,C,Co,Base, D, W,h); %[in,in]
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
        end
    end
end


save('results.mat','P_max_buf', 'params', 'i');