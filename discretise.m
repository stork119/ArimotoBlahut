function [ pmatrix, binsbounds, binsnumbererror ] = discretise( data, k, binsnumber )
%% discretise 
%   Function divides data into bins so that each bin of the marginal
%   distribution has approximately equal density (under the assumption that
%   P(signal) is uniformly distributed). 
%% Input :
% -- data -- matrix with data to discretisation  
%           -- rows number = output size
%           -- columns number = signal size
% -- k -- \in \[0, 1\] -- percentage of data used in jackknife algorithm
% -- binsnumber 
%% Output :
% -- pmatrix -- matrix with distribution over bins under assumption of
% signal
%           -- rows number = binsnumber
%           -- columns number = signal size
% -- binsbounds  -- matrix with bins bundaries
% -- binsnumbererror  -- logical value if too big binsnumber
%%

    signalsize = size(data, 2);
    outputsize = size(data, 1);
    datasamplesize   = round(k*outputsize);
    dataallsamplesize = datasamplesize*signalsize;
    binsnumbererror = true;    
    pmatrix =   [];
    binsbounds = [];
    
    if dataallsamplesize >= binsnumber
        binsnumbererror = false;    
    
    %binssize = floor(dataallsamplesize/(binsnumber));
        binsboundslist = linspace(0, dataallsamplesize, (binsnumber+1))';
        binsboundslist = floor(binsboundslist(2:(binsnumber)));
      %  disp(dataallsamplesize);
     %disp(binsboundslist);
       % disp(size(binsboundslist));
     %datasample = data(sort(randsample(outputsize, datasamplesize))',:);
    %dataallsamplesort  = sort(reshape(datasample, dataallsamplesize, 1));
        
        datasample = zeros(datasamplesize, signalsize);
        for i = 1:signalsize
            datasample(1:datasamplesize, i)  = data(sort(randsample(outputsize, datasamplesize)), i);
        end;
    
        dataallsamplesort  = sort(reshape(datasample, dataallsamplesize, 1));
        %disp(size(datasample));
%        disp(size(dataallsamplesort));
        binsbounds  = [dataallsamplesort(binsboundslist); Inf];

        databins =   zeros(size(datasample) + 1);

        for i = 1:signalsize
            for j = 1:datasamplesize
                d = datasample(j, i);
                databins(j, i) = sum(d > binsbounds) + 1;
            end;
         end;

        pmatrix =   zeros(binsnumber , signalsize);
        for i = 1:signalsize
            for j = 1:binsnumber
                d = databins(:, i);
                pmatrix(j, i) = sum(d == j)/datasamplesize;
            end;
        end;
        %disp(binsboundslist);
        %disp(binsbounds);
        %disp(size(binsbounds));
        %disp(binsnumber);
        binsbounds = [[-Inf; binsbounds(1:(binsnumber-1))], binsbounds];
    end
end