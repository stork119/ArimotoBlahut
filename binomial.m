%% Binomial model 

% H \in (1, ..., 10^4) 
% T \in  (1, ..., 10^6)
% s \in  (H/100, ..., H*100)

%% Input

for iinput = [10 25 50 75 100 250] 
inputdir = ['Binomial/Binomial-2015-05-29/Input/', 'input-2015-05-29-' num2str(iinput) '.csv'];
outputdir = 'Binomial/Binomial-2015-06-03/Output/Output-';

Iteration = 1000;
Tollerance = 0.05;

%% Library

PHT = @(n, s, H, T) ( (1/(s/H +1)).^(n) * ...
                            (s/(H +s)).^(T-n) * ...
                            nchoosek(T,n))
                     
input = dlmread(inputdir,  '\t');
sizeinput = size(input,1);

T = cell(1, sizeinput);
H = cell(1, sizeinput);
Hspan = cell(1,sizeinput);
Tspan = cell(1,sizeinput);
directory = cell(1,sizeinput); 

S = cell(1,sizeinput);
Sprob  = cell(1,sizeinput);
N  = cell(1,sizeinput);

tPmatrix = cell(1,sizeinput);
tPmatrixEnd  = cell(1,sizeinput);
Pmatrix = cell(1,sizeinput);

tAB  = cell(1,sizeinput);
tABEnd  = cell(1,sizeinput);
C1  = cell(1,sizeinput);
I1   = cell(1,sizeinput);
Q1 = cell(1,sizeinput);
W1  = cell(1,sizeinput);
B1  = cell(1,sizeinput);
E1 = cell(1,sizeinput);
A1  = cell(1,sizeinput);
number1  = cell(1,sizeinput);
timer1  = cell(1,sizeinput);


for i = 1:sizeinput
    T{i}  = input(i,1);
    H{i}  = input(i,3);
    Hspan{i} = input(i,4);
    Tspan{i} = input(i,2);
end;


parfor i = 1:sizeinput
try
    %% input 

directory{i} = [outputdir, num2str(T{i}), '_', num2str(H{i}), '_', num2str(Tspan{i}), '_', num2str(Hspan{i}), '/'];
mkdir(directory{i});
%% preprocessing

%S{i}  = sort(unique((H{i}/100):((100*H{i} - H{i}/100)/Hspan{i}):(100*H{i})));
S{i} = exp(linspace(log((H{i}/100)),log(100*H{i}),Hspan{i}));
Sprob{i} =   ones(1,size(S{i},2))/size(S{i},2);
N{i}  = 0:Tspan{i}:T{i};

tPmatrix{i} = tic;
Pmatrix{i} = createarrayfunoutput(@(n, s) PHT(n,s, H{i}, T{i}), {N{i};S{i}}); %% function defined in library
tPmatrixEnd{i} = toc(tPmatrix{i});

%% algorithm
tAB{i} = tic;
[C1{i}  Q1{i} ...
 W1{i} A1{i} ...
 I1{i}   E1{i} ...
 timer1{i} number1{i} ...
 B1{i}] = ArimotoBlahutAlgorithm(Pmatrix{i}, Sprob{i}, Iteration, Tollerance, false);
tABEnd{i} = toc(tAB{i});

dlmwrite([directory{i}, 'C.csv'], C1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'Q.csv'], Q1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'W.csv'], W1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'A.csv'], A1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'I.csv'], I1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'E.csv'], E1{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'B.csv'], B1{i}, 'delimiter', ',', 'precision', 9);

%% postprocessing
mkdir(directory{i});

dlmwrite([directory{i}, 'posteriori.csv'], Pmatrix{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'parameters.csv'], [S{i}', Sprob{i}', Q1{i}{number1{i}}'], 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'cells.csv'], N{i}', 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'data.csv'], ...
    [ double(tPmatrix{i}), double(tPmatrixEnd{i}), ...
      double(tAB{i}), double(tABEnd{i}),  ...
      double(T{i}), double(Tspan{i}), ...
      double(H{i}), double(Hspan{i}), ...
      double(C1{i}{number1{i}}), double(B1{i}{number1{i}}), ...
      double(Iteration), double(Tollerance), ...
      double(size(S{i},2)), double(C1{i}{number1{i}}), double(B1{i}{number1{i}})], 'delimiter', ',', 'precision', 16);

figure;
plot(S{i}, Q1{i}{number1{i}});
print('-dpdf', [directory{i}, 'plot.pdf']);
savefig([directory{i}, 'plot.fig']);
close;

catch
    dlmwrite([directory{i}, 'error.txt'], [i], 'delimiter', ',', 'precision', 9);
end
end;
end


%% Analysis
inputlist = [10 25 50 75 100 250];
results = zeros(size(inputlist,2)*sizeinput, 8 );

for j = 1:size(inputlist,2)
    iinput = inputlist(j);
    inputdir = ['Binomial/Binomial-2015-05-29/Input/', 'input-2015-05-29-' num2str(iinput) '.csv'];
    input = dlmread(inputdir,  '\t');
    sizeinput = size(input,1);

    
    T = cell(1, sizeinput);
H = cell(1, sizeinput);
Hspan = cell(1,sizeinput);
Tspan = cell(1,sizeinput);
directory = cell(1,sizeinput); 

S = cell(1,sizeinput);
Sprob  = cell(1,sizeinput);
N  = cell(1,sizeinput);

tPmatrix = cell(1,sizeinput);
tPmatrixEnd  = cell(1,sizeinput);
Pmatrix = cell(1,sizeinput);

tAB  = cell(1,sizeinput);
tABEnd  = cell(1,sizeinput);
C1  = cell(1,sizeinput);
I1   = cell(1,sizeinput);
Q1 = cell(1,sizeinput);
W1  = cell(1,sizeinput);
B1  = cell(1,sizeinput);
E1 = cell(1,sizeinput);
A1  = cell(1,sizeinput);
number1  = cell(1,sizeinput);
timer1  = cell(1,sizeinput);

for i = 1:sizeinput
    T{i}  = input(i,1);
    H{i}  = input(i,3);
    Hspan{i} = input(i,4);
    Tspan{i} = input(i,2);
end;

Iteration = 1000;
Tollerance = 0.05;
    outputdir = 'Binomial/Binomial-2015-06-03/Output/Output-';
    for i = 1:sizeinput
        directory{i} = [outputdir, num2str(T{i}), '_', num2str(H{i}), '_', num2str(Tspan{i}), '_', num2str(Hspan{i}), '/'];
        N{i}  = dlmread([directory{i}, 'cells.csv']);
        Pmatrix{i} = dlmread([directory{i}, 'posteriori.csv']);
        C1{i} = dlmread([directory{i}, 'C.csv']);
        Expected = N{i}'*Pmatrix{i};
        results((j-1)*sizeinput + i, :) =  [...
            double(T{i}), ...
            double(H{i}), ...
            double(Hspan{i}), ... 
            double(Tspan{i}), ...
           double(C1{i}(size(C1{i},2))), ...
            double(size(C1{i},2) < Iteration), ...
            double(Expected(1)), ...
            double(Expected(size(Expected,2)))]
    end
end
dlmwrite([outputdir, 'results.csv'], results, 'delimiter', ',', 'precision', 9 )