function data=dicomread_dir(dirname)
%%
%Original code: Heling Zhou
%examples: data=dicomread_dir; %  select folder interactively
%          data=dicomread_dir('C:\your_data_folder');
%%
if nargin<1
    dirname=uigetdir;
end
files = dir(fullfile(dirname,'*IM*'));
if isempty(files)
    files = dir(dirname);
    files(1:2)=[];
end
f_num=length(files);
for n=1:f_num
    filename=files(n).name;
    temp=squeeze(dicomread(fullfile(dirname,filename)));
    if size(temp,3)==1
        data(:,:,n)=temp;
    else
        data(:,:,:,n)=temp;
    end
end
end