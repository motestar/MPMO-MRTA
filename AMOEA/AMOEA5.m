
function EPval = AMOEA5(da,rs,pop_size,Pc,CCN_NUM,rep)
N = size(da,2) - 1;
dmat = da(1:N+1,:);
amount = da(N+2,:);
num1 = da(end,1);
amount = amount';
%% 参数设置
% rs = 6; 
tmax = 0.5*N*rs;
robot_a = 50; 
robot_b = 50; 
vrobot = 1;   
v1 = 1; 
fai = 1; 
kesai = 1.5; 
min_tour = 1; 
% pop_size = 60; 
M = 2;         
% Pc = 0.8;      
CCN = 0; 
% CCN_NUM = 4;
EP=[];        
EPval = []; 
num_brks = rs - 1; 
ci = 10;
cii = 5;
a = 1;
% rand('seed', 2020+rep);
tic;
%% 种群初始化
pop_rte = zeros(pop_size, N);          
pop_brk = zeros(pop_size, num_brks);   

[pop_brk(1, :), pop_rte(1, :)] = nnh3(N, dmat,amount, robot_a, robot_b, num1, rs ,vrobot, v1, fai, kesai);
for k = 2 : pop_size
    pop_rte(k, :) = randperm(N) + 1;  % 2 ：N + 1
end 

[brk,rte] = creatonebrk(pop_rte(2:end,:), dmat,amount, robot_a, robot_b, num1, rs,vrobot, v1, fai, kesai);
pop_rte(2:end,:) = rte;
pop_brk(2:end,:) = brk;

Pop = CreateEmptyPopSet(pop_size);

val = zeros(pop_size,M); 
for k = 1 : pop_size
    [list,fdis,ftime,fa,fsum] = objective_value(amount, robot_a, robot_b, num1, 1, pop_rte(k,:), pop_brk(k,:), rs, dmat, vrobot, N,v1,fai,kesai);
    Pop(k).solution = list;
    Pop(k).f1 = fdis;
    Pop(k).f2 = ftime;
    Pop(k).fa = fa; 
    Pop(k).fsum = fsum; 
    val(k,:) = fa;
end

for i = 1 : M
    z(i) = min(val(:,i));
end

val = deterdomination(val, pop_size, M, 0);

for i = 1 : pop_size
    if(val(i, M + 1) == 1)
        EP = [EP;Pop(i)];
        EPval = [EPval;val(i,1:M)];
    end
end
curEP = [];
while toc < tmax
    %% 对种群执行进化操作
    pop_size = size(Pop,1);
    nextPop = [];nextPopval = [];
    for i = 1 : pop_size
        sPop = Pop(i,:);
        if rand < Pc
            [nPop,nPopval] = Crossover(EP,sPop,N,amount,robot_a,robot_b,num1, rs, dmat, vrobot,v1,fai,kesai);
        else
            [nPop,nPopval] = Mutation(sPop,N,amount,robot_a,robot_b,num1, rs, dmat, vrobot,v1,fai,kesai);
        end
        nextPop = [nextPop;nPop];
        nextPopval = [nextPopval; nPopval];
    end
    
    nextPop = [nextPop;Pop];
    nextPopval = [nextPopval;val(:,1:M)];
    id = Removerepetition(nextPop,N,rs);
    nextPop = nextPop(sort(id),:);
    nextPopval = nextPopval(sort(id),:);
    nextPopvalsize = size(nextPopval,1);
    tem = zeros(nextPopvalsize,3);
    for i = 1 : nextPopvalsize
         tem(i,:) = [i,nextPopval(i,:)];
    end
    nextPopval = tem;
    nextPopval = fast_non_dominated_sort(nextPopval, M, 1,nextPopvalsize);
    
    LPop = [];
    LPopval = [];
    ikun = 1;
    while(ikun <= nextPopvalsize && nextPopval(ikun, M + 2) <= a)
        flag = nextPopval(ikun,1);
        LPop = [LPop;nextPop(flag,:)];
        LPopval = [LPopval;nextPopval(ikun,2:M+1)];
        ikun = ikun + 1;
    end
  
    TemnextPopval = eliteselect(pop_size,nextPop,nextPopval);
    seq = TemnextPopval(1:end,1);
    nextPop =nextPop(seq,:);
    nextPopval = TemnextPopval(1:pop_size,2:M+1); 
   
    EP1 = [EP;LPop];
    EP1val = [EPval;LPopval];
    EP1val_size = size(EP1val,1);
  
    for i = 1:M
        zmin = min(EP1val(:,i));
        if (zmin < z(i))
            z(i) = zmin;
        end
    end
    EP1val = deterdomination(EP1val, EP1val_size, M, 0);
    
    EPP = [];
    EPPval = [];
    for i = 1 : EP1val_size
        if(EP1val(i, M + 1) == 1)
            EPP = [EPP;EP1(i,:)];
            EPPval = [EPPval;EP1val(i,1:M)];
        end
    end
    
    %% 局部搜索操作
    [EP2,EP2_val] = LS(ci,LPop,LPopval, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,N,kesai);
   
    nextPop = [nextPop;EP2];
    nextPopval = [nextPopval;EP2_val];
   
    id = Removerepetition(nextPop,N,rs);
    nextPop = nextPop(sort(id),:);
    nextPopval = nextPopval(sort(id),:);
    
    nextPopvalsize = size(nextPopval,1);
    tem = zeros(nextPopvalsize,3);
    for i = 1 : nextPopvalsize
         tem(i,:) = [i,nextPopval(i,:)];
    end
    nextPopval = tem;
    nextPopval = fast_non_dominated_sort(nextPopval, M, 1,nextPopvalsize);
   
    EPPPop = [];
    EPPPopval = []; 
    ikun = 1;
    while(ikun <= nextPopvalsize && nextPopval(ikun, M + 2) == 1)
        flag = nextPopval(ikun,1);
        EPPPop = [EPPPop;nextPop(flag,:)];
        EPPPopval = [EPPPopval;nextPopval(ikun,2:M+1)];
        ikun = ikun + 1;
    end
   
    TemnextPopval = eliteselect(pop_size,nextPop,nextPopval);
    seq = TemnextPopval(1:end,1);
    nextPop =nextPop(seq,:);
    nextPopval = TemnextPopval(1:pop_size,2:M+1); 

    EPP = [EPP;EPPPop];
    EPPval= [EPPval;EPPPopval];
    EPPval_size = size(EPPval,1);

    for i = 1 : M
        zmin = min(EPPval(:,i));
        if zmin < z(i)
            z(i) = zmin;
        end
    end 
    EPPval = deterdomination(EPPval, EPPval_size, M, 0);

    EPPP = [];
    EPPPval = [];
    for i = 1 : EPPval_size
        if(EPPval(i, M + 1) == 1)
            EPPP = [EPPP;EPP(i,:)];
            EPPPval = [EPPPval;EPPval(i,1:M)];
        end
    end
    id = Removerepetition(EPPP,N,rs);
    EPPP = EPPP(sort(id),:);
    EPPPval = EPPPval(sort(id),:);
    
    Pop = nextPop;
    val = nextPopval;
    EP = EPPP;
    EPval = EPPPval;
    %% 重启策略
    len1 = size(curEP,1);
    len2 = size(EP,1);
    if len1 == len2
        c = judge(curEP,EP,rs);
        if c == 1
            CCN =  CCN + 1;
            if CCN == CCN_NUM 
                [Pop,val,EA,EAval] = restart3(cii, z, N, Pop,val, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,kesai);
                CCN = 0;
            
                EPP = [EP;EA];
                EPPval= [EPval;EAval];
                EPPval_size = size(EPPval,1);
          
                for i = 1 : M
                    zmin = min(EPPval(:,i));
                    if zmin < z(i)
                        z(i) = zmin;
                    end
                end
                EPPval = deterdomination(EPPval, EPPval_size, M, 0);
          
                EP = [];
                EPval = [];
                for i = 1 : EPPval_size
                    if(EPPval(i, M + 1) == 1)
                        EP = [EP;EPP(i,:)];
                        EPval = [EPval;EPPval(i,1:M)];
                    end
                end
                id = Removerepetition(EP,N,rs);
                EP = EP(sort(id),:);
                EPval = EPval(sort(id),:);
            end
        end
    else
        CCN = 0;
    end
    curEP = EP;
end

[~,id3] = unique(EPval, 'rows');
EPval = EPval(sort(id3), :);
end