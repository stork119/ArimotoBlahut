%% Analise results
mkdir(directoryoutputresults);
directoryoutputlist = dir(diroutput);


binsfolders = [];
for binfolderind = 1:max(size(directoryoutputlist))
    binfolder = directoryoutputlist(binfolderind);
    binfoldername = binfolder.name;
    if ~(strcmp(binfoldername, 'results')  | strcmp(binfoldername, '.') | strcmp(binfoldername, '..'))
        if exist([diroutput, binfoldername ,'/NoResults.csv'])
            binsfolders(max(size(binsfolders)) + 1) =  str2num(binfoldername);
        end
    end
end

CbiasAll = {};

f = figure;
hold on;
title(['Sample size :',]);

for bin = binsfolders
disp(bin);
    Cbias   = dlmread([diroutput,  num2str(bin), '/Cbias.csv'], delimeter);
    CbiasAll{bin} = Cbias;
    plot(bin, mean(Cbias), '.')
end

ylabel('I biased');
    xlabel('Bin number');
   
    print([directoryoutputresults,  'all-binnumbers-sample',], '-dpdf');
    hold off;
close(f); 

%%

for bin = binsfolders 
      NoResults   = dlmread([diroutput,  num2str(bin), '/NoResults.csv'], delimeter);
if ~NoResults
    f = figure;

    hold on;
    title(['Number of bis :', num2str(bin)]);

    Cbias   = dlmread([diroutput,  num2str(bin), '/Cbias.csv'], delimeter);
    Ksize = dlmread([diroutput,  num2str(bin), '/Ksize.csv'], delimeter);
    plot(Ksize, Cbias, '.')
    Clinear = dlmread([diroutput,  num2str(bin), '/Clinear.csv'], delimeter);
    y = @(x) Clinear(1)*x + Clinear(2);
    x = 0:0.0001:1.5*max(Ksize);
    plot(x, y(x));
    ylabel('I biased');
    xlabel('1/sample size');

    print([directoryoutputresults, num2str(bin)], '-dpdf');
    hold off;    
    close(f); 
end
end


% All
f = figure;
hold on;
title(['All']);
for bin = binsfolders
    NoResults   = dlmread([diroutput,  num2str(bin), '/NoResults.csv'], delimeter);
if ~NoResults
    Cbias   = dlmread([diroutput,  num2str(bin), '/Cbias.csv'], delimeter);
    Ksize = dlmread([diroutput,  num2str(bin), '/Ksize.csv'], delimeter);
    plot(Ksize, Cbias, '.')
    Clinear = dlmread([diroutput,  num2str(bin), '/Clinear.csv'], delimeter);
    y = @(x) Clinear(1)*x + Clinear(2);
    x = 0:0.0001:1.5*max(Ksize);
    plot(x, y(x));
end
end

ylabel('I biased');
xlabel('1/sample size');
   
print([directoryoutputresults,  'all' ], '-dpdf');
hold off;
close(f); 

    A = zeros(size(binsfolders,2), 1);
    B = zeros(size(binsfolders,2), 1);
    edited = false;
    for ibin = 1:size(binsfolders,2)    
          bin = binsfolders(ibin);
          A(ibin,1) = bin;
          B(ibin,1) = bin;              
            NoResults   = dlmread([diroutput,  num2str(bin), '/NoResults.csv'], delimeter);
            if ~NoResults
                edited = true;
             Clinear = dlmread([diroutput,  num2str(bin), '/Clinear.csv'], delimeter);
             A(ibin, 1) = Clinear(1);
             B(ibin,1) = Clinear(2);
            end
    end
    if edited
        dlmwrite([directoryoutputresults, 'A.csv'], A, 'delimiter', ',', 'precision', 9);
        dlmwrite([directoryoutputresults, 'B.csv'], B, 'delimiter', ',', 'precision', 9);
    end
