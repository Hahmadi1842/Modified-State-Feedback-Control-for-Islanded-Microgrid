clc;
clear;
close all;

%% Problem Definition
% global A2
% global B2
% global C2
% global Km
% global Kg
CostFunction=@ mycostsmc;       % Cost Function

nVar=78;                    % Number of Variables

VarSize=[1 nVar];           % Size of Variables Matrix

VarMin=-15000*ones(1,78);                  % Lower Bound of Variables
VarMax= 15000*ones(1,78);                  % Upper Bound of Variables

VarRange=[VarMin VarMax];   % Variation Range of Variables

VelMax=(VarMax-VarMin)/100;  % Maximum Velocity
VelMin=-VelMax;             % Minimum Velocity

%% GA Parameters

MaxIt=5000;      % Maximum Number of Iterations

nPop=70;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=round(pCrossover*nPop/2)*2;  % Number of Parents (Offsprings)

pMutation=0.2;                      % Mutation Percentage
nMutation=round(pMutation*nPop);    % Number of Mutants


%% Initialization

% Empty Structure to Hold Individuals Data
empty_individual.Position=[];
empty_individual.Cost=[];

% Create Population Matrix
pop=repmat(empty_individual,nPop,1);

% Initialize Positions
for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    pop(i).Cost=CostFunction(pop(i).Position);
    
end

% Sort Population
pop=SortPopulation(pop);

% Store Best Solution
BestSol=pop(1);

% Vector to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

%% GA Main Loop

for it=1:MaxIt
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        i2=randi([1 nPop]);
        
        p1=pop(i1);
        p2=pop(i2);
        
        [popc(k,1).Position popc(k,2).Position]=Crossover(p1.Position,p2.Position,VarRange);
        
        try        
        popc(k,1).Cost=CostFunction(popc(k,1).Position);
        popc(k,2).Cost=CostFunction(popc(k,2).Position);
        catch err
        end
        
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        
        p=pop(i);
        
        try
        popm(k).Position=Mutate(p.Position,VarRange);
        
        popm(k).Cost=CostFunction(popm(k).Position);
        catch err
        end
        
    end
    
    % Merge Population
    pop=[pop
         popc
         popm];
    
    % Sort Population
    pop=SortPopulation(pop);
    
    % Delete Extra Individuals
    pop=pop(1:nPop);
    
    % Update Best Solution
    BestSol=pop(1);
    
    % Store Best Cost
    BestCost(it)=BestSol.Cost;
    BestL1(it)=BestSol.Position(1);
    BestL2(it)=BestSol.Position(2);
    BestL3(it)=BestSol.Position(3);
    BestL4(it)=BestSol.Position(4);
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

%% Plots

% figure;
% 
% plot(BestCost,'linewidth',3)
% xlabel('iteration')
% ylabel('optimal cost')
% legend('optimal cost')
% grid
% 
% figure
% 
% plot(BestL1,'linewidth',3)
% xlabel('iteration')
% ylabel('optimal \lambda1')
% legend('optimal \lambda1')
% grid
% 
% figure
% 
% plot(BestL2,'linewidth',3)
% xlabel('iteration')
% ylabel('optimal \lambda2')
% legend('optimal \lambda2')
% grid
% 
% figure
% 
% plot(BestL3,'linewidth',3)
% xlabel('iteration')
% ylabel('optimal k1')
% legend('optimal k1')
% grid
% figure
% 
% plot(BestL4,'linewidth',3)
% xlabel('iteration')
% ylabel('optimal k2')
% legend('optimal k2')
% grid

x=BestSol.Position;
A2=[0,-1.15000000000000,0,0,0,0,0,0,0,0,0,0,0;0,0.800000000000000,0,0,0,0,0,0,0,9.12000000000000,-1.16000000000000,15.2700000000000,0;0,0,-0.800000000000000,0,0,0,0,0,0,-1.16000000000000,-9.12000000000000,0,-15.2700000000000;0,0,-1.23000000000000,0,0,0,0,0,0,-1,0,0,0;0,0,0,0,0,0,0,0,0,0,-1,0,0;0,0,-1.15000000000000,9,0,0,0,-1,0,-1.50000000000000,-150,1.75000000000000,0;0,0,0,0,9,0,0,0,-1,150,-1.50000000000000,0,1.75000000000000;0,1.25000000000000,-1.69000000000000,24,0,8.85000000000000,0,-6.05714285714286,14,-1.87000000000000,-9,4.50000000000000,0;0,-1.69000000000000,0,0,24,0,8.85000000000000,-14,-6.05714285714286,9,-1.87000000000000,0,4.50000000000000;0,1.28500000000000,0,0,0,0,0,1.20000000000000,0,0,31.4000000000000,-1.20000000000000,0;0,1.28600000000000,0,0,0,0,0,0,1.20000000000000,-31.4000000000000,0,0,-1.20000000000000;19.6215104229527,1.17000000000000,0,0,0,0,0,0,0,2.85714285714286,0,-1.28700000000000,31.4000000000000;13.0400000000000,1.19000000000000,0,0,0,0,0,0,0,0,2.85714285714286,-31.4000000000000,-1.28700000000000];
B2=[0,0,-1;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;-2.85713770000155,-0.00542856816238154,0;0.00542856816238154,-2.85713770000155,0];
C2=[0,-0.000150000000000000,0,0,0,0,0,0,0,0,0,0,0;1.42833739578288,0,0,0,0,0,0,0,0,0,0,0.999998195000543,-0.00189999885683354;11.4027344213486,0,0,0,0,0,0,0,0,0,0,0.00189999885683354,0.999998195000543];

K=[x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13),x(14),x(15),x(16),x(17),x(18),x(19),x(20),x(21),x(22),x(23),x(24),x(25),x(26);...
   x(27),x(28),x(29),x(30),x(31),x(32),x(33),x(34),x(35),x(36),x(37),x(38),x(39),x(40),x(41),x(42),x(43),x(44),x(45),x(46),x(47),x(48),x(49),x(50),x(51),x(52);...
   x(53),x(54),x(55),x(56),x(57),x(58),x(59),x(60),x(61),x(62),x(63),x(64),x(65),x(66),x(67),x(68),x(69),x(70),x(71),x(72),x(73),x(74),x(75),x(76),x(77),x(78)];
Abar=[A2,zeros(13,13);zeros(13,26)];
Bbar=[B2;zeros(13,3)];
Cbar=[C2,zeros(3,13)];

y=eig(Abar-Bbar*K);

Km=[K(1,1:13);K(2,1:13);K(3,1:13)];

Am=A2-B2*Km;
Kg=-inv(C2*(Am\B2));
N=zeros(13,13);
nr=[22,23,24,25,32,33,34,35,42,43,44,45,52,53,54,55];
N(nr)=rand(1,16);
L=ones(26,3);
% A2=[0,-1.15000000000000,0,0,0,0,0,0,0,0,0,0,0;0,0.800000000000000,0,0,0,0,0,0,0,9.12000000000000,-1.16000000000000,15.2700000000000,0;0,0,-0.800000000000000,0,0,0,0,0,0,-1.16000000000000,-9.12000000000000,0,-15.2700000000000;0,0,-1.23000000000000,0,0,0,0,0,0,-1,0,0,0;0,0,0,0,0,0,0,0,0,0,-1,0,0;0,0,-1.15000000000000,9,0,0,0,-1,0,-1.50000000000000,-150,1.75000000000000,0;0,0,0,0,9,0,0,0,-1,150,-1.50000000000000,0,1.75000000000000;0,1.25000000000000,-1.69000000000000,24,0,8.85000000000000,0,-6.05714285714286,14,-1.87000000000000,-9,4.50000000000000,0;0,-1.69000000000000,0,0,24,0,8.85000000000000,-14,-6.05714285714286,9,-1.87000000000000,0,4.50000000000000;0,1.28500000000000,0,0,0,0,0,1.20000000000000,0,0,31.4000000000000,-1.20000000000000,0;0,1.28600000000000,0,0,0,0,0,0,1.20000000000000,-31.4000000000000,0,0,-1.20000000000000;19.6215104229527,1.17000000000000,0,0,0,0,0,0,0,2.85714285714286,0,-1.28700000000000,31.4000000000000;13.0400000000000,1.19000000000000,0,0,0,0,0,0,0,0,2.85714285714286,-31.4000000000000,-1.28700000000000];
% B2=[0,0,-1;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;0,0,0;-2.85713770000155,-0.00542856816238154,0;0.00542856816238154,-2.85713770000155,0];
% C2=[0,-0.000150000000000000,0,0,0,0,0,0,0,0,0,0,0;1.42833739578288,0,0,0,0,0,0,0,0,0,0,0.999998195000543,-0.00189999885683354;11.4027344213486,0,0,0,0,0,0,0,0,0,0,0.00189999885683354,0.999998195000543];
% D2=zeros(3,3);
% %%
% Km=[x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13);...
%     x(14),x(15),x(16),x(17),x(18),x(19),x(20),x(21),x(22),x(23),x(24),x(25),x(26);...
%     x(27),x(28),x(29),x(30),x(31),x(32),x(33),x(34),x(35),x(36),x(37),x(38),x(39)];
% eig(A2-B2*Km)
% Kg=inv(-C2*((A2-B2*Km)\B2));
% sys=ss(A2-B2*Km,B2,C2,D2);
% sim('SF_sim_1')
% 
% plot(t/10,y(1,:),'b','linewidth',2.5)
% hold on
% plot(t/10,y(2,:),'r','linewidth',2.5)
% hold on
% plot(t/10,y(3,:),'k','linewidth',2.5)
% xlabel('time [sec]')
% ylabel('output')
% legend('y_1','y_2','y_3')
