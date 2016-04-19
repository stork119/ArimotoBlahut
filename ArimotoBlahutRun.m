%dirresults = '/results'; 
Iteration = 1000;
Tollerance = 0.05;
delimeter = '\t';


    mkdir([diroutput]);

    data = dlmread(dirinput);
    input   = data(1,:);
    output = data(2:size(data,1), :);

    response = output;
    directory = diroutput;

    [Cbias,  Clinear]  = ArimotoBlahutDiscretise( output, binsnumbers, K, Iteration, Tollerance, diroutput, delimeter );

