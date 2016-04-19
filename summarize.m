function S = summarize(f, X)
%% Documentation
% sum_{A1, A2, ..., An} f(x1, x2, ... , xn)

%% Implementation

%if(nargin(f) > 1)
  Y = arrayfuninput(X);
  S = sum(arrayfun(f, Y{1:nargin(f)}));
%else 
%  S = sum(f(X));   
%end
end