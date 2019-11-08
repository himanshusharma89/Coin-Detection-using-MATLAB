function houghcircle = HoughCoin(imbin,rmin,rmax,p)
if nargin==3
    p = 0.25; % accumulation to a quarter circle included
elseif nargin < 3
    error('you should have more input arguements');
    return;
end

% initial setting
[y0,x0] = find(imbin);  % the edge pixel number
[sy,sx] = size(imbin);
totalpix = length(x0);
d = 2*rmax; 
accumulator = zeros(size(imbin,1)+d,size(imbin,2)+d,rmax-rmin+1);  % enlarge search area to rmax for each edge plus origin

% choose the potential circle center according to the white edge pixel
% circles location, it will not exceed the maximum radius position
% the largest dis in dectection area of each center
[m,n]=meshgrid(0:d,0:d);  % only detect the square area of any points of the circle 
rx = sqrt((m-rmax).^2+(n-rmax).^2); % the distance of the square is 2*rmax
R = round(rx);
R(R<rmin | R>rmax)=0;
[ry,rx,r_poten]= find(R);

for cnt= 1:totalpix
   ind = sub2ind(size(accumulator),ry+y0(cnt)-1,rx+x0(cnt)-1,r_poten-rmin+1);
   accumulator(ind) = accumulator(ind)+1;
end


% find the local maximum value of accumulator
% get rid of count less than a quarter of circle 
houghcircle = []; % create a null matrix to add each filtered circle
c = 2*pi;
for radius = rmin:rmax
    rlayer = accumulator(:,:,radius-rmin+1);% rlayer is the counter divided by radius 
    l = c*radius;
    rlayer(rlayer/l<p)=0;            % if the accumulated point number does not account to a quarter circle, delete them
    [ln,lm,num]= find(rlayer);
    ratio= num/l;                    % ratio higher means the the possibility of center higher
    houghcircle = [houghcircle;[lm-rmax, ln-rmax, radius*ones(length(lm),1),ratio]];
end
    

dist = 0.5*(rmin+rmax);  % set as the mean value of radius
% Delete potential similar circles
houghcircle = sortrows(houghcircle,-4);  % Descending sort according to possibility

for i=1:size(houghcircle,1)-1
    j = i+1;
    while j<= size(houghcircle,1)
          if sum(abs(houghcircle(i,1:2)-houghcircle(j,1:2)))/2 <= dist
             houghcircle(j,:) = [];
          else
          j = j+1;
          end
    end
end
