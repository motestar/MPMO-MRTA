
function [brk, rte] = creatonebrk(pop, dmat,amount, robot_a, robot_b, a_cnt, rs ,v_salesmen, v, fai, kesai)

[pop_size,N] = size(pop);
num_brks = rs - 1;
rtes = [];
for i = 1 : pop_size

    d = 1;
    route = pop(i,:);
    remain_a = robot_a;
    remain_b = robot_b;
    rotime  = zeros(rs,1); 
    ropoint = cell(rs,1); 
    
    list = {};
    dis = 0;
    cdis = [];
    temp = [];
    ctime = [];
    time = 0;
    point = route(1);
    dis = dis + dmat(1,point);
    time = time + dmat(1,point)/v + amount(point)*fai;
    if (point <= (a_cnt+1))
        remain_a = remain_a - amount(point);
    else
        remain_b = remain_b - amount(point);
    end
    temp = [temp,point];
    
    for j = 2 : N
        point = route(j);
        if (point-1 <= a_cnt)
            if remain_a < amount(point)  
                list{d} = temp;
                ctime = [ctime,time];
                cdis = [cdis, dis];
                d = d + 1;
                temp = [];
                temp = [temp,point];
                dis = 0;
                dis = dis + dmat(1,point) + dmat(point,route(j - 1));
                time = 0;
                time = time + dmat(1,point)/v + dmat(point,route(j - 1))/v + amount(point)*fai;
                remain_a = robot_a - amount(point);
                remain_b = robot_b;
            else  
                dis = dis + dmat(route(j - 1),point);
                time = time + dmat(route(j - 1),point)/v + amount(point)*fai;
                temp = [temp,point];
                remain_a = remain_a - amount(point);
            end
            
        else
            if remain_b < amount(point) 
                list{d} = temp;
                ctime = [ctime,time];
                cdis = [cdis, dis];
                d = d + 1;
                temp = [];
                temp = [temp,point];
                dis = 0;
                dis = dis + dmat(1,point) + dmat(point,route(j - 1));
                time = 0;
                time = time + dmat(1,point)/v + dmat(point,route(j - 1))/v + amount(point)*fai;
                remain_b = robot_b - amount(point);
                remain_a = robot_a;
            else  
                dis = dis + dmat(route(j - 1),point);
                time = time + dmat(route(j - 1),point)/v + amount(point)*fai;
                temp = [temp,point];
                remain_b = remain_b - amount(point);
            end
        end
    end
    
    list{d} = temp;
    dis = dis + dmat(route(N),1); 
    time = time + dmat(route(N),1)/v;
    ctime = [ctime,time];
    cdis = [cdis, dis];
    
    if d == rs
        f = TwotoOne1( list,rs );
        rtes = [rtes;f];
    end
    
    if d < rs 
        for k = 1 : d
            rotime(k)  = ctime(k);
            ropoint{k} = list{k};
        end
        
        for k = (d+1) : rs
            
            temprotime = rotime;
            pos = find(rotime == max(rotime));
            pp = pos(1);
            abc = ropoint{pp};
            length = size(abc, 2);
            
            kk = 1;
            while length < 2          
                temprotime(pp) = 0;
                pos = find(temprotime == max(temprotime));
                pp = pos(1);
                abc = ropoint{pp};
                length = size(abc, 2);
                kk = kk + 1;
                if (kk == 10)
                    disp('Êý¾Ý´íÎó');
                    break;
                end
            end
            
            nums = floor(length/2);
            ropoint{k} = abc(1:nums);
            abc(1:nums) = [];
            ropoint{pp} = abc;
            [~,t] = oneseqval(ropoint{pp},amount,robot_a, robot_b,a_cnt, dmat, v_salesmen,v,fai,kesai);
            rotime(pp) = t;
            [~,t] = oneseqval(ropoint{k},amount,robot_a, robot_b,a_cnt, dmat, v_salesmen,v,fai,kesai);
            rotime(k) = t;
        end
        
        f = TwotoOne1( ropoint,rs );
        rtes = [rtes;f];
    end
    if d > rs 
        for k = 1 : rs
            rotime(k)  = ctime(k);
            ropoint{k} = list{k};
        end
        for k = (rs + 1) : d
           
            pos = find(rotime == min(rotime));
            pp = pos(1);
            abc = ropoint{pp};
            ropoint{pp} = [ropoint{pp},list{k}];
            [~,t] = oneseqval(ropoint{pp},amount,robot_a, robot_b,a_cnt, dmat,v_salesmen,v,fai,kesai);
            rotime(pp) = t;
        end      
        f = TwotoOne1(ropoint,rs);
        rtes = [rtes;f];
    end
end
    brk=rtes(:,N+1:end);
    rte=rtes(:,1:N);
end


