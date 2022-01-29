function [final_val] = diff_hist(img2compare,rgb_images)
% This function returns 1 if the image img2compare is different from the
% remaining rgb_images through histogram comparison
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

if size(rgb_images, 4) <= 2
    final_val = 0;
    
else

sums = zeros(size(rgb_images, 4),1);
sumsImg = zeros(size(rgb_images, 4),1);

hists = zeros(size(rgb_images, 4),256);
histcompare = imhist(rgb2val(img2compare));
histcompare = histcompare./sum(histcompare);

for i = 1:size(rgb_images, 4)
    imageO_ = rgb_images(:,:,:,i);
    hist_val = imhist(rgb2val(imageO_));
    hists(i,:) = hist_val./sum(hist_val);
end


for i = 1:size(rgb_images, 4)
    dist_sum = 0;
    for j = 1:size(rgb_images, 4)
        histval = dist_kl(hists(i,:),hists(j,:));
        dist_sum = dist_sum + histval;
    end
    sums(i) = dist_sum;
end

for j = 1:size(rgb_images, 4)
    sumsImg(j) = dist_kl(histcompare,hists(j,:)');
end

if sum(sumsImg,'all') > 2*min(sums)
    final_val = 1;
else
    final_val = 0;

end
end
end

function d = dist_kl ( h1 , h2 )%grayscale maior c-outliers no linha, val SUPERBOM com out, sat SUPERBOM com out

h1(h1==0) = eps;
h2(h2==0) = eps;

d = sum(log(h1./h2).*h1);
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