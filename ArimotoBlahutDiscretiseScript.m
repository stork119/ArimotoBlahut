%% ArimotoBlahutDiscretise usage example
% Iteration = 1000;
% Tollerance = 0.05;
% 
% m = 1;
% n  = 1000;
% 
% sigma = 1;
% s = [1 2 3];
% createdata = @(s) normrnd(s, sigma, n, m);
% data = [createdata(s(1)), createdata(s(2)), createdata(s(3))];
% 
% K = 0.6:0.01:1;
% binsnumbers = 10:1:50;
% 
% [Cbias  Clinear]  = ArimotoBlahutDiscretise( data, binsnumbers, K, Iteration, Tollerance, ''  )

%% test sample
cd('/media/knt/D/KN/LNA/ArimotoBlahut')
 
Iteration = 1000;
Tollerance = 0.05;

dirresults = '/results'; 

delimeter = '\t';
for dirinputname = [0.5, 0.25, 0.1]
    
    dirinput = ['Discretization/2015-06-30/Input/traj_sample_', num2str(dirinputname), '.txt'];
    diroutputglobal = ['Discretization/2015-06-30/Output/traj_sample_', num2str(dirinputname), '/Output'];
    
    K = 0.6:0.05:0.95;
    binsnumbers = 25:25:350;
    
%for n = [100]
    
        jlist = 1;

for j = jlist
%diroutput = [diroutputglobal, '-', num2str(n), '-' num2str(j), '/'];
diroutput = [diroutputglobal, '-',  num2str(j)];

mkdir([diroutput]);
mkdir([diroutput, dirresults]);

data = dlmread(dirinput);
input = data(1,:);
output = data(2:size(data,1), :);

%output = output(sort(randsample(size(data,1) , n )),:);

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
   
    print([diroutput,  dirresults,  'all-binnumbers-sample',], '-dpdf');
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

    print([diroutput,  dirresults, num2str(bin)], '-dpdf');
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
   
    print([diroutput,  'results/',  'all' ], '-dpdf');
    hold off;
close(f); 

end

%%
    A = zeros(size(binsnumbers,2), size(jlist, 2) + 1);
    B = zeros(size(binsnumbers,2), size(jlist, 2) + 1);
    edited = false;
    for ibin = 1:size(binsnumbers,2)
        
          bin = binsnumbers(ibin);
          A(ibin,1) = bin;
          B(ibin,1) = bin;
          for jj = 1:size(jlist, 2)
              
            j = jlist(jj);
                  NoResults   = dlmread([diroutput,  num2str(bin), '/NoResults.csv'], delimeter);
            if ~NoResults
                edited = true;
             Clinear = dlmread([diroutput,  num2str(bin), '/Clinear.csv'], delimeter);
             A(ibin,j+1) = Clinear(1);
             B(ibin,j+1) = Clinear(2);
            end
        end
    end
    if edited
        mkdir([diroutputglobal '/']);
        dlmwrite([[diroutputglobal '/'], 'A.csv'], A, 'delimiter', ',', 'precision', 9);
        dlmwrite([[diroutputglobal '/'], 'B.csv'], B, 'delimiter', ',', 'precision', 9);
    end
end



%%




Iteration = 1000;
Tollerance = 0.05;

dirresults = '/results/'; 

delimeter = '\t';
for dirinputname = [0.25, 0.5,  1, 2, 4]
    
    dirinput = ['Discretization/2015-06-30/Inpu/traj_sample_', num2str(dirinputname), '.txt'];
    diroutputglobal = ['Discretization/2015-06-30/Output/traj_sample_', num2str(dirinputname), '/Output'];
    
    K = 0.6:0.01:1;
    binsnumbers = 10:10:500;
    
for n = [100]
    
        jlist = 1;



A = zeros(size(binsnumbers,2), size(jlist, 2) + 1);
    B = zeros(size(binsnumbers,2), size(jlist, 2) + 1);
    for ibin = 1:size(binsnumbers,2)
          bin = binsnumbers(ibin);
          A(ibin,1) = bin;
          B(ibin,1) = bin;
          for jj = 1:size(jlist, 2)
            j = jlist(jj);
            diroutput = [diroutputglobal, '-', num2str(n), '-' num2str(j), '/'];
            Clinear = dlmread([diroutput,  num2str(bin), '/Clinear.csv'], delimeter);
            A(ibin,j+1) = Clinear(1);
            B(ibin,j+1) = Clinear(2);
        end
    end
    mkdir([diroutputglobal, '-', num2str(n), '/']);
    dlmwrite([[diroutputglobal, '-', num2str(n), '/'], 'A.csv'], A, 'delimiter', ',', 'precision', 9);
    dlmwrite([[diroutputglobal, '-', num2str(n), '/'], 'B.csv'], B, 'delimiter', ',', 'precision', 9);
end

end