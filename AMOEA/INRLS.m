
function [pop,pop_val, EA1, FVal] = INRLS(N, z, EP, pop, pop_size, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,kesai )
    
    z1 = z(1);
    z2 = z(2);
    num = size(EP,1); 
    EA = []; 
    EAval = [];
    pop_val = zeros(pop_size,M); 
    for i = 1 : pop_size
        
        Pop = [];
        val = [];
        list = pop(i).solution;
        fdis = pop(i).f1;
        ftime = pop(i).f2;
        fres = pop(i).fa; 
        fval = pop(i).fsum; 
        fits = fdis + ftime;
        pop_val(i,:) = fres;
        dcur = ((fres(1) - z1)^2 + (fres(2) - z2)^2)^0.5;
        
        tempfits = sort(fits);
        best_robot = find(fits == tempfits(1));        
        worst_robot = find(fits == tempfits(rs)); 
        best_robot = best_robot(1);
        worst_robot = worst_robot(1);
        best_seq = list{best_robot};
        worst_seq = list{worst_robot};       
        be_len = length(best_seq);
        wor_len = length(worst_seq);
        
        tt = rs - 1;
        while wor_len == 1
            worst_robot = find(fits == tempfits(tt));
            tt = tt - 1;
            worst_seq = list{worst_robot(1)}; 
            wor_len = length(worst_seq);
        end
        
        if worst_robot == best_robot
            continue;
        end

        for j = 1 : wor_len
            templist = list;
            tempfdis = fdis;
            tempftime = ftime;

            tempworst_seq = worst_seq;
            remove_job = worst_seq(j); 
            
            tempworst_seq(j) = [];
            templist{worst_robot} = tempworst_seq;
            [v1,v2] = oneseqval(tempworst_seq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai);
            tempfdis(worst_robot) = v1;
            tempftime(worst_robot) = v2;
                 
            for k = 1 : (be_len+1)
                temseq = [best_seq(1:k-1) remove_job best_seq(k:end)];
                templist{best_robot} = temseq;
                [v1,v2] = oneseqval(temseq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
                tempfdis(best_robot) = v1;
                tempftime(best_robot) = v2;
                tempop.solution = templist;
                tempop.f1 = tempfdis;
                tempop.f2 = tempftime;
                tempop.fa = [sum(tempfdis),max(tempftime)];
                tempop.fsum = sum(tempop.fa);
                Pop = [Pop;tempop];
                val = [val;tempop.fa];
            end           
        end
        EA = [EA;Pop];
        EAval = [EAval;val];

        Pop_size = size(Pop,1);

        newz = zeros(Pop_size,1);
        for kk = 1 : Pop_size
            newz(kk,:) = ((val(kk,1) - z1)^2 + (val(kk,2) - z2)^2)^0.5;
        end
        [dnow,index] = min(newz);
        if dnow < dcur
            pop(i,:) = Pop(index,:); 
            pop_val(i,:) = val(index,:);
        end
        
    end

     EA_size = size(EAval,1);
     EAval = deterdomination(EAval, EA_size, M, 0);
     
     EA1 = [];
     FVal = [];
     for i = 1 : EA_size
         if EAval(i,end) == 1
             EA1 = [EA1;EA(i,:)];
             FVal = [FVal;EAval(i,1:M)];
         end
     end
     
end