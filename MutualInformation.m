function I = MutualInformation(P, Q)
%% Documentation
% Evaluate mutual information I(X,Y) from distributions :
% P = P(Y|X) -- model matrix
% Q = Q(X)   -- a priori matrix

%% Implementation
Pmatrix = P;
Qprob   = Q;
Ij = @(Pmatrix, Qprob) sum(logzerov(Pmatrix.*Qprob, Pmatrix./(Pmatrix*Qprob')));
Ifun = @(Pmatrix, Qprob) summarize(@(j) Ij(Pmatrix(j,:), Qprob), {1:size(Pmatrix,1)});
I = Ifun(Pmatrix, Qprob);

%%
end

