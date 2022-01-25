clc
clear all
close all
image = 'screenshot.png';
reference = "template2_fewArucos.png";
%cdata = open(image);
cdata = imread(image);

[ListaCorners] = Getcorners(image);
id = open("cornersIds.mat");
id = id.ids;
[CornersRef] = Getcorners(reference);
idtemplate = open("cornersIds.mat");
idtemplate = idtemplate.ids;

%{
[A, B, C, D] = processamento(ListaCorners);

turned =0;

if (ListaCorners(1,A) - ListaCorners(1,D))^2 + (ListaCorners(2,A) - ListaCorners(2,D))^2 < (ListaCorners(1,A) - ListaCorners(1,B))^2 + (ListaCorners(2,A) - ListaCorners(2,B))^2
    turned =1;
end

if turned == 1
    OLD = [A, B, C,D];
    A = OLD(4);
    B = OLD(1);
    C = OLD(2);
    D = OLD(3);
end

u1=[    ListaCorners(1,A),  ListaCorners(1,B),  ListaCorners(1,C),  ListaCorners(1,D)];
v1=[    ListaCorners(2,A),  ListaCorners(2,B),  ListaCorners(2,C),  ListaCorners(2,D)];
figure(1);
imagesc(cdata);hold on;
scatter(ListaCorners(1,:),ListaCorners(2,:), 'filled');
text(double(ListaCorners(1,A)),double(ListaCorners(2,A)),'A');
text(double(ListaCorners(1,B)),double(ListaCorners(2,B)),'B');
text(double(ListaCorners(1,C)),double(ListaCorners(2,C)),'C');
text(double(ListaCorners(1,D)),double(ListaCorners(2,D)),'D');

u2=[                400,                    1,                  1,                400];
v2=[                400,                  400,                  1,                  1];
%}

%{

u1=[];v1=[];
for i=1:4
    figure(1);
    [x y]=ginput(1);
    plot(x,y,'*r');
    text(x,y,int2str(i));
    u1=[u1;x];
    v1=[v1;y];
end 
%}

numArucos = size(ListaCorners,1);

A = zeros(8,9,numArucos);

refAruco = zeros(numArucos,1);

for i = 1:numArucos
    refAruco(i) = find(idtemplate == id(i));
end

lin = 1;
mat = 1;

for j = 1:4    
    for i = 1:numArucos
            A(lin,1,mat) = ListaCorners(i,1,j);
            A(lin,2,mat) = ListaCorners(i,2,j);
            A(lin,3,mat) = 1;
            A(lin,4,mat) = 0;
            A(lin,5,mat) = 0;
            A(lin,6,mat) = 0;
            A(lin,7,mat) = -ListaCorners(i,1,j)*CornersRef(refAruco(i),1,j);
            A(lin,8,mat) = -ListaCorners(i,2,j)*CornersRef(refAruco(i),1,j);
            A(lin,9,mat) = -CornersRef(refAruco(i),1,j);
            lin = lin+1;
            A(lin,1,mat) = 0;
            A(lin,2,mat) = 0;
            A(lin,3,mat) = 0;
            A(lin,4,mat) = ListaCorners(i,1,j);
            A(lin,5,mat) = ListaCorners(i,2,j);
            A(lin,6,mat) = 1;
            A(lin,7,mat) = -ListaCorners(i,1,j)*CornersRef(refAruco(i),2,j);
            A(lin,8,mat) = -ListaCorners(i,2,j)*CornersRef(refAruco(i),2,j);
            A(lin,9,mat) = -CornersRef(refAruco(i),2,j);
            
            if lin == 8
                lin = 1;
                mat = mat+1;
            else
                lin = lin+1;
            end
    end
end

Vfinal = zeros(9,1);
for i = 1:numArucos
    [U, E, V] = svd(A(:,:,i));
    Vfinal = Vfinal + V./V(end,end);
end
Vfinal = Vfinal./numArucos;

h = Vfinal(:,9);
H = reshape(h,[3,3])'; 

%{

A2 = A(:,1:8);
j=1;
b = zeros(8,1);
for i=1:4
    b(j) = u2(i);
    j = j+1;
    b(j) = v2(i);
    j = j+1;
end

H2 = (A2'*A2)^(-1)*A2'*b;
H2(9) = 1;


H2 = reshape(H2,[3,3])'; 

const = H(3,3)/H2(3,3);

H2 = H2*const;
%}

%{
X = [u1; v1; ones(1,4)];
XR = H*X;
XR(1,1) = XR(1,1)/XR(3,1);
XR(2,1) = XR(2,1)/XR(3,1);
XR(1,2) = XR(1,2)/XR(3,2);
XR(2,2) = XR(2,2)/XR(3,2);
XR(1,3) = XR(1,3)/XR(3,3);
XR(2,3) = XR(2,3)/XR(3,3);
XR(1,4) = XR(1,4)/XR(3,4);
XR(2,4) = XR(2,4)/XR(3,4);
%}

result = zeros(2339*1654,6);
n=1;
for i=1:size(cdata,2)
    for j = 1:size(cdata,1)
        vector = [i , j, 1]';
        vectorRES = H*vector;
        if 0 < round(vectorRES(1)/vectorRES(3)) && round(vectorRES(1)/vectorRES(3)) <= 1654 && 0 < round(vectorRES(2)/vectorRES(3)) && round(vectorRES(2)/vectorRES(3)) <= 2339
            result(n,1) = vectorRES(1)/vectorRES(3);
            result(n,2) = vectorRES(2)/vectorRES(3);
            result(n,4) = double(cdata(j,i,1))/255;
            result(n,5) = double(cdata(j,i,2))/255;
            result(n,6) = double(cdata(j,i,3))/255;
        	n = n+1;
        end
    end
end

%{
result2 = zeros(400,400,3);
for i=1:1551
    for j = 1:848
        vector = [i , j, 1]';
        vectorRES = H*vector;
        if 0 < round(vectorRES(1)/vectorRES(3)) && round(vectorRES(1)/vectorRES(3)) <= 400 && 0 < round(vectorRES(2)/vectorRES(3)) && round(vectorRES(2)/vectorRES(3)) <= 400
            result2(round(vectorRES(2)/vectorRES(3)),round(vectorRES(1)/vectorRES(3)),1) = cdata(j,i,1);
            result2(round(vectorRES(2)/vectorRES(3)),round(vectorRES(1)/vectorRES(3)),2) = cdata(j,i,2);
            result2(round(vectorRES(2)/vectorRES(3)),round(vectorRES(1)/vectorRES(3)),3) = cdata(j,i,3);
        end
    end
end
%} 
%esta parte é relevante para o least squares, que não está atualizado


%RGB = validatecolor([result(:,4)/255 result(:,5)/255 result(:,6)/255]);

%result(:,[1,2]) = fillmissing(result(:,[1,2]),'linear',1);
%result(:,[4,5,6]) = fillmissing(result(:,[4,5,6]),'nearest',1);

figure(2);
scatter(result(:,1),result(:,2),10, [result(:,4) result(:,5) result(:,6)], 'filled');
ax = gca;
ax.YDir = 'reverse';
%imshow(result2);


