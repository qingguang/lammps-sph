function h = histxie(data,nbins)
%HISTFIT Histogram with superimposed fitted normal density.
%   HISTFIT(DATA,NBINS) plots a histogram of the values in the vector DATA.
%   using NBINS bars in the histogram. With one input argument, NBINS is set 
%   to the square root of the number of elements in DATA. 
%
%   H = HISTFIT(DATA,NBINS) returns a vector of handles to the plotted lines.
%   H(1) is a handle to the histogram, H(2) is a handle to the density curve.

%   Copyright 1993-2004 The MathWorks, Inc. 
%   $Revision: 2.13.2.1 $  $Date: 2003/11/01 04:26:28 $

[row,col] = size(data);
if min(row,col) > 1
   error('stats:histfit:VectorRequired','DATA must be a vector.');
end

if row == 1
  data = data(:);
end
row = sum(~isnan(data));

if nargin < 2
  nbins = ceil(sqrt(row));
end

[n,xbin]=hist(data,nbins);
nmax=max(n);
[mu,sigma]=normfit(data);
%mu=lognpara(1);
%sigma=lognpara(2);
%mean=lognstat(mu,sigma);

mr = nanmean(data); % Estimates the parameter, MU, of the normal distribution.
sr = nanstd(data);  % Estimates the parameter, SIGMA, of the normal distribution.

x=(-3*sigma+mu:0.1*sigma:3*sigma+mu)';% Evenly spaced samples of the expected data range.

hh = bar(xbin,n/nmax,1); % Plots the histogram.  No gap between bars.
% np = get(gca,'NextPlot');    
% set(gca,'NextPlot','add')    
hold on;                             
xd = get(hh,'Xdata'); % Gets the x-data of the bins.

rangex = max(xd(:)) - min(xd(:)); % Finds the range of this data.
binwidth = rangex/nbins;    % Finds the width of each bin.

sigma=sigma/1.3;
y = normpdf(x,mu,sigma);  
y = row*(y*binwidth)/nmax;   % Normalization necessary to overplot the histogram.

hh1 = plot(x,y,'r-','LineWidth',2);     % Plots density line over histogram.

if nargout == 1
  h = [hh; hh1];
end

% set(gca,'NextPlot',np) 
% set(gca,'YScale','log')