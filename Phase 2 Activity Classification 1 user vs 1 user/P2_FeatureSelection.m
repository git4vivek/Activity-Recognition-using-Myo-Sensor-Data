jj=0;
A1=[];
for itr=1:length(partition)
    x=combined_matrix(jj+1:jj+partition(itr),:);
    A11=[];
    for itrx=1:20:partition(itr)
        sampled_data=x(itrx:itrx+19,1:10);
        A11=[A11;mean(sampled_data),rms(sampled_data),max(sampled_data),var(sampled_data),var(fft(sampled_data))];
    end
    
    A1=[A1;A11];
    jj=jj+partition(itr);
    disp(jj);
end

X_norm=[];
% A_selected= A(:,[3 6 9 47 55 63 94 96 127 144]);
A_normailzed_final=[];
for i = 1:size(A1,2)
    X_norm= A1(:,i);
    % min(X_norm);
    % max(X_norm);
    X_norm = (X_norm-min(X_norm))/(max(X_norm)-min(X_norm));
    A_normailzed_final = [A_normailzed_final, X_norm];
    X_norm=[];
end


