function result = logzero( a, b, logB )
%logzero is function which evaluate multiplication of variables a * log(b) with
%attention on situation where a,b == 0
% 0*log(0) = 0

if nargin < 3
    logB = true;
end
    
errors = [-Inf, Inf, 0];
e = 0.0000001; 
if abs(a - 0) > e || (~ismember(b, errors) && abs(b-0) > e && isnan(b))
   if logB
     result = a*log(b); 
   else 
     result = log(a)*b; 
   end
else 
   result =  0;
end

end

