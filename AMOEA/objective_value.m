
function [list,f1,f2,fa,fsum] = objective_value(amount,robot_a, robot_b,num1, pop_size, pop_rte, pop_brk, salesmen, dmat, v_salesmen, n,v1,fai,kesai)
   
    for p = 1:pop_size
        time = zeros(salesmen,1); 
        dis = zeros(salesmen,1); 
        p_rte = pop_rte(p,:);
        p_brk = pop_brk(p,:);
        rng = [[1 p_brk+1];[p_brk n]]';
        for s = 1:salesmen
            t = 0;
            d = 0;
            margin_a = robot_a; 
            margin_b = robot_b;        
            d = d + dmat(1,p_rte(rng(s,1))); 
            t = t + fai*amount(p_rte(rng(s,1)), 1) + dmat(1,p_rte(rng(s,1)))/v_salesmen;
            if p_rte(rng(s,1)) <= (num1 + 1)
                margin_a =  margin_a - amount(p_rte(rng(s,1)), 1);
            else
                margin_b =  margin_b - amount(p_rte(rng(s,1)), 1);
            end
            
            
            for k = (rng(s,1) + 1) : rng(s,2)
                if p_rte(k) <= (num1 + 1) 
                    if margin_a - amount(p_rte(k), 1) >= 0
                        margin_a = margin_a - amount(p_rte(k), 1);
                        d = d + dmat(p_rte(k - 1),p_rte(k));
                        t = t + fai*amount(p_rte(k),1)+ dmat(p_rte(k - 1),p_rte(k))/v_salesmen;
                    else 
                        temt = kesai*(robot_a-margin_a+robot_b-margin_b);
                        margin_a = robot_a - amount(p_rte(k), 1);
                        margin_b = robot_b;
                        d = d + dmat(p_rte(k - 1),1) + dmat(1, p_rte(k));
                        t = t + temt + fai*amount(p_rte(k),1)+ dmat(p_rte(k - 1),1)/v1+ dmat(1, p_rte(k))/v_salesmen;
                    end
                else 
                    if margin_b - amount(p_rte(k), 1) >= 0
                        margin_b = margin_b - amount(p_rte(k), 1);
                        d = d + dmat(p_rte(k - 1),p_rte(k));
                        t = t + fai*amount(p_rte(k),1)+ dmat(p_rte(k - 1),p_rte(k))/v_salesmen;
                    else 
                        temt = kesai*(robot_a-margin_a+robot_b-margin_b);
                        margin_b = robot_b - amount(p_rte(k), 1);
                        margin_a = robot_a;
                        d = d + dmat(p_rte(k - 1),1) + dmat(1, p_rte(k));
                        t = t + temt + fai*amount(p_rte(k),1)+ dmat(p_rte(k - 1),1)/v1+ dmat(1, p_rte(k))/v_salesmen;
                    end

                end 
                
            end
            d = d + dmat(p_rte(rng(s,2)),1); 
            t = t + dmat(p_rte(rng(s,2)),1) / v1 + kesai*(robot_a-margin_a+robot_b-margin_b);
            time(s,1) = t;
            dis(s,1) = d;
        end
        total_value(p,1) = sum(dis);
        total_value(p,2) = max(time); 
    end

    for id = 1 : salesmen
        list{id} = p_rte(:,rng(id,1):rng(id,2));
    end
    f1 = dis;
    f2 = time;
    fa = total_value;
    fsum = sum(total_value);
end


