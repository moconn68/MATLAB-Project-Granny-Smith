%% Kathryn Tsai
%% Test 2
%% ECE 2409

clear all;clc;close all;
%%
fj1=imread('training\fuji.jpg'); fj1_sz=size(fj1);
gs1=imread('training\granny_smith.jpg'); gs1_sz=size(gs1);
hc1=imread('training\honeycrisp.jpg'); hc1_sz=size(hc1);
gl1=imread('training\gala.jpg'); gl1_sz=size(gl1);

%fj1_sz(1,end+gs1_sz(2),1) = 0; %extend image 
%fj1(1:gs1_sz(1), fj1_sz(2):fj1_sz(2)+gs1_sz(2)-1, :) = gs1;
%imshow(fj1);

% right-click and select "Export Data to Workspace", save figur eas
%figure;
%imshow(fj1,[]); title('Fuji');
%imshow(gs1,[]); title('Granny Smith');
%imshow(hc1,[]); title('Honeycrisp');
%imshow(gl1,[]); title('Gala');
%figure;
%im=[fj1,gs1,hc1,gl1];
%imshow(im);

h1=openfig('cursor_fig.fig'); % fix sizing
load('cursor_info.mat');
[fj_p1,fj_p2,gs_p1,gs_p2,hc_p1,hc_p2,gl_p1,gl_p2]=cursor_info.Position;

%% Fuji
%fj_r=sort([fj_p1(1),fj_p2(1)]); fj_r=fj_r(1):fj_r(2);
%fj_c=sort([fj_p1(2),fj_p2(2)]); fj_c=fj_c(1):fj_c(2);
%fj_rc=fj1(fj_r,fj_c,:);
fj_rc=fj1(fj_p2(1):fj_p1(1),fj_p2(2):fj_p1(1));
imshow(fj_rc);
%%
blue = x(bc,br,:); low=35;high=30000;
num_blue = myGamma(blue,'Blue',x,low,high);
fprintf('There are an estimated %i blue M&Ms.\n',num_blue);

%% Question 2e - Redo
r=x(:,:,1);g=x(:,:,2);b=x(:,:,3);
[rows,cols,map]=size(x);
k=(b>r & b>g& g>r); kk=~k; 
r(kk)=255; r=reshape(r,[rows,cols]);
g(kk)=255;g=reshape(g,[rows,cols]);
b(kk)=255;b=reshape(b,[rows,cols]);
xx=cat(3,r,g,b);
figure; hold on;
subplot 211; imshow(x); title ('Original image');
subplot 212; imshow(xx); title ('Question 1e');
hold off;