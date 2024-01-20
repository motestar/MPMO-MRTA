
function [d,t] = oneseqval( p_rte,amount,robot_a, robot_b,num1, dmat, v_salesmen,v1,fai,kesai)
    t = 0;
    d = 0;
    num = size(p_rte,2); 
    margin_a = robot_a; 
    margin_b = robot_b; 
    d = d + dmat(1,p_rte(1)); 
    t = t + fai*amount(p_rte(1), 1)+ dmat(1,p_rte(1))/v_salesmen;
    if p_rte(1) <= (num1 + 1)
        margin_a =  margin_a - amount(p_rte(1), 1);
    else
        margin_b =  margin_b - amount(p_rte(1), 1);
    end


    for k = 2 : num
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
                t = t + temt + fai*amount(p_rte(k),1) + dmat(p_rte(k - 1),1)/v1 + dmat(1, p_rte(k))/v_salesmen;
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
                t = t+ temt + fai*amount(p_rte(k),1) + dmat(p_rte(k - 1),1)/v1 + dmat(1, p_rte(k))/v_salesmen;
            end
        end
        
    end
    d = d + dmat(p_rte(num),1); 
    t = t + dmat(p_rte(num),1)/v1 + kesai*(robot_a-margin_a+robot_b-margin_b);     
end

