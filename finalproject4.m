%% Kathryn Tsai
%% Test 2
%% ECE 2409

clear all;clc;close all;
%% Read training data
fj1=imread('training\fuji.jpg'); fj1_sz=size(fj1);
gs1=imread('training\granny_smith.jpg'); gs1_sz=size(gs1);
hc1=imread('training\honeycrisp.jpg'); hc1_sz=size(hc1);
gl1=imread('training\gala.jpg'); gl1_sz=size(gl1);

% right-click and select "Export Data to Workspace", save figur eas
%figure;
%imshow(fj1,[]); title('Fuji');
%imshow(gs1,[]); title('Granny Smith');
%imshow(hc1,[]); title('Honeycrisp');
%imshow(gl1,[]); title('Gala');
%figure;
%im=[fj1,gs1,hc1,gl1];
%imshow(im);

%% Concatenate the 4 training images
apples=fj1; sz=size(apples);
sz(1,end+gs1_sz(2),1) = 0; 
dim1=fj1_sz(2)+gs1_sz(2)-1;
apples(1:gs1_sz(1), fj1_sz(2):dim1, :) = gs1; 
sz(1,end+hc1_sz(2),1) = 0;  
dim2=dim1+hc1_sz(2)-1;
apples(1:hc1_sz(1), dim1:dim2, :) = hc1;
sz(1,end+gl1_sz(2),1) = 0;  
dim3=dim2+gl1_sz(2)-1;
apples(1:gl1_sz(1), dim2:dim3, :) = gl1;
imshow(apples);

%% Import previously determined dimensions of colors to be trained
h1=openfig('cursor_fig.fig'); % fix sizing
load('cursor_info.mat');
[gl_p1,gl_p2,hc_p1,hc_p2,gs_p1,gs_p2,fj_p1,fj_p2]=cursor_info.Position;

%% Fuji
%fj_r=sort([fj_p1(1),fj_p2(1)]); fj_r=fj_r(1):fj_r(2);
%fj_c=sort([fj_p1(2),fj_p2(2)]); fj_c=fj_c(1):fj_c(2);
%fj_rc=fj1(fj_r,fj_c,:); low=35;high=30000;
%num = mx_lk(fj_rc,'Fuji',fj1,low,high);
%fprintf('This is a fuji apple.\n');

%% Fuji
r=sort([fj_p1(1),fj_p2(1)]); r=r(1):r(2);
c=sort([fj_p1(2),fj_p2(2)]); c=c(1):c(2);
rc=fj1(r,c,:); low=5000;high=30000;
num_blue = mx_lk(rc,'Fuji',fj1,low,high);
fprintf('This is a fuji apple.\n');

fj2=imread('test\fuji.jpg');
num_blue = mx_lk(rc,'Fuji',fj2,low,high);

%% Question 2e - Redo
r=fj1(:,:,1);g=fj1(:,:,2);b=fj1(:,:,3);
[rows,cols,map]=size(fj1);
k=(r>g & r>b & g>b & (r+g+b)~=255*3); kk=~k; 
r(kk)=0; r=reshape(r,[rows,cols]);
g(kk)=0;g=reshape(g,[rows,cols]);
b(kk)=0;b=reshape(b,[rows,cols]);
xx=cat(3,r,g,b);
figure; hold on;
subplot 211; imshow(fj1); title ('Original image');
subplot 212; imshow(xx); title ('Question 1e');
hold off;