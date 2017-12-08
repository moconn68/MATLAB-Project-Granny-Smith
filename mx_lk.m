% mx_lk - maximum likelihood test for an Apple

function l = mx_lk(info,apple,x,low,high) 
    r = double(info(:,:,1)); g = double(info(:,:,2)); b = double(info(:,:,3));
    [rows,cols,map]=size(x);
    
    % Fit RGB histogram to Burr Type XII distribution
    binwidth=30;
    graph_title = strcat(capitalize(apple), ' Apple');
    figure; hold on; grid on;
    r_hist = histfit(r(:),binwidth,'Burr'); set(r_hist(1),'facecolor','r','facealpha',.75); set(r_hist(2),'color','r');
    g_hist = histfit(g(:),binwidth,'Burr'); set(g_hist(1),'facecolor','g','facealpha',.75); set(g_hist(2),'color','g');
    b_hist = histfit(b(:),binwidth,'Burr'); set(b_hist(1),'facecolor','b','facealpha',.75); set(b_hist(2),'color','b'); 
    title(graph_title); xlim([0,256]); set(gca,'xtick',0:32:256); hold off;
    
    % Fit the Burr distribution and calculate alpha, c, and k for sets of RGB data
    pd_r = fitdist(im2double(r(:)),'Burr');
    pd_g = fitdist(im2double(g(:)),'Burr'); 
    pd_b = fitdist(im2double(b(:)),'Burr');
    
    % calculate R, G, B probability density for original image
    rx = x(:,:,1); gx = x(:,:,2); bx = x(:,:,3);
    pdf_rx=pdf(pd_r,0:255); prob_r=pdf_rx(rx+1);
    pdf_gx=pdf(pd_g,0:255); prob_g=pdf_gx(gx+1);
    pdf_bx=pdf(pd_b,0:255); prob_b=pdf_bx(bx+1);

    % calculate likelihood that a pixel is on histogram
    prod_pdf = (prob_r).*(prob_g).*(prob_b);
    prod_pdf=prod_pdf/(max(max(prod_pdf)));
        
    % count apples in picture
    pdf_filt = reshape(bwareafilt(imbinarize(prod_pdf),[low,high]),[rows,cols]);
    [l, num]=bwlabel(pdf_filt);
    
    %figure; hold on;
    %subplot 221; imshow(pdf_rx); title ('Filtered Product of Red PDF');
    %subplot 222; imshow(pdf_gx); title ('Filtered Product of Green PDF');
    %subplot 223; imshow(pdf_bx); title ('Filtered Product of Blue PDF');
    %subplot 224; imshow(x); title ('Original image of apples');  hold off;
    
    figure; hold on;
    subplot 212; imshow(pdf_filt); title (['Filtered image for ' graph_title]);
    subplot 211; imshow(x); title ('Original image');  hold off;
end
