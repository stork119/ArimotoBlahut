%% 2015-11-09 %%

%% Input
directoryname  = '2016-04-18/160414_GeneExpression_traj\traj\';
experimentsprefix      = 'traj_ParSet_';
experimentsnumbers = [18 19 27 29 30];

K = 0.6:0.05:0.95;
binsnumbers = 40:40:400;

%%
Iteration = 1000;
Tollerance = 0.05;
delimeter = '\t';


%dirresults = '/results'; 
expnames = cell(max(size(experimentsnumbers)),1);
for i = 1:max(size(experimentsnumbers))
    expnames{i} = [experimentsprefix, num2str(experimentsnumbers(i))];
end
directoryinput   = ['Input/',    directoryname];
directoryoutput = ['Output/', directoryname];

for expi = 1:max(size(expnames))
    expname = expnames{expi};
    
    dirinput = [directoryinput,  expname, '.txt'];
    diroutput = [directoryoutput, expname, '/'];    
    mkdir([diroutput]);

    data = dlmread(dirinput);
%    input   = data(1,:);
    output = data(1:size(data,1), :);

    response = output;
    directory = diroutput;

    [Cbias,  Clinear]  = ArimotoBlahutDiscretise( output, binsnumbers, K, Iteration, Tollerance, diroutput );


%% Analise results
    CbiasAll = {};

f = figure;
hold on;
title(['Sample size :',]);

for bin = binsnumbers
disp(bin);
    Cbias   = dlmread([diroutput,  num2str(bin), '/Cbias.csv'], delimeter);
    CbiasAll{bin} = Cbias;
    plot(bin, mean(Cbias), '.')
end

ylabel('I biased');
    xlabel('Bin number');
   
    print([diroutput,  'all-binnumbers-sample',], '-dpdf');
    hold off;
close(f); 

%%

for bin = binsnumbers 
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

    print([diroutput, num2str(bin)], '-dpdf');
    hold off;    
    close(f); 
end
end


% All
f = figure;
hold on;
title(['All']);
for bin = binsnumbers
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
   
    print([diroutput,  'all' ], '-dpdf');
    hold off;
close(f); 

    A = zeros(size(binsnumbers,2), 1);
    B = zeros(size(binsnumbers,2), 1);
    edited = false;
    for ibin = 1:size(binsnumbers,2)    
          bin = binsnumbers(ibin);
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
        dlmwrite([diroutput, 'A.csv'], A, 'delimiter', ',', 'precision', 9);
        dlmwrite([diroutput, 'B.csv'], B, 'delimiter', ',', 'precision', 9);
    end

end
