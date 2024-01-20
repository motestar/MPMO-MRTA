
function [child,fa] = Crossover(EA,Pop,N,amount,robot_a,robot_b,num1, rs, dmat, vrobot,v1,fai,kesai )
     par1 = TwotoOne( Pop,rs );
     p1 = par1(:,1:N);

     EAsize = size(EA,1);
     b = randperm(EAsize,1);    
     Par2 = EA(b,:);
     par2 = TwotoOne(Par2,rs);
     p2 = par2(:,1:N);
     
     f = zeros(1,N);
     a = randperm(N, 1);
     
     for i = 1 : a
         if f(i) == 0
             f(i) = p1(i);
         end
     end
     
     for i = 1 : N
         flag = 0;
         for j = 1 : N
             if p2(i) == f(j)
                 flag = 1;
                 break;
             end
         end
         if flag == 0
             for j = 1 : N
                 if f(j) == 0
                     f(j) = p2(i);
                     break;
                 end
             end
         end
     end   
     [brk, rte] = creatonebrk(f,dmat,amount, robot_a, robot_b, num1, rs,vrobot,v1,fai,kesai);

     [list,fdis,ftime,fa,fsum] = objective_value(amount,robot_a,robot_b,num1,1,rte,brk,rs,dmat,vrobot,N,v1,fai,kesai);
     child.solution = list;
     child.f1 = fdis;
     child.f2 = ftime;
     child.fa = fa; 
     child.fsum = fsum; 
end

