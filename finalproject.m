%% Matt O'Connell, Kathryn Tsai
%% Project Granny Smith
%% ECE 2409

%% Begin program.
clear all;clc;close all;

%% PART 1 (QUESTIONS 1, 2, 3): TRAIN DATA, CREATE HISTOGRAMS, WRITE COLOR RULES. 
%% Read training data
scale=50;
fj1=imread('training\fuji.jpg'); fj1_sz=size(fj1);
fj1_2=imresize(fj1, floor(fj1_sz(1)/scale)/100); fj1_resz=size(fj1_2);
gs1=imread('training\granny_smith.jpg'); gs1_sz=size(gs1);
hc1=imread('training\honeycrisp.jpg'); hc1_sz=size(hc1);
gl1=imread('training\gala.jpg'); gl1_sz=size(gl1);

%% Create data
%right-click and select "Export Data to Workspace", save figur eas
%figure;
%imshow(fj1,[]); title('Fuji');
%imshow(gs1,[]); title('Granny Smith');
%imshow(hc1,[]); title('Honeycrisp');
%imshow(gl1,[]); title('Gala');
%figure;
%im=[fj1,gs1,hc1,gl1];
%imshow(im);

%% Concatenate the 4 training images
apples=fj1_2; sz=size(apples);

sz(1,end+gs1_sz(2),1) = 0; 
dim1=fj1_resz(2)+gs1_sz(2)-1;
apples(1:gs1_sz(1), fj1_resz(2):dim1, :) = gs1; 

sz(1,end+hc1_sz(2),1) = 0;  
dim2=dim1+hc1_sz(2)-1;
apples(1:hc1_sz(1), dim1:dim2, :) = hc1;

sz(1,end+gl1_sz(2),1) = 0;  
dim3=dim2+gl1_sz(2)-1;
apples(1:gl1_sz(1), dim2:dim3, :) = gl1;
%imshow(apples);

%% Import previously determined dimensions of colors to be trained, then apply rules to them.
% Show selected training data.
h1=openfig('cursor_fig2.fig'); 
load('cursor_info.mat');
[gl_p1,gl_p2,hc_p1,hc_p2,gs_p1,gs_p2,fj_p1,fj_p2]=cursor_info.Position;

% Fuji - Katie
r=sort([fj_p1(1),fj_p2(1)]); r=r(1):r(2);
c=sort([fj_p1(2),fj_p2(2)]); c=c(1):c(2);
rc=fj1(r,c,:); low=5000;high=30000;
fj_loc = mx_lk_weibull(rc,'Fuji',apples,low,high);

% Gala - Matt
r=sort([gl_p1(1),gl_p2(1)]); r=r(1):r(2);
c=sort([gl_p1(2),gl_p2(2)]); c=c(1):c(2);
rc=gl1(r(:),c(:),:); low=5000;high=30000;
gl_loc = mx_lk_weibull(rc,'Gala',apples,low,high);

% Honeycrisp - Katie
r=sort([hc_p1(1),hc_p2(1)]); r=r(1):r(2);
c=sort([hc_p1(2),hc_p2(2)]); c=c(1):c(2);
rc=hc1(r,c,:); low=10000;high=10^10;
hc_loc = mx_lk_weibull(rc,'Honeycrisp',apples,low,high);

% Granny Smith - Matt
r=sort([gs_p1(1),gs_p2(1)]); r=r(1):r(2);
c=sort([gs_p1(2),gs_p2(2)]); c=c(1):c(2);
rc=gs1(r,c,:); low=5000;high=30000;
gs_num = mx_lk_weibull(rc,'Granny Smith',apples,low,high);

%% PART II (QUESTION 4): RANDOMLY SHUFFLE APPLES AND IDENTIFY TYPE OF APPLE IN LINEUP.
% Katie wrote shuffle function & Matt did shuffling. 

mattShuffled=apple_shuffle(fj1,gs1,hc1,gl1);
mTitle = "Matt's Shuffled Image";
figure;
imshow(mattShuffled);
title(mTitle);
katieShuffled=apple_shuffle(fj1,gs1,hc1,gl1);
kTitle = "Katie's Shuffled Image"; 
figure;
imshow(katieShuffled);
title(kTitle); 
    
% Gala - Matt
r=sort([gl_p1(1),gl_p2(1)]); r=r(1):r(2);
c=sort([gl_p1(2),gl_p2(2)]); c=c(1):c(2);
rc=gl1(r(:),c(:),:); low=5000;high=30000;
gl_loc = mx_lk_weibull(rc,'Gala',mattShuffled,low,high);

% Granny Smith - Matt
r=sort([gs_p1(1),gs_p2(1)]); r=r(1):r(2);
c=sort([gs_p1(2),gs_p2(2)]); c=c(1):c(2);
rc=gs1(r,c,:); low=5000;high=30000;
fj_num = mx_lk_weibull(rc,'Granny Smith',mattShuffled,low,high);

% Fuji - Katie 
r=sort([fj_p1(1),fj_p2(1)]); r=r(1):r(2);
c=sort([fj_p1(2),fj_p2(2)]); c=c(1):c(2);
rc=fj1(r,c,:); low=5000;high=30000;
fj_loc = mx_lk_weibull(rc,'Fuji',katieShuffled,low,high);

% Honeycrisp - Katie
r=sort([hc_p1(1),hc_p2(1)]); r=r(1):r(2);
c=sort([hc_p1(2),hc_p2(2)]); c=c(1):c(2);
rc=hc1(r,c,:); low=10000;high=10^10;
hc_num = mx_lk_weibull(rc,'Honeycrisp',apples,low,high);
%% PART III (QUESTION 5): TEST DATA WITH REAL APPLES.

% Fuji - Katie
fj2=imread('test\fuji.jpg');
numfj = mx_lk_weibull(rc,'Fuji',fj2,low,high,false);

% Gala - Matt
gl2=imread('test\gala.jpg');
numgl = mx_lk_weibull(rc,'Gala',gl2,low,high,false);

% Honeycrisp - Katie
hc2=imread('test\honeycrisp.jpg');
numhc = mx_lk_weibull(rc,'Honeycrisp',hc2,low,high,false);

% Granny Smith - Matt
gs2=imread('test\organic_mini_granny_smith.jpg');
numgs = mx_lk_weibull(rc,'Granny Smith',gs2,low,high,false);

%% End program.
close all

% Pros: Robust implementation.
% Cons: Need better test images.  Mixed results when applied to real data.
% Improve concatenation of apples by making extra space white instead
% of black, as well as only resizing images when above certain height. Better documentation. 