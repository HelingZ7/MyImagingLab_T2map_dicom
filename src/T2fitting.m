function cfit=T2fitting(y,TE,plotswitch,rsquare)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 5.0
% Original code from Rami R. Hallac, Ph.D.
% Modified on 01/17/2018 by Heling Zhou, Ph.D.
% Email: helingzhou7@gmail.com
% Generate T2 curve fitting parameters
% y is a vector of signal intensity
% TE is echo times. te and y are same size
% plotswitch (default 'on') can be set to 'on' or 'off'
% rsquare (default 0.8)determines the minimal acceptable fittting quality
% if curve fitting produced rsquare less than the minimal requirement,
%    parameters of cfit (T2, S0 and k) are set to NaN. 
% example: cfit=T2fitting(y,TE)
% cfit=T2fitting(y,TE,plotswitch)
% cfit=T2fitting(y,TE,plotswitch,rsquare)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==2
    plotswitch='on';
    rsquare=0.8;
elseif nargin==3
    rsquare=0.8;
end
TE=double(TE(:));
ct=@(TE,S0,T2,k)S0.*exp(-TE/T2)+k;
cts=strcat('S0.*exp(-TE/T2)+k');
y=double(y(:));
%%
ok_ = isfinite(TE) & isfinite(y);
st_ = [((y(1)-y(end))^(TE(2)/(TE(2)-TE(1))))/((y(2)-y(end))^(TE(1)/(TE(2)-TE(1)))), (TE(3)-TE(1))/log(y(1)/y(3)), mean(y(end-3:2:end))];
if st_(2)<1 || st_(2)>100 || isnan(st_(2))|| isinf(st_(2))
    st_(2)=TE(3);
end
sopt = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[0,0,0],...
    'Upper',[Inf,Inf,Inf],...
    'MaxFunEvals',3000,...
    'DiffMinChange',10^(-10));

ft_ = fittype('S0.*exp(-TE/T2)+k',...
    'options',sopt,...
    'dependent',{'y'},'independent',{'TE'},...
    'coefficients',{'S0', 'T2','k'});

% Fit this model using new data

[cfit,gof] = fit(TE(ok_),y(ok_),ft_,'Startpoint',st_);
S0=cfit.S0;T2=cfit.T2;k=cfit.k;
% funct=ct(TE,cfit.S0,cfit.T2);
funct=ct(0:1:max(TE),cfit.S0,cfit.T2,cfit.k);
% test_dc=test-mean(test(end-20:end));
% areas=step*max(cumsum(test_dc(cfit.x0+1:end)))
%cfit

%figure2 = figure;
if strcmp(plotswitch,'on')
    plot(TE,y,'o','LineWidth',2,'MarkerSize',10)
    hold on
    axis_setting1
    plot(0:1:max(TE),funct,'r','LineWidth',2)
    %plot(funs,'g')
    axis_setting1
    
    ha=annotation('textbox',[.55,.55,.2,.2]);
    set(ha,'string',...
        sprintf(strcat('S_0=', num2str(cfit.S0*1000,'%6.1f'),'\n', 'k=', num2str(cfit.k,'%0.2e'),'\n','T_2*=', num2str(cfit.T2,'%6.2f'),'ms',...
        '\n', 'rmse=', num2str(gof.rmse,'%0.2e'),'\n', 'Rsquare=', num2str(gof.rsquare,'%6.2f'))),...
        'LineStyle','none',...
        'FontSize',12,'FontWeight','bold');
elseif strcmp(plotswitch,'off')
end
% h_ = plot(cfit,'fit',0.95);
% legend off;  % turn off legend from plot method call
% set(h_(1),'Color',[1 0 0],...
%     'LineStyle','-', 'LineWidth',2,...
%     'Marker','none', 'MarkerSize',6);
% legh_(end+1) = h_(1);
% legt_{end+1} = 'fit 1';
if gof.rsquare<rsquare
    cfit.T2=nan;
    cfit.S0=nan;
    cfit.k=nan;
end
end

