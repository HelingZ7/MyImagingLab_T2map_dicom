function [t2map,S0map]=make_many_t2maps(data,te)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 1.0 (modified from pc_ibt.m)
% Created on 01/17/2018 by Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
% data is a matrix in 3d (x,y,te) or 4d (x,y,te,another parameter) 
%   or 5d (x,y,te,another parameter, another parameter)
% other parameters can be time or slice location. the order and meaning do
%   not matter.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% tic

warning('off')
t2map=zeros(size(data,1),size(data,2),size(data,4),size(data,5));
S0map=zeros(size(data,1),size(data,2),size(data,4),size(data,5));
% mask is set to at least 4 times signal intensity of the left top corner in the first echo time
mask=squeeze(data(:,:,1,:,:)>4*mean(mean(data(2:6,2:6,1,:))));
for n=1:size(data,5)
    for i=1:size(data,4)
        [t2map(:,:,i,n),S0map(:,:,i,n)]=make_one_t2map(squeeze(data(:,:,:,i,n)),mask(:,:,n),size(data,1),te);
    end
end

% toc
end