
function id = Removerepetition(pop,N,rs )

    pop_size = size(pop,1);    
    num_brks = rs - 1;
    p = zeros(pop_size,N+num_brks);
    
    for i = 1 : pop_size
        list = pop(i).solution;
        pop_brks = zeros(1,num_brks);
        pop_rtes = [];
        
        ini = 0;
        for j = 1 : num_brks
            pop_brks(j) = ini + length(list{j});
            pop_rtes = [pop_rtes, list{j}];
            ini = ini + length(list{j});
        end
        pop_rtes = [pop_rtes, list{rs}];
        p(i,:) = [pop_rtes,pop_brks];
    end
    
    [~,id] = unique(p,'rows');

end
