
function f = fast_non_dominated_sort(x, M, N,NP)
clear m
pareto_rank = 1;        
F(pareto_rank).b = [];  
individual = [];  

for i = 1 : NP
    individual(i).n = 0;   
    individual(i).s = [];   
    for j = 1 : NP
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if (x(i,N + k) < x(j,N + k))
                dom_less = dom_less + 1;
            elseif (x(i,N + k) == x(j,N + k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M       
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M    
            individual(i).s = [individual(i).s j];
        end
    end   
    if individual(i).n == 0      
        x(i,M + N + 1) = 1;
        F(pareto_rank).b = [F(pareto_rank).b i];
    end
end

while ~isempty(F(pareto_rank).b)
   Q = [];                                              
   for i = 1 : length(F(pareto_rank).b)                       
       if ~isempty(individual(F(pareto_rank).b(i)).s)         
        	for j = 1 : length(individual(F(pareto_rank).b(i)).s)  
            	individual(individual(F(pareto_rank).b(i)).s(j)).n = ...这里表示个体j的被支配个数减1
                	individual(individual(F(pareto_rank).b(i)).s(j)).n - 1;
        	   	if individual(individual(F(pareto_rank).b(i)).s(j)).n == 0  
               		x(individual(F(pareto_rank).b(i)).s(j),M + N + 1) = pareto_rank + 1;
                    Q = [Q individual(F(pareto_rank).b(i)).s(j)];
                end
            end
       end
   end
   pareto_rank =  pareto_rank + 1;
   F(pareto_rank).b = Q;
end


[temp,index_of_ranks] = sort(x(:,M + N + 1));
for i = 1 : length(index_of_ranks)

    sorted_based_on_rank(i,:) = x(index_of_ranks(i),:);
end

current_index = 0;
for pareto_rank = 1 : (length(F) - 1)     
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(pareto_rank).b)
        y(i,:) = sorted_based_on_rank(current_index + i,:);  
    end
    current_index = current_index + i;       %current_index = i
    sorted_based_on_objective = [];  
    for i = 1 : M
      
        [sorted_based_on_objective, index_of_objectives] = sort(y(:,N + i)); 
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:); 
        end
        f_max = sorted_based_on_objective(length(index_of_objectives), N + i);
        f_min = sorted_based_on_objective(1, N + i);
        y(index_of_objectives(length(index_of_objectives)),M + N + 1 + i) = Inf;
        y(index_of_objectives(1),M + N + 1 + i) = Inf;
         for j = 2 : length(index_of_objectives) - 1     
            next_obj  = sorted_based_on_objective(j + 1,N + i);
            previous_obj  = sorted_based_on_objective(j - 1,N + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + N + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + N + 1 + i) = (next_obj - previous_obj)/(f_max - f_min);
            end
         end
    end

    dis = [];
    dis(:,1) = zeros(length(F(pareto_rank).b),1);
    for i = 1 : M
        dis(:,1) = dis(:,1) + y(:,M + N + 1 + i);
    end
    y(:,M + N + 2) = dis;
    y = y(:,1 : M + N + 2);
    z(previous_index:current_index,:) = y;
end
f = z();
end

