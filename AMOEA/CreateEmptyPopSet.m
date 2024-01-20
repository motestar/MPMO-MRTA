function Pop=CreateEmptyPopSet(PopSize)
    empty_particle.solution=[];
    empty_particle.f1=[]; 
    empty_particle.f2=[]; 
    empty_particle.fa=[]; 
    empty_particle.fsum=0; 
    Pop=repmat(empty_particle,PopSize,1);  
end