
function f = TwotoOne( pop,rs )

        list = pop.solution;
        pop_brks = zeros(1,rs-1);
        num_brks = rs - 1;
        pop_rtes = [];
        
        ini = 0;
        for j = 1 : num_brks
            pop_brks(j) = ini + length(list{j});
            pop_rtes = [pop_rtes, list{j}];
            ini = ini + length(list{j});
        end
        pop_rtes = [pop_rtes, list{rs}];
        
        f = [pop_rtes,pop_brks];

end

