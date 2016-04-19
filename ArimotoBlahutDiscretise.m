function [ Cbias, Clinear ] = ArimotoBlahutDiscretise( response, binsnumbers, K, Iteration, Tollerance, directory, delimeter )
%% ArimotoBlahutDiscretise 
%   Detailed explanation goes here
%% Input
% response - macierz danych
% binsnumbers 
% -- K -- /in /[0, 1/] -- percentage of data used in jackknife algorithm
% Iteration
% Tollerance
% directory
%% Output
% Cbias
% Clinear
%%

%% Pre-processing

Cbias   = cell(1, size(binsnumbers, 2));
Ksize   = cell(1, size(binsnumbers, 2));
Clinear = cell(1, size(binsnumbers, 2));
binsnumberallerror  = cell(1, size(binsnumbers, 2));
computationtimes = cell(size(binsnumbers, 2), 1);


signalsize = size(response, 2); 
outputsize = size(response, 1);


for bi = 1:size(binsnumbers, 2)
    tic;
    binsnumber = binsnumbers(bi);
    dir = [directory,'/', int2str(binsnumber), '/'];

if ~exist([dir,'/NoResults.csv'])
    %disp(['Done ----- ' int2str(bi) '/' size(binsnumbers, 2) ]);
    disp(['binnumber ' int2str(binsnumbers(bi))]);
       
    sizeinput = size(K, 2);

    Pmatrix = cell(1,sizeinput);
    binsbounds = cell(1,sizeinput);
    binsnumbererror =  cell(1,sizeinput);

    S = cell(1,sizeinput);
    tAB  = cell(1,sizeinput);
    tABEnd  = cell(1,sizeinput);
    C  = cell(1,sizeinput);
    Cbiascell =  cell(1,sizeinput);
    I   = cell(1,sizeinput);
    Q = cell(1,sizeinput);
    W  = cell(1,sizeinput);
    B  = cell(1,sizeinput);
    E = cell(1,sizeinput);
    A  = cell(1,sizeinput);
    number  = cell(1,sizeinput);
    timer  = cell(1,sizeinput);

%% Algorithm  

    mkdir(dir);

    for ki = 1:sizeinput
        binsnumbererror{ki} = false;
    end
       
    parfor ki = 1:sizeinput
         
        %% Disscretisationssvv
        if ~exist([dir,  num2str(K(ki)), '/', 'B.csv'])
            mkdir([dir,  num2str(K(ki)), '/']);
        tic;
        [Pmatrix{ki}, binsbounds{ki}, binsnumbererror{ki}] = discretise(response, K(ki), binsnumber);
        t = toc;
        disp(['Discretisation time ',num2str(t)]); 
        if ~binsnumbererror{ki}
            dlmwrite([dir,  num2str(K(ki)), '/K.csv'], K(ki), delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/Pmatrix.csv'], Pmatrix{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/binsbounds.csv'], binsbounds{ki}, delimeter);
    
            %% Arimoto Blahut for discretise data
            S{ki} = ones(1,signalsize) / signalsize;
            tAB{ki} = tic;
            [C{ki},  Q{ki}, ...
             W{ki}, A{ki}, ...
               I{ki},   E{ki}, ...
            timer{ki}, number{ki}, ...
            B{ki}] = ArimotoBlahutAlgorithm(Pmatrix{ki}, S{ki}, Iteration, Tollerance, false);
            tABEnd{ki} = toc(tAB{ki});
            disp(['Arimoto Blahut time ', num2str(tABEnd{ki})]); 
            Cbiascell{ki} =C{ki}{number{ki}};
            tic;
            dlmwrite([dir,  num2str(K(ki)), '/C.csv'], C{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/Q.csv'], Q{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/W.csv'], W{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/A.csv'], A{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/I.csv'], I{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/E.csv'], E{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/number.csv'], number{ki}, delimeter);
            dlmwrite([dir,  num2str(K(ki)), '/B.csv'], B{ki}, delimeter);
            t = toc();
            disp(['Witing to file time ',num2str(t)]); 
        else 
            C{ki} = dlmwrite([dir,  num2str(K(ki)), '/C.csv'], delimeter);
            Q{ki} = dlmread([dir,  num2str(K(ki)), '/Q.csv'],  delimeter);
            W{ki} = dlmread([dir,  num2str(K(ki)), '/W.csv'],  delimeter);
            A{ki} = dlmread([dir,  num2str(K(ki)), '/A.csv'], delimeter);
            I{ki} = dlmread([dir,  num2str(K(ki)), '/I.csv'], delimeter);
            E{ki}  = dlmread([dir,  num2str(K(ki)), '/E.csv'], delimeter);
            number{ki} = dlmread([dir,  num2str(K(ki)), '/number.csv'], delimeter);
            B{ki} = dlmread([dir,  num2str(K(ki)), '/B.csv'], delimeter);
        end
        end;
    end;
    
    %disp(cell2mat(binsnumbererror));
    dlmwrite([dir, 'outofrange.csv'], binsnumbererror, delimeter);
    binsnumberallerror{bi} =  sum(cell2mat(binsnumbererror)) == sizeinput;
    %dlmwrite([dir, 'Koutofrange.csv'], (~cell2mat(binsnumbererror)), delimeter);
    Cbias{bi} = cell2mat(Cbiascell);

    dlmwrite([dir, 'Cbias.csv'], Cbias{bi}, delimeter);
    dlmwrite([dir, 'NoResults.csv'], binsnumberallerror{bi}, delimeter);

    if ~binsnumberallerror{bi}
    
        Ksize{bi} = 1./round(K(~cell2mat(binsnumbererror)).*outputsize);
        Clinear{bi} = polyfit(Ksize{bi}, Cbias{bi}, 1); 
    
        dlmwrite([dir, 'binsnumber.csv'], binsnumber, delimeter);
        
        dlmwrite([dir, 'Clinear.csv'], Clinear{bi}, delimeter);
        dlmwrite([dir, 'Ksize.csv'], Ksize{bi}, delimeter);
    end
    
    
end;

    computationtimes{bi} = [binsnumber, toc];
    if ~exist([dir, 'computations.csv'])
        dlmwrite([dir, 'computations.csv'], cell2mat(computationtimes), delimeter);
    disp(['Computation time ', num2str(computationtimes{bi})]);
end;
end

