
function [ pop,popval,EP,EPval] = Iexchange2(z,ci, pop,popval, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai ,kesai)

EP = []; EPval = [];
for ii = 1 : ci
    
    pop_size = size(popval,1);
    EA = pop; EAval = popval;
    for i = 1 : pop_size
        
        Pop = []; val = [];
        list = pop(i).solution;fdis = pop(i).f1;ftime = pop(i).f2;
        fres = pop(i).fa;
        fits = fdis + ftime;
        
        tempfits = sort(ftime);
        worst_robot = find(ftime == tempfits(rs));
        j = worst_robot(1);
        
        templist = list; tempfdis = fdis; tempftime = ftime;
        
        jobseq = list{j};
        ro_len = length(jobseq);
        pos = randperm(ro_len,1);
        job = jobseq(pos);
        for k = 1 : ro_len
            if k == pos
                continue;
            end
            tempseq = jobseq;
            t = tempseq(k);
            tempseq(k) = job;
            tempseq(pos) = t;
            templist{j} = tempseq;
            [a,b] = oneseqval(tempseq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai);
            tempfdis(j) = a; tempftime(j) = b;
            tempop.solution = templist; tempop.f1 = tempfdis; tempop.f2 = tempftime;
            tempop.fa = [sum(tempfdis),max(tempftime)];tempop.fsum = sum(tempop.fa);
            Pop = [Pop;tempop];
            val = [val;tempop.fa];
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