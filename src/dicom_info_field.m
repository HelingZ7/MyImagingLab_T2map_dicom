function [newT,parameter]=dicom_info_field(parameter,dirname_main)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 4.0
% Modified on 11/6/2017 by Heling Zhou, Ph.D.
% examples: [newT,parameter]=dicom_info_field; %  select parameter-to-extract and folder location interactively
% [newT,parameter]=dicom_info_field(parameter); %  use pre-defined parameters but select folder location interactively
% [newT,parameter]=dicom_info_field(parameter,dirname_main); % use pre-defined parameters and folder location 
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==1
    dirname_main=uigetdir;
end
if nargin==0
    dirname_main=uigetdir;
end
files = dir(fullfile(dirname_main,'*IM*'));
f_num=length(files);
if nargin==0
    header=dicominfo(fullfile(dirname_main,files(1).name));
    names = fieldnames(header);
    for i=1:length(names)
        temp=names{i};
        values{i}=getfield(header,temp );
        if isstruct(values{i})
            values{i}='structure';
        elseif isnumeric(values{i})
            
            values{i}=strcat(num2str(values{i}(:)'));
        end
        name_values{i}=strcat(names{i},': ',values{i});
    end
    
    [dispstr,idx]=sort(name_values);
    str=names(idx);
    [file_index,~] = listdlg('ListString',dispstr,...
        'SelectionMode','multiple',...
        'ListSize',[300 400],...
        'Name','All fields listing',...
        'PromptString','Select field names:',...
        'OKString','go',...
        'CancelString','Cancel',...
        'uh',32,...% button height
        'fus',8,...
        'ffs',8);
    parameter=str(file_index);
end

if f_num~=0
    parfor i=1:min(f_num,1200)% if more than 200 files, only read first 200
        T(i,:) = struct2table(dicominfo(fullfile(dirname_main,files(i).name)),'AsArray',true);
        
    end
newT=T(:, parameter);
% newT.NumberOfFiles=f_num;
end
end
