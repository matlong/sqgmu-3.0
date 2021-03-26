function c = inner_product(x, y, W)
% Calculate L2 inner product of x and y associated with the weighting
% matrix W.
%
% Written by Long Li - 2020/12/01
%

c = x'*W*y;

end