function [rhos, thetas] = myHoughLines(H, nLines)
%Your implemention here
    H = padarray(H, [1 1]);
    newH = H;
    hSize = size(H);
    for i = 2:hSize(1)-1
        for j = 2:hSize(2)-1
            t = H(i,j);
            if H(i-1,j-1)>=t || H(i-1,j)>=t || H(i-1,j+1)>=t || H(i,j-1)>=t || H(i,j+1)>=t || H(i+1,j-1)>=t || H(i+1,j)>=t || H(i+1,j+1)>=t
                newH(i,j) = 0;
            end
        end
    end
    newH = newH(2:hSize(1)-1,2:hSize(2)-1);
    sortedValues = sort(newH(:),'descend');
    sortedValues = sortedValues(1:nLines, 1);
    num = 0;
    rhos = zeros(nLines,1);
    thetas = zeros(nLines,1);
    while(num < nLines)
        num = num + 1;
        [r,c] = find(newH==sortedValues(num));
        newH(r(1),c(1)) = 0;
        rhos(num,1) = r(1);
        thetas(num,1) = c(1);
    end
    
end
        