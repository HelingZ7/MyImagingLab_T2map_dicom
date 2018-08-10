function [bw,Position]=drawroi(idx,h_im)
% Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
%h_im is needed in case that current axes contains more than one image
%objective.

h1=gca;
if nargin==2
    for i=1:idx
        roicolor=colorseq(i);

        h(i)=impoly(h1);
        setColor(h(i),roicolor);
        %position=wait(h(i));
        bw(:,:,i) = createMask(h(i),h_im);
        Position{i}=h(i).getPosition;
        
%         hold on
%         Position_temp=Position{i};
%         fill(Position_temp(:,1),Position_temp(:,2),roicolor,'FaceAlpha',0,'EdgeAlpha',0.2)
%         Position_temp=[];

    end
else
    for i=1:idx
        roicolor=colorseq(i);

        h(i)=impoly(h1);
        setColor(h(i),roicolor);
        %position=wait(h(i));
        bw(:,:,i) = createMask(h(i));
        Position{i}=h(i).getPosition;
        
%         hold on
%         Position_temp=Position{i};
%         fill(Position_temp(:,1),Position_temp(:,2),roicolor,'FaceAlpha',0,'EdgeAlpha',0.2)
%         Position_temp=[];

    end
end
for i=1:idx
    delete(h(i));
end
end