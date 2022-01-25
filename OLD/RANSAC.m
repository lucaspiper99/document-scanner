clc;
clear all;
close all;

load('dataRANSAC.mat');

inliersMAX = 0;
n = 4;
PS = 0.9;
PI = 0.7;
k = uint32(log(1-PS)/log(1-PI^4));
InlierList = zeros(size(indexPairs,1),3);
InlierBestList = zeros(size(indexPairs,1),3);

for i =1:k
    Points = zeros(n,2);
    %for j=1:n
    j=1;
        r1 = uint32(rand()*(size(indexPairs,1)-1)+1);
        
        Points(j,1) = indexPairs(r1,1);
        Points(j,2) = indexPairs(r1,2);
        
        r2 = uint32(rand()*(size(indexPairs,1)-1)+1);
        while r2 == r1
            r2 = uint32(rand()*(size(indexPairs,1)-1)+1);
        end
        
        Points(j+1,1) = indexPairs(r2,1);
        Points(j+1,2) = indexPairs(r2,2);
        
        r3 = uint32(rand()*(size(indexPairs,1)-1)+1);
        while r3 == r1 | r3 == r2
            r3 = uint32(rand()*(size(indexPairs,1)-1)+1);
        end
        
        Points(j+2,1) = indexPairs(r3,1);
        Points(j+2,2) = indexPairs(r3,2);
        
        r4 = uint32(rand()*(size(indexPairs,1)-1)+1);
        while r4 == r1 | r4 == r2 | r4 == r3
            r4 = uint32(rand()*(size(indexPairs,1)-1)+1);
        end
        Points(j+3,1) = indexPairs(r4,1);
        Points(j+3,2) = indexPairs(r4,2);
    %end
    H = homography([REF.Location(Points(:,1),1),REF.Location(Points(:,1),2)], [IMG.Location(Points(:,2),1),IMG.Location(Points(:,2),2)]);
    inliers = 0;
    for j = 1:size(indexPairs,1)
        Vector = H*[REF.Location(j,1);REF.Location(j,2);1];
        if Vector(1)/Vector(3) - IMG.Location(j,1) < 0.01 && Vector(2)/Vector(3) - IMG.Location(j,2) < 0.01
            inliers = inliers + 1;
            InlierList(inliers,1) = j;
        end
    end
    if inliers > inliersMAX
        inliersMAX = inliers;
        BestModel = H;
        InlierBestList = InlierList;
    end
end


%for j = 1:length(InlierBestList)
 %       if InlierBestList(j,1) == 0 && InlierBestList(j,2) == 0 && InlierBestList(j,3) == 0 
  %          InlierBestList = InlierBestList(1:(j-1),:);
   %         break
    %    end
    %end




[X,Y] = meshgrid(-3:.1:3);
Z = BestModel(1)*X+BestModel(2)*Y+BestModel(3);
figure(1);
scatter3(xyz(:,1),xyz(:,2),xyz(:,3),'.');
hold on,
scatter3(InlierBestList(:,1),InlierBestList(:,2),InlierBestList(:,3),'.','red');
mesh(X,Y,Z);
hold off;
%%
inliersMAX = 0;
InlierList = zeros(length(xyz),3);


for i =1:k
    Points = zeros(n,3);
    for j=1:n
        r = uint32(rand()*(length(InlierBestList)-1)+1);
        Points(j,1) = InlierBestList(r,1);
        Points(j,2) = InlierBestList(r,2);
        Points(j,3) = InlierBestList(r,3);
    end
    [A, B, C] = planar(Points);
    inliers = 0;
    for j = 1:length(InlierBestList)
        if InlierBestList(r,1) ~= 0 && InlierBestList(r,2) ~= 0 && InlierBestList(r,3) ~= 0 
            if abs(InlierBestList(j,1)*A+InlierBestList(j,2)*B+C - InlierBestList(j,3))< 0.01
                inliers = inliers + 1;
                InlierList(inliers,1) = InlierBestList(j,1);
                InlierList(inliers,2) = InlierBestList(j,2);
                InlierList(inliers,3) = InlierBestList(j,3);
            end
        end
    end
    if inliers > inliersMAX
        inliersMAX = inliers;
        BestModel2 = [A, B, C];
        InlierBestList2 = InlierList;
    end
end

for j = 1:length(InlierBestList2)
        if InlierBestList2(j,1) == 0 && InlierBestList2(j,2) == 0 && InlierBestList2(j,3) == 0 
            InlierBestList2 = InlierBestList2(1:(j-1),:);
            break
        end
    end


[X,Y] = meshgrid(-3:.1:3);
Z = BestModel2(1)*X+BestModel2(2)*Y+BestModel2(3);

figure(2);
hold on,
scatter3(xyz(:,1),xyz(:,2),xyz(:,3),'.');
scatter3(InlierBestList2(:,1),InlierBestList2(:,2),InlierBestList2(:,3),'.','green');
mesh(X,Y,Z);
hold off;

