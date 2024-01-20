
function f = Mutation1( N,pop )
    pos = randperm(N, 2);
    a = pos(1);
    b = pos(2);
    
    if b > a
        tem = pop(b);
        pop(b) = [];
        f = [pop(1:a-1) tem pop(a:end)];
    else
        tem = pop(a);
        pop(a) = [];
        f = [pop(1:b-1) tem pop(b:end)];
    end

end

