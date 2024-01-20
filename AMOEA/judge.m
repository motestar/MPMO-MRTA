
function res = judge(a,b,rs)
    num = size(a, 1);
    res = 1;
    c = TwotoOne2(rs,a);
    d = TwotoOne2(rs,b);
    for i = 1 : num
        if ~ismember(c(i,:),d)
            res = 0;
            break;
        end
    end

end

