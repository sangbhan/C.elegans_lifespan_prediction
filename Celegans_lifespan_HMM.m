% This program predicts individual's lifespan using early adulthood health data.

formatSpec = '%f';

% open short-lived training data
filename = 'C:\Users\Sangbin\Desktop\Data\short_lived_train.txt';
fileID = fopen(filename,'r');
shortlived_train = fscanf(fileID, formatSpec);
fclose(fileID);

% open normal-lived training data
filename = 'C:\Users\Sangbin\Desktop\Data\normal_lived_train.txt';
fileID = fopen(filename,'r');
normallived_train = fscanf(fileID, formatSpec);
fclose(fileID);

% open long-lived training data
filename = 'C:\Users\Sangbin\Desktop\Data\long_lived_train.txt';
fileID = fopen(filename,'r');
longlived_train = fscanf(fileID, formatSpec);
fclose(fileID);

STATE_NUM = 1:7;
EMISSION_NUM = 27;

maxiter = 1000;
tol = 1e-6;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f';

% open short-lived test data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\short_lived_test_accuracy.txt';
shortlived_test_a = table2array(readtable(filename, 'Format', formatSpec));
shortlived_test_accuracy = zeros(1, 7);

% open short-lived training data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\short_lived_train_accuracy.txt';
shortlived_train_a = table2array(readtable(filename,'Format', formatSpec));
shortlived_train_accuracy = zeros(1, 7);

% open normal-lived test data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\normal_lived_test_accuracy.txt';
normallived_test_a = table2array(readtable(filename, 'Format', formatSpec));
normallived_test_accuracy = zeros(1, 7);

% open normal-lived training data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\normal_lived_train_accuracy.txt';
normallived_train_a = table2array(readtable(filename,'Format', formatSpec));
normallived_train_accuracy = zeros(1, 7);

% open long-lived test data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\long_lived_test_accuracy.txt';
longlived_test_a = table2array(readtable(filename, 'Format', formatSpec));
longlived_test_accuracy = zeros(1, 7);

% open long-lived training data for accuracy calculation
filename = 'C:\Users\Sangbin\Desktop\Data\long_lived_train_accuracy.txt';
longlived_train_a = table2array(readtable(filename,'Format', formatSpec));
longlived_train_accuracy = zeros(1, 7);

for j = 1:7

    TRANS_INIT = ones(STATE_NUM(j), STATE_NUM(j))/STATE_NUM(j);
    EMIS_INIT = ones(STATE_NUM(j), EMISSION_NUM)/EMISSION_NUM;
    PSEUDOE = ones(STATE_NUM(j), EMISSION_NUM)/1e-4;
    PSEUDOTR = ones(STATE_NUM(j), STATE_NUM(j))/1e-4;
    
    [TRANS_short, EMIS_short] = hmmtrain(shortlived_train, TRANS_INIT, EMIS_INIT, 'tolerance', tol, 'maxiterations', maxiter);
    [TRANS_normal, EMIS_normal] = hmmtrain(normallived_train, TRANS_INIT, EMIS_INIT, 'tolerance', tol, 'maxiterations', maxiter);
    [TRANS_long, EMIS_long] = hmmtrain(longlived_train, TRANS_INIT, EMIS_INIT, 'tolerance', tol, 'maxiterations', maxiter);
    
    for i = 1:size(shortlived_train_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(shortlived_train_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(shortlived_train_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(shortlived_train_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 1

            shortlived_train_accuracy(j) = shortlived_train_accuracy(j) + 1;

        end

    end

    shortlived_train_accuracy(j) = shortlived_train_accuracy(j) / size(shortlived_train_a, 1);

    for i = 1:size(shortlived_test_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(shortlived_test_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(shortlived_test_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(shortlived_test_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 1

            shortlived_test_accuracy(j) = shortlived_test_accuracy(j) + 1;

        end

    end

    shortlived_test_accuracy(j) = shortlived_test_accuracy(j) / size(shortlived_test_a, 1);

    for i = 1:size(normallived_train_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(normallived_train_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(normallived_train_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(normallived_train_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 2

            normallived_train_accuracy(j) = normallived_train_accuracy(j) + 1;

        end

    end

    normallived_train_accuracy(j) = normallived_train_accuracy(j) / size(normallived_train_a, 1);

    for i = 1:size(normallived_test_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(normallived_test_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(normallived_test_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(normallived_test_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 2

            normallived_test_accuracy(j) = normallived_test_accuracy(j) + 1;

        end

    end

    normallived_test_accuracy(j) = normallived_test_accuracy(j) / size(normallived_test_a, 1);

    for i = 1:size(longlived_train_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(longlived_train_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(longlived_train_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(longlived_train_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 3

            longlived_train_accuracy(j) = longlived_train_accuracy(j) + 1;

        end

    end

    longlived_train_accuracy(j) = longlived_train_accuracy(j) / size(longlived_train_a, 1);

    for i = 1:size(longlived_test_a, 1)

        logpseq = [0 0 0];
        [PSTATES, logpseq(1)] = hmmdecode(longlived_test_a(i, :), TRANS_short, EMIS_short);
        [PSTATES, logpseq(2)] = hmmdecode(longlived_test_a(i, :), TRANS_normal, EMIS_normal);
        [PSTATES, logpseq(3)] = hmmdecode(longlived_test_a(i, :), TRANS_long, EMIS_long);
        [M, A] = max(logpseq);

        if A == 3

            longlived_test_accuracy(j) = longlived_test_accuracy(j) + 1;

        end

    end

    disp(logpseq)
    
    longlived_test_accuracy(j) = longlived_test_accuracy(j) / size(longlived_test_a, 1);

end

plot(1:7, shortlived_train_accuracy, '-v', 1:7, shortlived_test_accuracy, '->', 1:7, normallived_train_accuracy, '-<', 1:7, normallived_test_accuracy, '-s', 1:7, longlived_train_accuracy, '-^', 1:7, longlived_test_accuracy, '-o')
legend('short-lived training accuracy', 'short-lived test accuracy', 'normal-lived training accuracy', 'normal-lived test accuracy', 'long-lived training accuracy', 'long-lived test accuracy')