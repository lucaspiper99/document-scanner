function final_index = compare2(rgb_images)

hists = zeros(size(rgb_images, 4),256);

for i = 1:size(rgb_images, 4)
    imageO_ = rgb_images(:,:,:,i);
    hist_val = imhist(rgb2val(imageO_));
    hists(i,:) = hist_val./sum(hist_val);
end

corrs = zeros(size(rgb_images, 4));
minsum = 100000000000;

sums = zeros(size(rgb_images, 4),1);
for i = 1:size(rgb_images, 4)
    dist_sum = 0;
    for j = 1:size(rgb_images, 4)
        histval = dist_kl(hists(i,:),hists(j,:));
        dist_sum = dist_sum + histval;
        corrs(i,j) = histval;
    end
    sums(i) = dist_sum;
    if dist_sum < minsum
        minsum = dist_sum;
    end
end

[goodim, goodent] = mink(sums,round(length(sums)/4));
minsum = 10000000000;
sums2 = zeros(length(goodent),1);

for i = 1:length(goodent)
    dist_sum = 0;
    for j = 1:length(goodent)
        histval = dist_kl(hists(goodent(i),:),hists(goodent(j),:));
        dist_sum = dist_sum + histval;
        corrs(i,j) = histval;
    end
    sums2(i) = dist_sum;
    if dist_sum < minsum
        minsum = dist_sum;
        FINAL = i;
    end
end
final_index = goodent(FINAL);
end

function imgF = rgb2hue(img)
    img = rgb2hsv(img);
    imgF = img(:,:,1);
end

function imgF = rgb2sat(img)
    img = rgb2hsv(img);
    imgF = img(:,:,2);
end

function imgF = rgb2val(img)
    img = rgb2hsv(img);
    imgF = img(:,:,2);
end


function d = dist_bhattacharyya ( h1 , h2 )%gray seems good com outliers, value meh com outliers, sat good com outliers,hue ok com outliers

d1 = sum(sqrt(h1.*h2));
d  = sqrt (1 - d1);
end


function d = dist_kl ( h1 , h2 )%grayscale maior c-outliers no linha, val SUPERBOM com out, sat SUPERBOM com out

h1(h1==0) = eps;
h2(h2==0) = eps;

d = sum(log(h1./h2).*h1);
end

function d = dist_intersection ( h1 , h2 ) % val meh, sat mehh

d = sum(min(h1,h2));
end
