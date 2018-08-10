function [t2map,S0map]=make_one_t2map(img,bw,matr,te)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 3.0 (modified from t2starmap.m)
% Modified on 01/17/2018 by Heling Zhou, Ph.D.
% T2star map fitting for pix By pix
% [t2map,S0map]=make_one_t2map(img,bw,matr,te)
% img is a 2d matrix
% bw is a binary matrix determining the area where t2maps will be gereated
% matr is the matrix size of the output map. 
% te is a vector of echo times
% 
% EM='none';
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tcourses=dsimg(img,matr,bw);
bw_new=logical(imresize(double(bw),[matr,matr],'bilinear')); %resize ROI to fit img
[loc(:,1),loc(:,2)]=find(bw_new);%find x,y location of ROI
zerotcourse= find(sum(tcourses,2)==0);%Find zeros in ROI
nonzerotcourse=find(sum(tcourses,2)~=0);%Find non zeros in ROI
tcourses(zerotcourse,:)=[];%delete Zeros in time course
loc(zerotcourse,:)=[];%Delete zero location

[x,~]=size(tcourses);%find size of new time course after deleting zeros

parfor i=1:x
    cfit{i}=T2fitting(tcourses(i,:),te,'off'); %fit time course to Animal_T2...
    S0(i)=cfit{i}.S0;t2(i)=cfit{i}.T2star;
end

%ana_new=imresize(imga,[matr,matr]);
t2map=ones(matr);
t2full=nan(sum(bw_new(:)),1);
t2full(nonzerotcourse)=t2;
t2map(bw_new)=t2full;
t2map(~bw_new)=NaN;

S0map=ones(matr);
S0full=nan(sum(bw_new(:)),1);
S0full(nonzerotcourse)=S0;
S0map(bw_new)=S0full;
S0map(~bw_new)=NaN;

end