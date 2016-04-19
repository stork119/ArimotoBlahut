function Y = arrayfuninput(input)
%% Documentation
% Function create input to function arrayfun to summarize over all possible
% dimmensions i.e. sum_{A1, A2, ..., An}
%% creatematrix function
    function Y = creatematrix(input, output, dim, size)
%% Documentation
% Function create matrix of input data for function arrayfun to sum over
% all dimensions i.e. sum_{A1, A2, ..., An} 
% Input
% input  : cell array {A1;A2;...An}
% output : cell array of combinations
% dim    : current analised dimmension
% size   : size of previous output length

%% Implementation
if dim == 0
  Y = output;    
else
    multiplier = length(input{dim});
    for i = (dim+1):length(input)
      output{i}(1:(multiplier*size)) = repmat(output{i}(1:size), 1, multiplier);
    end
    if size ~= 0  
      K = repmat(input{dim}(:), [1 size]);
    else
      K = input{dim}(:);
      size = 1;
    end
    output{dim}(1:multiplier*size) = reshape(K', 1, multiplier*size);
    newdim = dim - 1;
    Y = creatematrix(input, output, newdim, multiplier*size);
end
end

%% Implementation

outputSize = 1;
for i = 1:length(input)
    outputSize = outputSize * length(input{i});
end

output = cell(length(input),1);
for i = 1:length(input)
  output{i} = zeros(1, outputSize);
end

Y = creatematrix(input, output, length(input), 0);

end
