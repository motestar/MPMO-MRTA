clc;
clear;
% addpath('Testdata\');
fullpath = mfilename('fullpath');
[path,name]=fileparts(fullpath);
FileName = [path,'\Mapdata\'];

ResFolder=[path,'\result\']; 
if exist(ResFolder) == 0 
    mkdir(ResFolder); 
end
for N = [40 50 60 70 80 100]
    for num = 1 : 10
        TxtFileName = [FileName, 'N',num2str(N),'\N',num2str(N),'_',num2str(num),'.txt'];
        da = load(TxtFileName);
        for rs = [4 5 6 7] 
            ResTxtFolder = [ResFolder,'N',num2str(N),'_','rs',num2str(rs)];
            if exist(ResTxtFolder) == 0  
                mkdir(ResTxtFolder);
            end
            for repeat = 1 : 20 
                pareto = AMOEA5(da,rs,40,0.9,10,repeat);
                ResTxtName1 = [ResTxtFolder,'\N',num2str(N),'_',num2str(num),'_rs',num2str(rs),'_',num2str(repeat) '.txt'];
                dlmwrite(ResTxtName1,pareto,'delimiter',' ');
            end
        end
    end
end
