
%% preprocessing

addpath('../GeneExpressionMatrix')

inputdir = ['GeneExpression/2015-06-30/Input/', 'parameters.csv'];

input = dlmread(inputdir, '\t');

inputsignal = input(:,[1,2,3]);
input = input(:,[4,5,6,7,8])

Iteration = 1000;
Tollerance = 0.05;
sizeinput = size(input,1);

Nmax = cell(1, sizeinput);
a = cell(1, sizeinput);
b = cell(1, sizeinput);
l = cell(1, sizeinput);
directory = cell(1,sizeinput); 
id = cell(1,sizeinput); 


S = cell(1, sizeinput);
Sprob  = cell(1,sizeinput);
N  = cell(1,sizeinput);

tPmatrix = cell(1,sizeinput);
tPmatrixEnd  = cell(1,sizeinput);
Pmatrix = cell(1,sizeinput);

tAB  = cell(1,sizeinput);
tABEnd  = cell(1,sizeinput);

C  = cell(1,sizeinput);
I   = cell(1,sizeinput);
Q = cell(1,sizeinput);
W  = cell(1,sizeinput);
B  = cell(1,sizeinput);
E = cell(1,sizeinput);
A  = cell(1,sizeinput);
number  = cell(1,sizeinput);
timer  = cell(1,sizeinput);

%for si = {{0,10}}
 %  for sj = [150]
  %     signal = (si{1}{1}:((si{1}{2}-si{1}{1})/sj):si{1}{2});

for i = 1:sizeinput
    Nmax{i}  = input(i,1);
    a{i}  = input(i,2);
    b{i}  = input(i,3);
    l{i}   = input(i,4);
    id{i} = [num2str(inputsignal(i,1)), '_', num2str(inputsignal(i,2)), '_', num2str(inputsignal(i,3)), '_', num2str(Nmax{i}), '_', num2str(a{i}), '_', num2str(b{i}), '_', num2str(l{i})];
    directory{i} = ['GeneExpression/2015-06-30/Output/Output_', id{i}, '/'];
end;

%%
parfor i = 1:sizeinput
    try
        if ~exist([directory{i},'\plot.fig'])
        signal = (inputsignal(i,1):((inputsignal(i,2)-inputsignal(i,1))/inputsignal(i,3)):inputsignal(i,2));
%for i = 1
%% input 
%directory{i} = ['GeneExpression/Results/Results_', num2str(Nmax{i}), '_', num2str(a{i}), '_', num2str(b{i}), '_', num2str(l{i}), '/'];

%% preprocessing
  mkdir(directory{i});
      dlmwrite([directory{i}, 'input.csv'], [num2str(inputsignal(i,1)), num2str(inputsignal(i,2)), num2str(inputsignal(i,3)),num2str(Nmax{i}),  num2str(a{i}), num2str(b{i}), num2str(l{i})], 'delimiter', ',', 'precision', 9);
S{i}  =  signal;
Sprob{i} =   ones(1,size(S{i},2))/size(S{i},2);

tPmatrix{i} = tic;
Pmatrix{i} = probMatr(Nmax{i},S{i},a{i},b{i},l{i}, directory{i});
tPmatrixEnd{i} = toc(tPmatrix{i});

dlmwrite([directory{i}, 'posteriori.csv'], Pmatrix{i}, 'delimiter', ',', 'precision', 9);

%% algorithm

disp(id{i});

tAB{i} = tic;
[C{i},  Q{i}, ...
 W{i}, A{i}, ...
 I{i},   E{i}, ...
 timer{i}, number{i}, ...
 B{i}] = ArimotoBlahutAlgorithm(Pmatrix{i}, Sprob{i}, Iteration, Tollerance, true);
tABEnd{i} = toc(tAB{i});

%% postprocessing

dlmwrite([directory{i}, 'C.csv'], C{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'Q.csv'], Q{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'W.csv'], W{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'A.csv'], A{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'I.csv'], I{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'E.csv'], E{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'B.csv'], B{i}, 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'parameters.csv'], [S{i}', Sprob{i}', Q{i}{number{i}}'], 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'cells.csv'], N{i}', 'delimiter', ',', 'precision', 9);
dlmwrite([directory{i}, 'data.csv'], ...
    [ double(tPmatrix{i}), double(tPmatrixEnd{i}), ...
      double(tAB{i}), double(tABEnd{i}),  ...
      double(Nmax{i}), ...
      double(a{i}), ...
      double(b{i}), ...
      double(l{i}), ...
      double(C{i}{number{i}}), double(B{i}{number{i}}), ...
      double(Iteration), double(Tollerance), ...
      double(size(S{i},2)),double(C{i}{number{i}}), double(B{i}{number{i}})], 'delimiter', ',', 'precision', 16);

figure;
plot(S{i}, Q{i}{number{i}});
print('-dpdf', [directory{i}, 'plot.pdf']);
savefig([directory{i}, 'plot.fig']);
close;
        end
    catch err
        disp(err);
        fileID = fopen([directory{i}, 'error.txt'], 'w');
        fprintf(fileID,'%s\n', err);
        fclose(fileID);
    end;
end;
%  end
%end


%% Output
silist = {{0,1}, {0, 10}, {1, 10}};
sjlist = [50, 100, 150];

results =  zeros(size(sjlist,2)*size(silist,2)*sizeinput, 11 );
j = 1;
for si = silist
   for sj = sjlist
       signal = (si{1}{1}:((si{1}{2}-si{1}{1})/sj):si{1}{2});
    
    for i = 1:sizeinput
        Nmax{i}  = input(i,1);
        a{i}  = input(i,2);
        b{i}  = input(i,3);
        l{i}   = input(i,4);
        id{i} = [num2str(si{1}{1}), '_', num2str(si{1}{2}), '_', num2str(sj), '_', num2str(Nmax{i}), '_', num2str(a{i}), '_', num2str(b{i}), '_', num2str(l{i})];
        directory{i} = ['GeneExpression/2015-06-01/Output/Output_', id{i}, '/'];
    end;

    for i = 1:sizeinput
        Pmatrix{i} = dlmread([directory{i}, 'posteriori.csv']);
        C1{i} = dlmread([directory{i}, 'C.csv']);   
        Expected = (0:(size(Pmatrix{i},1)-1))*Pmatrix{i};
        results(j, :) =  [...
            double(si{1}{1}), ...
            double(si{1}{2}), ...
            double(sj), ...
            double(Nmax{i}), ...
            double(a{i}), ... 
            double(b{i}), ...
            double(l{i}), ...
            double(C1{i}(size(C1{i},2))), ...
            double(size(C1{i},2) < Iteration), ...
            double(Expected(1)), ...
            double(Expected(size(Expected,2)))];
        j = j + 1;
    end
   end
end
outputdir =  ['GeneExpression/2015-06-01/Output/GeneExpression_'];
dlmwrite([outputdir, 'results.csv'], results, 'delimiter', ',', 'precision', 9 )
