
function f = TwotoOne2( rs, pop )
    num = size(pop,1);
    f = [];
    for i = 1 : num
        f1 = TwotoOne( pop(i),rs );
        f = [f;f1];      
    end
end

