%pathTmp = '/Users/knt/Documents/CME/ExactDistribution/Project/'
%addpath(pwd, pathTmp);
 
%% Gene expression model
k = 1/6;
u = 1/60;
P = @(y,x) poisspdf(y, x/u);

n = 1; %% number of parameters
Qvalues   = [ k - 7*k*[1:n]/(8*n), k, k+7*k*[1:n]/(8*n)];
Qprob = ones(1, 2*n+1)./(2*n + 1); 
Y = 1:300; %% output

Pmatrix1 = createarrayfunoutput(P, {Y;Qvalues}); %% function defined in library
%reduceMatrix = find(Pmatrix(:,1) == 0) - 1;
%Pmatrix = Pmatrix([1:min(reduceMatrix)],:)
%how to choose Pmatrix ?
Qprob = ones(1, size(Pmatrix, 2) )./size(Pmatrix, 2); 

%%% Plots
%plot(Y, Pmatrix(:,1), Y, Pmatrix(:,2),Y, Pmatrix(:,3),Y, Pmatrix(:,4), ...
%    Y, Pmatrix(:,5),Y, Pmatrix(:,6),Y, Pmatrix(:,7),Y, Pmatrix(:,8))

N = 1000; %% max loop size 
[Cpoisson1 Qpoisson1 ...
 Wpoisson1 Apoisson1 ...
 Ipoisson1 Epoisson1 timer1] = ArimotoBlahutAlgorithm(Pmatrix, Qprob, N, 0.05);

%%% Analiza wynik?w 
% index | I(Q,W) | I(Q) | Blad | rozklad
resultsSize = size(cat(2,Cpoisson{1:N}), 2);
matrix   = [1:resultsSize; cat(2,Cpoisson{1:resultsSize}); cat(2,Ipoisson{1:resultsSize}); [0, cat(2,Epoisson{1:resultsSize})]]';
qpoisson = reshape(cat(2, Qpoisson{1:resultsSize}), 21, resultsSize)';
matrix   =  [matrix qpoisson];
matrix


timer = reshape(cat(2, timer{1:resultsSize}), 5, resultsSize)';

min(cat(2, Epoisson{1:N}))


%% Easy model

PeasyIn = [0.1 0.3 0.59 0.01 0 0; 0 0 0 0.3 0.3 0.4]';
QeasyIn = [0.001 0.999];

N = 1000;
[Ceasy Qeasy Weasy Aeasy Ieasy Eeasy timer] = ArimotoBlahutAlgorithm(PeasyIn, QeasyIn, N, 0.00001);


%% Discrete model 
a = 0.7;
b = 0.5;
s = 0.5;

Pmodel2In = [a, 1-a, 0; 0, b, 1-b]';
Qmodel2In = [s, 1-s];

N = 250;
[Cmodel2 Qmodel2 Wmodel2 Amodel2 Imodel2 EImodel2] = ArimotoBlahutAlgorithm(Pmodel2In, Qmodel2In, N, 0.00001);

%%% Analiza wynik?w 
% index | I(Q,W) | I(Q) | rozklad
resultsSize = size(Imodel2, 2);
matrix = [1:resultsSize; cat(2,IWmodel2{1:resultsSize}); cat(2,Cmodel2{1:resultsSize}); cat(2,Imodel2{1:resultsSize})]';
model2 = reshape(cat(2, Qmodel2{1:resultsSize}), 2, resultsSize)';
matrix =  [matrix model2]

%%% Plots
%syms x
%y = exp(a*log(a) - b*log(b)) == (a*(x/(1-x))^((1-b)/(a-b)) + b*(x/(1-x))^((1-a)/(a-b)))^(a-b);
%fsolve(yFun, 0.5)

yFun = @(x) (a*(x./(1-x)).^((1-b)./(a-b)) + b*(x./(1-x)).^((1-a)./(a-b))).^(a-b) - exp(a*log(a) - b*log(b));
plot(0.5:0.01:0.6,yFun(0.5:0.01:0.6))
fplot(yFun, (0:0.01:1))