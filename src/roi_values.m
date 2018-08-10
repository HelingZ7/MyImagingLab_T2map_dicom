function [values,bw,Position]=roi_values(varargin)
% Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
% mean values of images from multi rois, exclude nan, inf and zeros. 
%[values,bw,Position]=roi_values(img,imga,roi_idx,bw,Position);
img=varargin{1};
imga=varargin{2};
roi_idx=varargin{3};
if size(imga,1)~=size(img,1)||size(imga,2)~=size(img,2)
    imga=imresize(imga,[size(img,1),size(img,2)]);
end


if nargin==3
        figure
        imagesc(imga);colormap(gray);img_setting1;title(strcat("Outline ",num2str(roi_idx)," ROI(s)"))
        hold on
        [bw,Position]=drawroi(roi_idx);        
        roi_para_drawing(Position,roi_idx);
else
    bw=varargin{4};
    Position=varargin{5};
end
if size(bw,1)~=size(img,1)||size(bw,2)~=size(img,2)
    bw=imresize(bw,[size(img,1),size(img,2)],'box');
end
        
        for i=1:size(img,3)
            temp=img(:,:,i);
            for j=1:roi_idx
                values(i,j)=mean(temp(bw(:,:,j)&~isnan(temp)&~isinf(temp)&(temp~=0)));
            end
        end
end
