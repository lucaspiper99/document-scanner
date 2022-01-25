function [A, B, C, D] = processamento(ListaCorners)

%A x = 400 y = 400 (400,400) Bottom Right
maxX = 0
maxY = 0
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(1,i) >= maxX
        maxX = ListaCorners(1,i);
        A = i;
    end
end
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(1,i) >= maxX
        if ListaCorners(2,i) >= maxY
            maxY = ListaCorners(1,i);
            A = i;
        end
    end
end

%B x = 1 y = 400 (400,1) Bottom LEFT

minX = max(ListaCorners(1,:));
maxY = 0;
for i = 1:length(ListaCorners(2,:))
    if ListaCorners(2,i) >= maxY
        maxY = ListaCorners(2,i);
        B = i;
    end
end
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(2,i) >= maxY
        maxY = ListaCorners(2,i)
        if ListaCorners(2,i) <= minX
            minX = ListaCorners(1,i);
            B = i;
        end
    end
end

%C x = 1 y = 1 (1,1) TOP LEFT

minX = max(ListaCorners(1,:));
minY = max(ListaCorners(2,:));
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(1,i) <= minX
        minX = ListaCorners(1,i);
        C = i;
    end
end
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(1,i) <= minX
        if ListaCorners(2,i) <= minY
            minY = ListaCorners(2,i);
            C = i;
        end
    end
end

%D x = 400 y = 1 (1,400) TOP RIGHT

maxX = 0;
minY = max(ListaCorners(2,:));
for i = 1:length(ListaCorners(2,:))
    if ListaCorners(2,i) <= minY
        minY = ListaCorners(2,i);
        D = i;
    end
end
for i = 1:length(ListaCorners(1,:))
    if ListaCorners(2,i) <= minY
        if ListaCorners(1,i) >= maxX
            maxX = ListaCorners(1,i);
            D = i;
        end
    end
end

end