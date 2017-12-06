% mx_lk
% By Katie Tsai

function num = mx_lk(info,color,x,low,high) 
    r = info(:,:,1); g = info(:,:,2); b = info(:,:,3);
    [rows,cols,map]=size(x);
    
    % Fit RGB data to a skewed gamma distribution
    graph_title = strcat(capitalize(color), ' Apple');
    figure; hold on; r_hist = histfit(r(:)); set(r_hist(1),'facecolor','r','facealpha',.75); set(r_hist(2),'color','r');
    grid on;
    g_hist = histfit(g(:)); set(g_hist(1),'facecolor','g','facealpha',.75); set(g_hist(2),'color','g');
    b_hist = histfit(b(:)); set(b_hist(1),'facecolor','b','facealpha',.75); set(b_hist(2),'color','b'); 
    title(graph_title); xlim([0,256]); hold off;
    
    % approximate the normal curve and calculate mu and sigma for R, G, B sets
    pd_r = fitdist(im2double(r(:)),'Gamma');
    pd_g = fitdist(im2double(g(:)),'Gamma'); 
    pd_b = fitdist(im2double(b(:)),'Gamma');
    
    % calculate R, G, B probability density for original image
    rx = x(:,:,1); gx = x(:,:,2); bx = x(:,:,3);
    pdf_rx=reshape(pdf('Gamma',im2double(rx(:)),pd_r.a,pd_r.b),[rows,cols]);
    pdf_gx=reshape(pdf('Gamma',im2double(gx(:)),pd_g.a,pd_g.b),[rows,cols]);
    pdf_bx=reshape(pdf('Gamma',im2double(bx(:)),pd_b.a,pd_b.b),[rows,cols]);
    
    % calculate likelihood that a pixel is the given color
    prod_pdf = pdf_rx.*pdf_gx.*pdf_bx;
    % count number of skittles in picture
    pdf_filt = reshape(bwareafilt(imbinarize(prod_pdf),[low,high]),[rows,cols]);
    [l, num]=bwlabel(pdf_filt);
    
    figure; hold on;
    subplot 221; imshow(pdf_rx); title ('Filtered Product of Red PDF');
    subplot 222; imshow(pdf_gx); title ('Filtered Product of Green PDF');
    subplot 223; imshow(pdf_bx); title ('Filtered Product of Blue PDF');
    subplot 224; imshow(x); title ('Original image');  hold off;
    
    figure; hold on;
    subplot 212; imshow(pdf_bx); title ('Filtered Product of RGB PDF');
    subplot 211; imshow(x); title ('Original image');  hold off;
end
