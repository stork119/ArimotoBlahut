function R = logzerov( A, B, logB )
%logzerom is function which evaluate multiplication of vectors A * log(B) with
%attention on situation where A(i,j), B(j,k) == 0
% 0*log(0) = 0

if nargin < 3
    logB = true;
end
    
nanIndicies = find(B == 0);

%% To reimplement
if size(nanIndicies) == 0
    if logB
      R = A.*log(B);
    else 
      R = log(A).*B;
    end
else
    R = arrayfun(@(a,b) logzero(a,b,logB), A, B);
end

end