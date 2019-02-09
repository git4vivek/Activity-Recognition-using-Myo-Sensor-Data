[coeff,score,latent,tsquared,explained] = pca(A_normailzed_final);
score = score(:,1:10);
jj=0;
for itr=1:length(partition)
    score(jj+1: jj + partition(itr)/40,11)=0;
    score((jj+1+ partition(itr)/40):(jj+(partition(itr)/20)),11)=1;
    jj = jj + partition(itr)/20;
end