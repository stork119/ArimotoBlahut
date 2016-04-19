function [Cmatrix, Qmatrix, Wmatrix, Amatrix, IWmatrix, Ematrix, timer, n, Bmatrix] = ArimotoBlahutAlgorithm( P, Q, N, eTollerance, printflogs )
%% Arimoto Blahut Algorithm
%% INPUT
% P = P(Y|X) -- model rows output; columns input
% Q = P(X)   -- a priori
% N limit of evaluation -- default 1000
% eTollerance
% printflogs
%% OUTPUT 
% Cell arays of vectors 1 x N
% Cmatrix -- estimation of capacity channel I(Q*,W*) in nats
% Qmatrix -- Q* estimated distribution of parameters
% Wmatrix -- P(X|Y) posteriori distrbution
% Amatrix --
% Imatrix -- I(Q*)
% Ematrix -- terminate condtition ln(Q^(n+1)/Q^(n))
% Bmatrix -- estimation of capacity channel I(Q*,W*) in states

%% Private functions

% Creates Wmatrix 
Wfun = @(n, Pmatrix, Qprob) ...
    ((Pmatrix*diag(Qprob))./ ...
    repmat(Pmatrix*(Qprob)', 1, size(Pmatrix, 2)))';

% Creates Amatrix
alphaFun = @(Pmatrix, Wmatrix) diag(exp(logzerom(Wmatrix, Pmatrix, false)))';


% Mutual Information
Ij = @(Pmatrix, Qprob) sum(logzerov(Pmatrix.*Qprob, Pmatrix./(Pmatrix*Qprob')));
I = @(Pmatrix, Qprob) ...
      summarize(@(j) Ij(Pmatrix(j,:), Qprob), {1:size(Pmatrix,1)});
%% Initialization
if nargin < 4
  if nargin < 3
      eTollerance = 0.001;
  end
  N  = 1000;
  
end

Wmatrix = cell(1, N);
Amatrix = cell(1, N);
Cmatrix = cell(1, N);
Bmatrix = cell(1, N);
Ematrix = cell(1, N);

Qmatrix = cell(1, N);
Qmatrix{1} = Q;

Pmatrix = P;

Imatrix = cell(1, N);

IWmatrix = cell(1, N);

Cmatrix{1} = I(Pmatrix, Qmatrix{1});
Bmatrix{1} = exp(Cmatrix{1});
%% Implementation

timer = cell(1, N);

terminateAlgorithm = false;
n = 0;
while ~terminateAlgorithm 
  n = n + 1;
  timerTmp = zeros(1,5);
  
  if printflogs
    disp(['Loop ', num2str(n)]);
  end
  
  tic;
  Wmatrix{n} = Wfun(n - 1, Pmatrix, Qmatrix{n}); 
  timerTmp(1) = toc;
  tic;
  Amatrix{n} = alphaFun(Pmatrix, Wmatrix{n});
  timerTmp(2) = toc;
  tic;
  Qmatrix{n + 1} = Amatrix{n} ./ sum(Amatrix{n});
  timerTmp(3) = toc;

  tic;
  Cmatrix{n + 1} = log(sum(Amatrix{n}));
  Bmatrix{n + 1} = exp(Cmatrix{n + 1});
  timerTmp(4) = toc;
  
  if printflogs
    disp(['I(Q, W^n) ', num2str(Cmatrix{n+1})]);
  end
  
  tic;
  Ematrix{n + 1} = -Cmatrix{n+1} + max(log(Amatrix{n}) - log(Qmatrix{n}));
  timerTmp(5) = toc;
  if printflogs
    disp(['End condition ', num2str(Ematrix{n+1})]);
  end
  timer{n + 1} = timerTmp;
  terminateAlgorithm = Ematrix{n + 1} < eTollerance || n + 1 == N;
end

end

