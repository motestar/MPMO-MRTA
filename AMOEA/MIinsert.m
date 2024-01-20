 
function [child,fa] = MIinsert(pop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai)
    list =pop.solution;
    in_r = randperm(rs,1);
    while length(list{in_r}) == 1
        in_r = randperm(rs,1);
    end
    seq = list{in_r};
    num = length(seq);
    p = randperm(num,1);
    job = seq(p);
    templist = list;
    tempfdis = pop.f1;
    tempftime = pop.f2;
    temseq = seq;
    temseq(p) = [];
    Pop = []; val = [];
    for i = 1 : num
        seq1 = [temseq(1:i-1) job temseq(i:end)];
        templist{in_r} = seq1;
       
        [a,b] = oneseqval(seq1,amount,robot_a, robot_b,num1, dmat, vrobot,v1,fai,kesai); 
        tempfdis(in_r) = a;
        tempftime(in_r) = b;
        tempop.solution = templist;
        tempop.f1 = tempfdis;
        tempop.f2 = tempftime;
        tempop.fa = [sum(tempfdis),max(tempftime)];
        tempop.fsum = sum(tempop.fa);
        Pop = [Pop;tempop];
        val = [val;tempop.fa];
    end
    
    val = deterdomination(val, size(val,1), 2, 0);
    
    for i = 1 : size(val,1)
        if(val(i, 2 + 1) == 1)
            child = Pop(i,:);
            fa = val(i,1:2);
            break;
        end 
    end
    
end

