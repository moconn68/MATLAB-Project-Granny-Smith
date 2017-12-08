% random shuffling of apples
function apples = apple_shuffle(fj1, gs1, hc1, gl1)
num_apples=4;
order=randperm(num_apples,num_apples);
%libpointer('uint8',[
%imgs=[fj1 gs1 hc1 gl1];
%imgs=imgs(randperm(length(imgs));

%scale fuji training apple
scale=50;
fj1_sz=size(fj1);
fj1_2=imresize(fj1, floor(fj1_sz(1)/scale)/100); fj1_resz=size(fj1_2);

%concatenate 1st image, space for 2nd image
if order(1)==1
        el1=fj1_2;
    elseif order(1)==2 
        el1=gs1;
    elseif order(1)==3 
        el1=hc1;
    else  
        el1=gl1;
end
el1_sz=size(el1); 

if order(2)==1
        el2=fj1_2;
    elseif order(2)==2 
        el2=gs1;
    elseif order(2)==3 
        el2=hc1;
    else  
        el2=gl1;
end
el2_sz=size(el2); 

curr_dim=el1_sz;
apples=el1; sz=size(apples);
sz(1,end+el2_sz(2),1) = 0; 

%apples(1:el2_sz(1), curr_dim:curr_dim+el2_sz(1)+1 ,:) = el2;

%concatenate apples 2-4
for idx=2:4
    % set value of element to be concatenated
    if order(idx)==1
        el=fj1_2;
    elseif order(idx)==2 
        el=gs1;
    elseif order(idx)==3 
        el=hc1;
    else  
        el=gl1;
    end
    el_sz=size(el);
    
    %apples=fj1_2; sz=size(apples);
    %sz(1,end+gs1_sz(2),1) = 0; 
  
    %dim1=fj1_resz(2)+gs1_sz(2)-1;
    %apples(1:gs1_sz(1), fj1_resz(2):dim1, :) = gs1; 
    %sz(1,end+hc1_sz(2),1) = 0;  
    
    sz(1,end+el_sz(2),1)=0;
    apples(1:el_sz(1), curr_dim:curr_dim+el_sz(2)-1,:) = el; 
    curr_dim=curr_dim+el_sz(2)-1; %sets for next round

    %dim2=dim1+hc1_sz(2)-1;
    %apples(1:hc1_sz(1), dim1:dim2, :) = hc1;
    
    %sz(1,end+gl1_sz(2),1) = 0;  
    %dim3=dim2+gl1_sz(2)-1;
    
    %apples(1:gl1_sz(1), dim2:dim3, :) = gl1;
    
end

end