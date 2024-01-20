

function [retval ] = eliteselect(cnt,pop,popval )
ret = [];
retval = zeros(cnt,5);
popsize = size(popval,1);
max_rank = max(popval(:,end-1));
prev_index = 0;
for i = 1 : max_rank
    current_index = max(find(popval(:,(end-1))==i));
    if current_index > cnt
        remain_pop = cnt - prev_index;
        temp = popval(((prev_index+1):current_index),:);
    
        [~,index_crowd]=sort(temp(:,(end)),'descend');
       
        for j = 1 : remain_pop
            retval(prev_index+j,:) = temp(index_crowd(j),:);
        end
        return ;
    elseif (current_index < cnt)
        retval(((prev_index+1):current_index),:) = popval(((prev_index+1):current_index),:);
    else
        retval(((prev_index+1):current_index),:) = popval(((prev_index+1):current_index),:);
        return ;
    end
    prev_index = current_index;
end
end

