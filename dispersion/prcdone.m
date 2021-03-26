function prcdone(iloop,itot,title,dprc)
%PRCDONE calculate the percentage of loop done in a running loop
%   PRCDONE(ILOOP,ITOT,DPRC) convert iloop into iloop/itot*100% and display
%      the result by dprc incrementations
%      ILOOP is the current loop id (assumes iloop = 1:itot)
%      ITOT is the total number of iterations
%      TITLE (string, optional) is the title of the loop for display
%         If using dprc set title to '' if you don't want a title
%      DPRC (optional) is the incrementations to display (in %).
%         Default is 10%
%      Warning: this script will add time on your loop

if nargin<3
    title = ' ';
end

if nargin<4
    dprc=10;
end

frac_now = dprc*(ceil(iloop/itot*100/dprc));
frac_next = dprc*(ceil((iloop+1)/itot*100/dprc));

if iloop == 1
    disp(['Starting ' title ' loop'])
elseif iloop==itot
    disp(['Done ' title ' loop'])
elseif frac_next>frac_now
    disp([num2str(frac_now) '% completed'])
end