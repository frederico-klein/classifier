function newskel = bettermirror(tdskel, skelldef)
% just a wrapper for my improved mirroring function. 
[~, newskel]  = inv_core(tdskel, skelldef, []);
if 0
skeldraw(tdskel(1:15,:),'f','W','m')
skeldraw(newskel(1:15,:),'f','A','m')
end