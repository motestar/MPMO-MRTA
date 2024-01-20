
function [child,fa] = MOinsert(pop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai)
    list =pop.solution;
    in_ro = randperm(rs,2); 
    r1 = in_ro(1);
    r2 = in_ro(2);
    seq1 = list{r1};
    seq2 = list{r2}; 
    len1 = length(seq1);
    len2 = length(seq2);

    while len2 == 1
        r2 = randperm(rs,1);
        while r2 == r1
            r2 = randperm(rs,1);
        end
        seq2 = list{r2};
        len2 = length(seq2);
    end
    pos1 = randperm(len1,1);
    pos2 = randperm(len2,1);
    job = seq2(pos2);
    seq2(pos2) = [];
    seq1 = [seq1(:,1:pos1-1) job seq1(:,pos1:end)];
    list{r1}=seq1;
    list{r2}=seq2;
    pop.solution = list;

    pop_rte = TwotoOne( pop,rs );
    [list,fdis,ftime,fa,fsum] = objective_value(amount,robot_a,robot_b,num1,1,pop_rte(:,1:N),pop_rte(:,N+1:end),rs,dmat,vrobot,N,v1,fai,kesai);
    child.solution = list;
    child.f1 = fdis;
    child.f2 = ftime;
    child.fa = fa; 
    child.fsum = fsum; 
end



