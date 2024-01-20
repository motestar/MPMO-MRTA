
function [ child,fa ] = MIswap( pop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai)
    list =pop.solution;
    swap_r = randperm(rs,1);
    while length(list{swap_r}) == 1
        swap_r = randperm(rs,1);
    end
    seq = list{swap_r};
    p = randperm(length(seq), 2);
    t = seq(p(1));
    seq(p(1)) = seq(p(2));
    seq(p(2)) = t;
    list{swap_r} = seq;
    pop.solution = list;
 
    pop_rte = TwotoOne( pop,rs );
    [list,fdis,ftime,fa,fsum] = objective_value(amount,robot_a,robot_b,num1,1,pop_rte(:,1:N),pop_rte(:,N+1:end),rs,dmat,vrobot,N,v1,fai,kesai);
    child.solution = list;
    child.f1 = fdis;
    child.f2 = ftime;
    child.fa = fa; 
    child.fsum = fsum; 
end

