files = dir('*.*');
users=[];
GTruth1=[];
GTruth2=[];
combined_matrix=[];
partition =[];

for i=1:length(files)
    if files(i).isdir == 1 && files(i).name == "groundTruth"
        filename = strcat(files(i).folder,'\',files(i).name);
        cd (filename);
        userfolder = dir('*.*');
        % Looping into all users
        for fileitr = 1:length(userfolder)
            if userfolder(fileitr).isdir == 1 && contains(userfolder(fileitr).name,"user")
                if(contains(userfolder(fileitr).name,"user9"))
                    users = [users;"user09"];
                else
                    users = [users;userfolder(fileitr).name];
                end
                forkfolder = strcat(userfolder(fileitr).folder,'\',userfolder(fileitr).name,'\fork');
                disp(forkfolder);
                cd (forkfolder)
                dinfo = dir(forkfolder);
                f = strcat(dinfo(1).folder,'\',dinfo(3).name);
                m = readtable(f);
                format shortG
                gt1 = round(m.Var1*(50/30));
                gt2 = round(m.Var2*(50/30));
                GTruth1 = [GTruth1,gt1(1:25,1)];
                GTruth2 = [GTruth2,gt2(1:25,1)];
                cd ..
                cd ..
                cd ..
            end %if userfolder
        end % for every userfolder in groundtruth
        
    end % if groundtruth folder
end

% GROUND TRUTH ENDS AND MYO STARTS

for i=1:length(files)
    if files(i).isdir == 1 && files(i).name == "MyoData"
        filename = strcat(files(i).folder,'\',files(i).name);
        %         filename = strcat('C:\Users\Vivek Agarwal\Desktop\DM_A1\',files(i).name);
        cd (filename);
        userfolder = dir('*.*');
        % Looping into all users
        userno=1;
        for fileitr = 1:length(users)
            forkfolder = strcat(userfolder(fileitr).folder,'\',users(fileitr,:),'\fork');
            disp(forkfolder);
            cd (forkfolder)
            dinfo1 = dir(forkfolder);
            f1 = strcat(dinfo1(1).folder,'\',dinfo1(4).name);
            disp(f1);
            myo = readtable(f1);
            ind_arr=[];
            eating=[];
            non_eating=[];
            z=1;
            gtt1 = GTruth1(:,userno);
            gtt2 = GTruth2(:,userno);
            for ai = 1:length(gtt1)
                for aj = gtt1(ai):gtt2(ai)
                    ind_arr = [ind_arr;aj];
                    eating(z,1:10) = table2array(myo(aj,2:11));
                    z=z+1;
                end
            end
            roundedsize = min(floor(size(eating,1)/100)*100,1000);
            rr= randperm(roundedsize);
            eating = eating(1:roundedsize,1:end);
            
            z=1;
            for ai = 1:height(myo)
                if z<=1000
                    if ~ismember(ai,ind_arr)
                        non_eating(z,1:10) = table2array(myo(ai,2:11));
                        z=z+1;
                    end
                end
            end
            
            %non_eating = non_eating(rr,1:end);
            combined_peruser=[];
            combined_peruser(:,1:10) = [eating;non_eating];
            combined_peruser(1:roundedsize,11) = 0;
            combined_peruser(roundedsize+1:2*roundedsize,11) = 1;
            combined_matrix = [combined_matrix;combined_peruser];
            partition = [partition; 2*roundedsize];
            cd ..
            cd ..
            cd ..
            userno = userno+1;
            %end
        end
    end
end % for myo and ground truth