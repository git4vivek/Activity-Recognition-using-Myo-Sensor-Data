train_data = [];
test_data = [];
DtreeRecallPrecisionMatrix  = [];
SvmRecallPrecisionMatrix  = [];
train_data_label = [];
test_data_label = [];
jj=0;
for itr=1:length(partition)
    train_data = [train_data;score(jj+1:jj + partition(itr)*0.3/20,1:10)];
    train_data = [train_data;score(jj+1+partition(itr)*0.5/20 : jj + partition(itr)*0.8/20 , 1:10)];
    
    test_data = [test_data;score(jj + 1 + (partition(itr)*0.3/20): jj + (0.5 * partition(itr))/20,1:10)];
    test_data = [test_data;score(jj + 1 + (partition(itr)*0.8/20): jj + partition(itr)/20,1:10)];
    
    train_data_label = [train_data_label;score(jj + 1:jj + partition(itr)*0.3/20,11)];
    train_data_label = [train_data_label;score(jj + 1 + partition(itr)*0.5/20 : jj + partition(itr)*0.8/20,11)];
    
    test_data_label = [test_data_label;score(jj + 1+(partition(itr)*0.3/20) : jj + (0.5 * partition(itr)/20),11)];
    test_data_label = [test_data_label;score(jj + 1+partition(itr)*0.8/20:jj + partition(itr)/20,11)];
    
    jj = jj + partition(itr)/20;
    
    svm_model =  fitcsvm(train_data,train_data_label);
    tree_model = fitctree(train_data,train_data_label);
    svm_fit_data = predict(svm_model,test_data);
    tree_fit_data = predict(tree_model,test_data);
    predictedList = {tree_fit_data,svm_fit_data};
    
    for k = 1:2
        confMat = confusionmat(test_data_label,predictedList{k});
        Accuracy = [];
        recall = [];
        precision = [];
        for j =1:size(confMat,1)
            recall(j)=confMat(j,j)/sum(confMat(j,:));
        end
        
        Recall=sum(recall)/size(confMat,1);
        for j =1:size(confMat,1)
            precision(j)=confMat(j,j)/sum(confMat(:,j));
        end
        
        Precision=sum(precision)/size(confMat,1);
        
        F_score=2*Recall*Precision/(Precision+Recall);
        TP = confMat(1,1);
        TN = confMat(2,2);
        FP = confMat(1,2);
        FN = confMat(2,1);
        
        %         Precision = [Precision ; TP / (TP + FP )];
        %         Recall = [Recall ; TP / ( TP + FN )];
        %         F1= [F1;2*TP/(2*TP+FP+FN)];
        Accuracy = [Accuracy; 100*(TP+TN)/(TP+TN+FP+FN)];
        tempRow = [Recall,Precision,F_score,Accuracy];        
        if k == 1
            DtreeRecallPrecisionMatrix  = [DtreeRecallPrecisionMatrix ;tempRow];
        else
            SvmRecallPrecisionMatrix  = [SvmRecallPrecisionMatrix ;tempRow];
        end
    end
end

view(tree_model,'mode','graph');

xlswrite("DtreeRecallPrecisionMatrix",DtreeRecallPrecisionMatrix);
xlswrite("SvmRecallPrecisionMatrix",SvmRecallPrecisionMatrix);