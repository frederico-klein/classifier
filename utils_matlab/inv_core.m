function [avp, newskel, ac,iac,av,eha]  = inv_core(tdskel, skelldef, angle)
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
    avp = f; 
else
    avp = angle; %in radians!
end

R = vecRotMat(f,[1 0 0 ]);
Rl = vecRotMat([1 0 0 ],f);

newskel2 = (R*tdskel.').'; %%% now this is hopefully 

if show
skeldraw(newskel2(1:15,:),'f');
end

% it's going to be flipped in x!
% newskel3 = newskel2;
% newskel3(:,1) = -newskel3(:,1);
newskel3 = mirrorx(newskel2,skelldef);


%now we need to undo the rotation
newskel4 = (Rl*newskel3.').';

newskel = newskel4;
%skeldraw(newskel1(1:15,:),'f');
%skeldraw(newskel4(1:15,:),'f');
if show
skeldraw(newskel4(1:15,:),'f');
end
%end
ac = newskel4(skelldef.bodyparts.HEAD,:);

ers = newskel4(skelldef.bodyparts.RIGHT_SHOULDER,:);
erh = newskel4(skelldef.bodyparts.RIGHT_HIP,:);
els = newskel4(skelldef.bodyparts.LEFT_SHOULDER,:);
elh = newskel4(skelldef.bodyparts.LEFT_HIP,:);

eha = (ers+erh-(els+elh))/2;

iac = tdskel(skelldef.bodyparts.HEAD,:);
end