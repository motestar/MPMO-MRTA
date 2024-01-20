
function [ EP, EPval] = Oinsert( ci,pop,popval, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,N,kesai)

EP = pop; EPval = popval;
for ii = 1 : ci
    
    popsize = size(popval,1);
    EA = pop;  EAval = popval;
    for i = 1 : popsize
        list = pop(i).solution; fdis = pop(i).f1; ftime = pop(i).f2; fres = pop(i).fa;
        fits = fdis + ftime;
       
        Pop = []; val = [];
        tempfits = sort(fits); best_robot = find(fits == tempfits(1)); worst_robot = find(fits == tempfits(rs));
        best_robot = best_robot(1); worst_robot = worst_robot(1);
        best_seq = list{best_robot}; worst_seq = list{worst_robot};
        be_len = length(best_seq);  wor_len = length(worst_seq);
        
        tt = rs - 1;
        while wor_len == 1
            worst_robot = find(fits == tempfits(tt));
            tt = tt - 1;
            worst_seq = list{worst_robot(1)};
            wor_len = length(worst_seq);
        end
        if worst_robot == best_robot
            break;
        end
        
        j = randperm(wor_len, 1);
      
        templist = list; tempfdis = fdis;  tempftime = ftime; tempworst_seq = worst_seq;
        
        remove_job = worst_seq(j);
      
        tempworst_seq(j) = [];
        templist{worst_robot(1)} = tempworst_seq;
        [a,b] = oneseqval(tempworst_seq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
        tempfdis(worst_robot(1)) = a;
        tempftime(worst_robot(1)) = b;

        for k = 1 : (be_len+1)
            temseq = [best_seq(1:k-1) remove_job best_seq(k:end)];
            templist{best_robot} = temseq;
            [a,b] = oneseqval(temseq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
            tempfdis(best_robot) = a; tempftime(best_robot) = b;
            tempop.solution = templist; tempop.f1 = tempfdis;  tempop.f2 = tempftime;
            tempop.fa = [sum(tempfdis),max(tempftime)]; tempop.fsum = sum(tempop.fa);
            Pop = [Pop;tempop]; val = [val;tempop.fa];
        end
        EA = [EA;Pop];
        EAval = [EAval;val];
    end

    EAsize = size(EA,1);
    EAval = deterdomination(EAval, EAsize, M, 0);
    pop = [];
    popval = [];
    for i = 1 : EAsize
        if(EAval(i, M + 1) == 1)
            pop = [pop;EA(i,:)];
            popval = [popval;EAval(i,1:M)];
        end
    end

    id = Removerepetition(pop,N,rs);
    pop = pop(sort(id),:);
    popval = popval(sort(id),:);

    EP = [EP;pop];
    EPval = [EPval;popval];
end

end

