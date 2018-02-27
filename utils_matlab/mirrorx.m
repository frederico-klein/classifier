function newskel = mirrorx(tdskel, skelldef)
newskel1 = tdskel;
newskel1(:,1) = -tdskel(:,1);
% if strcmp(skelldef.currlayer,'all')
%     a = [0 15];
% else
%     a = 0;
% end
if ~(skelldef.length==90||skelldef.length==45)
    error('unexpected skeleton definition. this function was just coded for 15 joint skeletons, other uses will fail. update left-right flipping, or change the skelldef to have hemibodies and change that. this is probably the simplest way to go about it, but all the conformation functions (and anything that uses skelldef) will need to be changed as well. This should probably have been defined as a class. ')
end
a = (0:(floor(size(tdskel,1)/15)-1))*15;

for i = a
    newskel(skelldef.bodyparts.HEAD+i,:) = newskel1(skelldef.bodyparts.HEAD+i,:);
    newskel(skelldef.bodyparts.NECK+i,:) = newskel1(skelldef.bodyparts.NECK+i,:);
    newskel(skelldef.bodyparts.TORSO+i,:) = newskel1(skelldef.bodyparts.TORSO+i,:);
    newskel(skelldef.bodyparts.LEFT_SHOULDER+i,:) = newskel1(skelldef.bodyparts.RIGHT_SHOULDER+i,:);
    newskel(skelldef.bodyparts.LEFT_ELBOW+i,:) = newskel1(skelldef.bodyparts.RIGHT_ELBOW+i,:);
    newskel(skelldef.bodyparts.RIGHT_SHOULDER+i,:) = newskel1(skelldef.bodyparts.LEFT_SHOULDER+i,:);
    newskel(skelldef.bodyparts.RIGHT_ELBOW+i,:) = newskel1(skelldef.bodyparts.LEFT_ELBOW+i,:);
    newskel(skelldef.bodyparts.LEFT_HIP+i,:) = newskel1(skelldef.bodyparts.RIGHT_HIP+i,:);
    newskel(skelldef.bodyparts.LEFT_KNEE+i,:) = newskel1(skelldef.bodyparts.RIGHT_KNEE+i,:);
    newskel(skelldef.bodyparts.RIGHT_HIP+i,:) = newskel1(skelldef.bodyparts.LEFT_HIP+i,:);
    newskel(skelldef.bodyparts.RIGHT_KNEE+i,:) = newskel1(skelldef.bodyparts.LEFT_KNEE+i,:);
    newskel(skelldef.bodyparts.LEFT_HAND+i,:) = newskel1(skelldef.bodyparts.RIGHT_HAND+i,:);
    newskel(skelldef.bodyparts.RIGHT_HAND+i,:) = newskel1(skelldef.bodyparts.LEFT_HAND+i,:);
    newskel(skelldef.bodyparts.LEFT_FOOT+i,:) = newskel1(skelldef.bodyparts.RIGHT_FOOT+i,:);
    newskel(skelldef.bodyparts.RIGHT_FOOT+i,:) = newskel1(skelldef.bodyparts.LEFT_FOOT+i,:);
end
end