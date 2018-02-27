function [avp, newskel, ac,iac,av,eha, newskel5, newskel1, newskel2pol, newskel3pol]  = polar_core(tdskel, skelldef, angle)
%newskel3 = zeros(size(tdskel));
%lets break this down into steps so that I don't mess up
%if isempty(angle)
    show = false;
%else
%    show = true;
%end
if show 
figure
skeldraw(tdskel(1:15,:),'f');hold on;
end
%for i = 0:.01:1
%first change y with z
newskel1(:,1) = tdskel(:,1);
newskel1(:,2) = tdskel(:,3);
newskel1(:,3) = tdskel(:,2);

%put into polar coordinates
[newskel2pol(:,1),newskel2pol(:,2),newskel2pol(:,3)] = cart2pol(newskel1(:,1),newskel1(:,2),newskel1(:,3));

%make a new skeleton that will have the smallest mean theta
newskel3pol = newskel2pol;

%newskel3pol(:,1) = newskel2pol(:,1)-i;%mean(newskel2pol(:,1));
%newskel3pol(:,1) = newskel2pol(:,1)-mean(newskel2pol(:,1));
%maybe using the means of angles is not a good idea. what about using the
%means of their signs and cosines and then just guessing the angle back
%with atan2?

rs = tdskel(skelldef.bodyparts.RIGHT_SHOULDER,:);
rh = tdskel(skelldef.bodyparts.RIGHT_HIP,:);
ls = tdskel(skelldef.bodyparts.LEFT_SHOULDER,:);
lh = tdskel(skelldef.bodyparts.LEFT_HIP,:);

av = (rs+rh-(ls+lh))/2;

f = av/norm(av); %% normalized vector for rotation. I know rotation makes things horrible, but let's hope for the best. 

if show
plot3([0 av(1)],[0 av(2)],[0 av(3)],'r')
end

if isempty(angle)
    [avp(1),avp(2),avp(3)] = cart2pol(av(1),av(3),av(2)); %%% this is y-z switched!
    [fp(1),fp(2),fp(3)] = cart2pol(f(1),f(3),f(2)); %%% this is y-z switched!

else
    avp = angle; %in radians!
    [av(1),av(2),av(3)] = pol2cart(angle);
    f = av/norm(av); %% normalized vector for rotation. I know rotation makes things horrible, but let's hope for the best. 
    [fp(1),fp(2),fp(3)] = cart2pol(f(1),f(3),f(2)); %%% this is y-z switched!
end

newskel3pol(:,1) = newskel2pol(:,1)-avp(1);




%put it back into cartesian coordinates
[newskel4(:,1),newskel4(:,2),newskel4(:,3)] = pol2cart(newskel3pol(:,1),newskel3pol(:,2),newskel3pol(:,3));

%invert y and z again
newskel5(:,1) = newskel4(:,1);
newskel5(:,2) = newskel4(:,3);
newskel5(:,3) = newskel4(:,2);

newskel = newskel5;
%skeldraw(newskel1(1:15,:),'f');
%skeldraw(newskel4(1:15,:),'f');
if show
skeldraw(newskel5(1:15,:),'f');
end
%end
ac = newskel5(skelldef.bodyparts.HEAD,:);

ers = newskel5(skelldef.bodyparts.RIGHT_SHOULDER,:);
erh = newskel5(skelldef.bodyparts.RIGHT_HIP,:);
els = newskel5(skelldef.bodyparts.LEFT_SHOULDER,:);
elh = newskel5(skelldef.bodyparts.LEFT_HIP,:);

eha = (ers+erh-(els+elh))/2;

iac = tdskel(skelldef.bodyparts.HEAD,:);
end