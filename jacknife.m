function [ pmatrix, binsbounds ] = jacknife( data, k, binsnumber )
%% 
%   Function discre

    signalsize = size(data, 2);
    outputsize = size(data, 1);
    datasamplesize   = round(k*outputsize);
    dataallsamplesize = datasamplesize*signalsize;

    binssize = round(dataallsamplesize/(binsnumber));
    binsboundslist = unique([binssize:binssize:dataallsamplesize]);
    binsboundsup = binsboundslist(1:(binsnumber - 1));
    
    datasample = data(sort(randsample(outputsize, datasamplesize))',:);
    dataallsamplesort  = sort(reshape(datasample, dataallsamplesize, 1));
    binsbounds  = [dataallsamplesort(binsboundsup); Inf];

    databins =   zeros(size(datasample));
    size(binsbounds)
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
    
    binsbounds = [[-Inf; binsbounds(1:(binsnumber-1))], binsbounds];
  
end

