Precision=[];
Recall=[];
Accuracy=[];
F1=[];
jj=sum(partition(1:0.6*length(partition)))/20;
train_data = score(1:jj,:);
train_data_label = A1_label(1:jj,:);

for itr=1+0.6*length(partition):length(partition)
    user_data = [];
    user_data_label = [];
    
    user_data = [user_data;train_data];
    user_data_label = [user_data_label;train_data_label];
    
    DtreeRecallPrecisionMatrix  = [];
    SvmRecallPrecisionMatrix  = [];
    user_data = [user_data;score(jj+1:jj + partition(itr)/20,1:10)]';
    user_data_label = [user_data_label;A1_label(jj+1:jj + partition(itr)/20,1)]';
    
    hiddenLayer = 15;
    trainFcn = 'trainscg';
    net.performFcn = 'mse';
    net = patternnet(hiddenLayer, trainFcn);
    
    % Setup Division of Data for Training, Validation, Testing
    net.divideParam.trainRatio = 94/100;
    net.divideParam.valRatio = 3/100;
    net.divideParam.testRatio = 3/100;
    
    % Train the Network
    [net,tr] = train(net,user_data,user_data_label);
    
    % Test the Network
    y_output = net(user_data);
%     error_measure = gsubtract(user_data_label,y_output);
%     performance = perform(net,user_data_label,y_output);
%     tind = vec2ind(user_data_label);
%     yind = vec2ind(y_output);
%     percentErrors = sum(tind ~= yind)/numel(tind);
    [cval,cmval,indicat,per] = confusion(user_data_label,y_output);
    TP = cmval(1,1);
    TN = cmval(2,2);
    FP = cmval(1,2);
    FN = cmval(2,1);
    
    Precision = [Precision ; TP / (TP + FP )];
    Recall = [Recall ; TP / ( TP + FN )];
    F1= [F1;2*TP/(2*TP+FP+FN)];
    Accuracy = [Accuracy; (TP+TN)/(TP+TN+FP+FN)];

    jj = jj + partition(itr)/20;
end

xlswrite("PrecisionNN",Precision);
xlswrite("RecallNN",Recall);
xlswrite("F1NN",F1);
xlswrite("AccuracyNN",Accuracy);