function roi_para_drawing(varargin)
% Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
% overlay outline of polygon rois on image
% examples: 
% roi_para_drawing(Position)
% roi_para_drawing(Position, num_of_rois_to_draw)
% roi_para_drawing(Position, num_of_rois_to_draw, line_style)

Position=varargin{1};

if nargin==3
    idx=varargin{2};
    line_style=varargin{3};
elseif nargin==2
    idx=varargin{2};
    line_style='-';
elseif nargin==1
    idx=length(Position);
    line_style='-';
end
for i=1:idx
    roicolor=colorseq(i);
    Position_temp=Position{i};
    fill(Position_temp(:,1),Position_temp(:,2),roicolor,...
        'LineWidth',1.5,'LineStyle',line_style,...
        'EdgeColor',roicolor,...
    'FaceAlpha',0,'EdgeAlpha',1)
    Position_temp=[];
end
end