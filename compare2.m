function FINAL = compare2(output_path, current_img, last2compare)

files = dir(fullfile(output_path));
names = strings(length(files),1);
hists = zeros(length(files),256);

for i = 1:(current_img-last2compare) 
    if files(i).isdir == 0
        imageO_ = imread(append(output_path,'\',files(i).name));
        names(i) = string(files(i).name);
        histhue = imhist(rgb2val(imageO_));
        hists(i,:) = histhue./sum(histhue);
    end
end

corrs = zeros(length(files));
minsum = 100000000000;

sums = zeros(length(files),1);
for i = 3:length(files)
    sum = 0;
    for j = 3:length(files)
        histval = dist_kl(hists(i,:),hists(j,:));
        sum = sum + histval;
        corrs(i,j) = histval;
    end
    sums(i) = sum;
    if sum < minsum
        minsum = sum;
    end
end

[goodim, goodent] = maxk(sums,round(length(sums)/5));
minsum = 10000000000;
sums2 = zeros(length(goodent),1);

for i = 1:length(goodent)
    sum = 0;
    for j = 1:length(goodent)
        histval = dist_kl(hists(goodent(i),:),hists(goodent(j),:));
        sum = sum + histval;
        corrs(i,j) = histval;
    end
    sums2(i) = sum;
    if sum < minsum
        minsum = sum;
        FINAL = i;
    end
end

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
