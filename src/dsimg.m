function tcourses=dsimg(img,matr,bw)
%%
% Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
% reshape the pixels of img (3d) within a roi (defined by a
% binary mask bw) to a 2d matrix where the rows are along the 3rd
% dimention, orignal x and y are compressed into columns
% bw will be resized to match img matrix size (x,y) if not the same
%%
[x,y,z]=size(img);
[bx,by]=size(bw);
img(isnan(img))=0;
if bx~=matr||by~=matr
    bw=logical(imresize(double(bw),[matr,matr],'bilinear'));
end
tcourses=zeros(sum(bw(:)),z);
for i=1:z
    %img(:,:,i)=img(:,:,i).*bw;
    if x~=matr||y~=matr
        temp=imresize(img(:,:,i),[matr,matr],'bilinear');
    else
        temp=img(:,:,i);
    end
    tcourses(:,i)=temp(bw);
end

end


