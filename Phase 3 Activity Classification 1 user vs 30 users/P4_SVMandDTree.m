jj=sum(partition(1:0.6*length(partition)))/20;

train_data = score(1:jj,1:10);
train_data_label = A1_label(1:jj,1);

%test_data = score(1+0.6*length(score):length(score),:);
%test_data_label = A1_label(1+0.6*length(A1_label):length(A1_label),:);

test_data = [];
test_data_label = [];

DtreeRecallPrecisionMatrix  = [];
SvmRecallPrecisionMatrix  = [];
svm_model =  fitcsvm(train_data,train_data_label);
tree_model = fitctree(train_data,train_data_label);

view(tree_model,'mode','graph');

for itr=1+0.6*length(partition):length(partition)
    
    test_data = [test_data;score(jj+1:jj+partition(itr)/20,1:10)];
    %test_data = [test_data;score(jj + 1 + (partition(itr)*0.8/20): jj + partition(itr)/20,1:10)];
    
    test_data_label = [test_data_label;A1_label(jj+1:jj+partition(itr)/20,1)];
    %test_data_label = [test_data_label;score(jj + 1+partition(itr)*0.8/20:jj + partition(itr)/20,11)];
    
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
        Accuracy = [Accuracy; (TP+TN)/(TP+TN+FP+FN)];
        tempRow = [Recall,Precision,F_score,Accuracy];
        if k == 1
            DtreeRecallPrecisionMatrix  = [DtreeRecallPrecisionMatrix ;tempRow];
        else
            SvmRecallPrecisionMatrix  = [SvmRecallPrecisionMatrix ;tempRow];
        end
        
        
        
        
    end
    jj = jj + partition(itr)/20;
end
xlswrite("DtreeRecallPrecisionMatrix",DtreeRecallPrecisionMatrix);
xlswrite("SvmRecallPrecisionMatrix",SvmRecallPrecisionMatrix);