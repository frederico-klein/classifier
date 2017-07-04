function plotconf_shaded(varargin)
numformat = '%0.0f';
%numformat = '%0.2f';
zeros_are_blanks = true;
if nargin==1
    mat = varargin{1};
    limx = size(mat,2);
    limy = size(mat,1);
    %%% creates labels:
    labx = cell(1,limx);
    laby = cell(1,limy);
    labx(1:5) = {'A','B','C','D','E'};
    laby(1:5) = {'A','B','C','D','E'};
elseif nargin==2
    mat = varargin{1};
    limx = size(mat,2);
    limy = size(mat,1);
    %%% creates labels:
    lab = varargin{2};
    labx = lab;
    laby = lab;
end
for i = 1:size(mat,3)
    subplot(1,size(mat,3),i)
    %mat = rand(5);           %# A 5-by-5 matrix of random values from 0 to 1
    mati = mat(:,:,i);
    imagesc(mati);            %# Create a colored plot of the matrix values
    colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
    %#   black and lower values are white)
    
    textStrings = num2str(mati(:),numformat);  %# Create strings from the matrix values
    zeroString = num2str(0,numformat);
    textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
    
    if zeros_are_blanks
        % ## New code: ###
        idx = find(strcmp(textStrings(:), zeroString));
        textStrings(idx) = {'   '};
        % ################
    end
    
    [x,y] = meshgrid(1:limx,1:limy);   %# Create x and y coordinates for the strings
    hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
        'HorizontalAlignment','center');
    midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
    textColors = repmat(mati(:) > midValue,1,3);  %# Choose white or black for the
    %#   text color of the strings so
    %#   they can be easily seen over
    %#   the background color
    set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
    
    set(gca,'XTick',1:limx,...                         %# Change the axes tick marks
        'XTickLabel',labx,...  %#   and tick labels
        'YTick',1:limy,...
        'YTickLabel',laby,...
        'TickLength',[0 0]);
end