
function [ pop,popval,EP,EPval] = Oexchange2(z,ci, pop,popval, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,N,kesai)

EP = []; EPval = [];
for ii = 1 : ci

    pop_size = size(popval,1);
    EA = pop; EAval = popval;
    for i = 1 : pop_size
 
        Pop = []; val = [];
        list = pop(i).solution;fdis = pop(i).f1;ftime = pop(i).f2;
        fres = pop(i).fa;
        for k = 1: 10         
            templist = list; tempfdis = fdis; tempftime = ftime;    
            swap_ro = randperm(rs,2);
            r1 = swap_ro(1); r2 = swap_ro(2);
            seq1 = list{r1}; seq2 = list{r2}; 
            len1 = length(seq1); len2 = length(seq2);
            pos1 = randperm(len1,1); pos2 = randperm(len2,1);
            t = seq1(pos1); seq1(pos1) = seq2(pos2);  seq2(pos2) = t;     
            [dis1,time1] = oneseqval(seq1,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
            [dis2,time2] = oneseqval(seq2,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
            
            templist{r1} = seq1; templist{r2} = seq2; tempfdis(r1) = dis1; 
            tempfdis(r2) = dis2;  tempftime(r1) = time1;   tempftime(r2) = time2;    
            tempop.solution = templist;
            tempop.f1 = tempfdis;   tempop.f2 = tempftime;
            tempop.fa = [sum(tempfdis),max(tempftime)];  tempop.fsum = sum(tempop.fa);
            Pop = [Pop;tempop]; val = [val;tempop.fa];   
        end
        EA = [EA;Pop];
        EAval = [EAval;val];    

        Pop_size = size(Pop,1);

        newz = zeros(Pop_size,1);
        for kk = 1 : Pop_size
            newz(kk,:) = ((val(kk,1) - z(1))^2 + (val(kk,2) - z(2))^2)^0.5;
        end
        [dnow,index] = min(newz);
        pop(i) = Pop(index);
        popval(i,:) = val(index,:);     
    end

    for j = 1 : M
        zmin = min(val(:,j));
        if zmin < z(j)
            z(j) = zmin;
        end
    end

    EAsize = size(EA,1);
    EAval = deterdomination(EAval, EAsize, M, 0);
    EP1 = []; EP1val = [];
    for i = 1 : EAsize
        if(EAval(i, M + 1) == 1)
            EP1 = [EP1;EA(i,:)];
            EP1val = [EP1val;EAval(i,1:M)];
        end
    end

    EP = [EP;EP1];
    EPval = [EPval;EP1val];
end
end