% mx_lk_weibull - maximum likelihood test for an Apple
% for Honeycrisp
% Written by Katie Tsai and Matthew O'Connell
function mx = mx_lk(info,apple,x,low,high) 
    r = double(info(:,:,1)); g = double(info(:,:,2)); b = double(info(:,:,3));
    [rows,cols,map]=size(x);
    
    % Fit RGB histogram to Weibull Type XII distribution
    binwidth=30;
    graph_title = strcat(capitalize(apple), ' Apple');
    figure; hold on; grid on;
    r_hist = histfit(r(:),binwidth,'Weibull'); set(r_hist(1),'facecolor','r','facealpha',.75); set(r_hist(2),'color','r');
    g_hist = histfit(g(:),binwidth,'Weibull'); set(g_hist(1),'facecolor','g','facealpha',.75); set(g_hist(2),'color','g');
    b_hist = histfit(b(:),binwidth,'Weibull'); set(b_hist(1),'facecolor','b','facealpha',.75); set(b_hist(2),'color','b'); 
    title(graph_title); xlim([0,256]); set(gca,'xtick',0:32:256); hold off;
    
    % Fit the Weibull distribution and calculate alpha, c, and k for sets of RGB data
    pd_r = fitdist(im2double(r(:)),'Weibull');
    pd_g = fitdist(im2double(g(:)),'Weibull'); 
    pd_b = fitdist(im2double(b(:)),'Weibull');
    
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
    [BW, num]=bwlabel(pdf_filt);
    
    
    %figure; hold on;
    %subplot 221; imshow(pdf_rx); title ('Filtered Product of Red PDF');
    %subplot 222; imshow(pdf_gx); title ('Filtered Product of Green PDF');
    %subplot 223; imshow(pdf_bx); title ('Filtered Product of Blue PDF');
    %subplot 224; imshow(x); title ('Original image of apples');  hold off;
    
    CC=bwconncomp(BW);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [mx,idx_mx] = max(numPixels);
    while (CC.NumObjects > 1)
        [mn,idx_mn] = min(numPixels);
        BW(CC.PixelIdxList{idx_mn}) = 0;
        CC=bwconncomp(BW);
        numPixels = cellfun(@numel,CC.PixelIdxList);
        [mx,idx_mx] = max(numPixels);
    end
    BW2 = imfill(BW, 'holes');
    newX = x.*uint8(BW2);
    blk = find(newX == 0); newX(blk) = 255;
    
    figure; hold on;
    subplot 222; imshow(pdf_filt); title (['Filtered image for ' graph_title 'data']);
    subplot 221; imshow(x); title ('Original image');  
    %subplot 223; imshow(BW); title([graph_title ' selected']);
    subplot 223; imshow(BW2); title(['Filled']);
    subplot 224; imshow(newX); title(['Selected apple']); hold off;
    %figure; hold on;
    %subplot 212; imshow(pdf_filt); title (['Filtered image for ' graph_title]);
    %subplot 211; imshow(x); title ('Original image');  hold off;
end
