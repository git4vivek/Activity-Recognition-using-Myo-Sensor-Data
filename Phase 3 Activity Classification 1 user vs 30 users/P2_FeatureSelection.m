jj=0;
A1=[];
A1_label = [];
sampled_data = [];
for itr=1:20:length(combined_matrix)
    sampled_data = [];
    sampled_data=combined_matrix(itr:itr+19,1:10);
    A1=[A1;mean(sampled_data),rms(sampled_data),max(sampled_data),var(sampled_data),var(fft(sampled_data))];
    A1_label = [A1_label;combined_matrix(itr,11)];
end

X_norm=[];
A_normailzed_final=[];
for i = 1:size(A1,2)
    X_norm= A1(:,i);
    X_norm = (X_norm-min(X_norm))/(max(X_norm)-min(X_norm));
    A_normailzed_final = [A_normailzed_final, X_norm];
    X_norm=[];
end