function [final_index] = most_similar_hist(img2compare,rgb_images)
% This function creates the final RGB image from the homography matrix (H),
% the size of the template (ref_h and ref_w) and the original RGB image
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

hists = zeros(size(rgb_images, 4),256);
histcompare = imhist(rgb2val(img2compare));
histcompare = histcompare./sum(histcompare);

for i = 1:size(rgb_images, 4)
    imageO_ = rgb_images(:,:,:,i);
    hist_val = imhist(rgb2val(imageO_));
    hists(i,:) = hist_val./sum(hist_val);
end

sums = zeros(size(rgb_images, 4),1);

for j = 1:size(rgb_images, 4)
    sums(j) = dist_kl(histcompare',hists(j,:));
    %corrs(i,j) = histval;   
end

[goodim, final_index] = min(sums);

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