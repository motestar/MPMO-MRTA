
function [brk, rte] = nnh3(N, dmat,amount, robot_a, robot_b, a_cnt, rs ,v_salesmen, v, fai, kesai)   

    pop = 1 : 1 : N + 1;
    f = zeros(1, N);
    remain_pos = pop;
    remain_pos(1) = [];

    
    dis = zeros(1,N); 
    for i = 1 : N
        dis(i) = dmat(1,remain_pos(i));
    end
    
    pos = find(dis == min(dis));
    pos = min(pos);
    point = remain_pos(pos);
    f(1) = point;
    remain_pos(pos) = [];
      
    for i = 2 : N        
        dis = zeros(1,N+1-i); 
        for j = 1 : (N+1-i)
            dis(j) = dmat(f(i-1),remain_pos(j));
        end
        pos = find(dis == min(dis));
        pos = min(pos);
        point = remain_pos(pos);
        
         f(i) = point;
        remain_pos(pos) = [];       
    end
    [brk, rte] = creatonebrk(f, dmat,amount, robot_a, robot_b, a_cnt, rs ,v_salesmen, v, fai, kesai);
end