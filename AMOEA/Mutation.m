
function [pop,val] = Mutation(sPop,N,amount,robot_a,robot_b,num1, rs, dmat, vrobot ,v1,fai,kesai)
    ind = randperm(4,1);
    if (ind == 1)
       [pop, val] = MIswap( sPop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai);
    end
    if (ind == 2)
        [pop, val] = MOswap( sPop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai);
    end
    if (ind == 3)
        [pop, val] = MIinsert( sPop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N ,v1,fai,kesai);
    end
    if (ind == 4)
        [pop, val] = MOinsert(sPop, rs ,amount,robot_a,robot_b,num1,dmat,vrobot,N,v1,fai,kesai);
    end
    
    
    
end