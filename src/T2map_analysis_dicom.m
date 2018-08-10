%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 2.0
% modified on 03/02/2018 by Heling Zhou, Ph.D.
% this function generates T2star or T2 maps and save the results in the folder 'results' under the dicom data folder
% Email: helingzhou7@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data and header information
dirname=uigetdir; % location of dicom files
[new_T,~]=dicom_info_field({'EchoTime','SliceLocation'},dirname);
te=unique(new_T.EchoTime,'stable');
numofslice=length(unique(new_T.SliceLocation));
% numofslice=3; % make sure number of slice is correct;
data=dicomread_dir(dirname);
% te=5:7:68; % make sure te is correct;
data=reshape(data,size(data,1),size(data,2),length(te),[]);

%% generate t2 maps, this part will take a lot of time. Use parallel computing if possible
[t2map,S0map]=make_many_t2maps(data,te);
t2map=reshape(t2map,size(t2map,1),size(t2map,2),numofslice,[]);
t2map = permute(t2map,[1,2,4,3]);
S0map=reshape(S0map,size(S0map,1),size(S0map,2),numofslice,[]);
S0map = permute(S0map,[1,2,4,3]);
mkdir(strcat(dirname,'\results'))
save(strcat(dirname,'\results\t2map'),'t2map','S0map')
%% save visualization results
figure;
for i=1:size(t2map,3)
    for j=1:size(t2map,4)
        clf
        imagesc(t2map(:,:,i,j));img_setting1;colormap jet;set(gca,'clim',[0 50]);colorbar;
        saveas(gcf,strcat(dirname,'\results\map_s',num2str(j),'_tp',num2str(i),'.tif'))
    end
end
%% calulate ROI values and plot
t2map(t2map>100)=nan;
flag=1;
while flag
    try 
        numofrois=uint8(input('number of ROI: '));
        flag=0;
    catch em
    end
end
    
for i=1:size(t2map,4)
    [values(:,:,i),b(:,:,:,i),p{i}]=roi_values(t2map,t2map(:,:,1,i),numofrois);
    clf;set(gcf,'Units','normalized','OuterPosition',[0 0 1 1]);
    subplot(1,2,1);imagesc(t2map(:,:,1,1));colormap(gray);img_setting1;title('ROI');hold on
    roi_para_drawing(p{i},numofrois)
    subplot(1,2,2);plot(values(:,:,i),'LineWidth',2);
    axis_setting1; title('Dynamic T2')
    saveas(gcf,strcat(dirname,'\results\plot_s',num2str(i),'.tif'))
    xlswrite(strcat(dirname,'\results\ROI_values.xlsx'),values(:,:,i),i,'A1');
end
