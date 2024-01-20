
function [ pop,pop_val, EA1 ,FVal] = SRLS( z, N, pop, pop_size, M,amount,robot_a,robot_b,num1,rs,dmat,vrobot,v1,fai,kesai)

    z1 = z(1);
    z2 = z(2);
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
      
        for j = 1 : rs
            templist = list;
            tempfdis = fdis;
            tempftime = ftime;
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
                [v1,v2] = oneseqval(tempseq,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai);
                tempfdis(j) = v1;
                tempftime(j) = v2;
                tempop.solution = templist;
                tempop.f1 = tempfdis;
                tempop.f2 = tempftime;
                tempop.fa = [sum(tempfdis),max(tempftime)];
                tempop.fsum = sum(tempop.fa);
                Pop = [Pop;tempop];
                val = [val;tempop.fa];
            end
            
        end     
        for k = 1: N/2
            templist = list;
            tempfdis = fdis;
            tempftime = ftime;
            
            swap_ro = randperm(rs,2); 
            r1 = swap_ro(1);
            r2 = swap_ro(2);
            seq1 = list{r1};
            seq2 = list{r2}; 
            len1 = length(seq1);
            len2 = length(seq2);
            pos1 = randperm(len1,1);
            pos2 = randperm(len2,1); 
            
            t = seq1(pos1);
            seq1(pos1) = seq2(pos2);
            seq2(pos2) = t;
            
            [dis1,time1] = oneseqval(seq1,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai);
            [dis2,time2] = oneseqval(seq2,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
            
            templist{r1} = seq1;
            templist{r2} = seq2;
            tempfdis(r1) = dis1;
            tempfdis(r2) = dis2;
            tempftime(r1) = time1;
            tempftime(r2) = time2;
            
            tempop.solution = templist;
            tempop.f1 = tempfdis;
            tempop.f2 = tempftime;
            tempop.fa = [sum(tempfdis),max(tempftime)];
            tempop.fsum = sum(tempop.fa);
            Pop = [Pop;tempop];
            val = [val;tempop.fa];
            
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
            pop(i) = Pop(index);   
            pop_val(i,:) = val(index,:);
        end
        
    end
    
     EA_size = size(EAval,1);
     EAval = deterdomination(EAval, EA_size, M, 0);
     EA1 = [];
     FVal = [];
     EA_size = size(EAval,1);
     for i = 1 : EA_size
         if EAval(i,end) == 1
             EA1 = [EA1;EA(i,:)];
             FVal = [FVal;EAval(i,1:M)];
         end
     end

     id = Removerepetition(EA1,N,rs);
     EA1 = EA1(sort(id),:);
     FVal = FVal(sort(id),:);
end

