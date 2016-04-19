function R = logzerom( A, B, logB )
%logzerom is function which evaluate multiplication of matrices A * log(B) with
%attention on situation where A(i,j), B(j,k) == 0
% 0*log(0) = 0

if nargin < 3
    logB = true;
end
    
nanIndicies = find(B == 0);

%% To reimplement
if size(nanIndicies) == 0
    if logB
      R = A*log(B);
    else 
      R = log(A)*B;
    end
else 
    R = zeros(size(A,1), size(B,1));
    for i = 1:size(A, 1)
        for j = 1:size(B,2)
            R(i,j) = sum(arrayfun(@(a,b) logzero(a,b,logB), A(i,:), B(:,j)'));
        end
    end
end

end

