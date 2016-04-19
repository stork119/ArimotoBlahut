directoryname  = '2016-04-18/160414_GeneExpression_traj\traj\';
experimentsprefix      = 'traj_ParSet_';
experimentsnumbers = [18 19 27 29 30];

K = 0.6:0.05:0.95;
binsnumbers = 40:40:400;


expnames = cell(max(size(experimentsnumbers)),1);
for i = 1:max(size(experimentsnumbers))
    expnames{i} = [experimentsprefix, num2str(experimentsnumbers(i))];
end

for expi = 1:max(size(expnames))
    expname = expnames{expi};
    directoryinput   = ['Input/',    directoryname];
    directoryoutput = ['Output/', directoryname];
    dirinput = [directoryinput,  expname, '.txt'];
    diroutput = [directoryoutput, expname, '/'];    
    directoryoutputresults = [diroutput, 'results/'];
    

     if ~exist([directoryoutputresults, 'B.csv'])
        expname = expnames{expi};
        ArimotoBlahutRun;
        ArimotoBlahutAnaliseResults;
     end
end