function [Im Io Ix Iy] = myEdgeFilter(img, sigma)
%Your implemention
    G = fspecial('gaussian',2*ceil(3*sigma)+1,sigma);
    %imshow(img);
    img = myImageFilter(img, G);
    %img = imfilter(img, G);
    
    xSobel = [1,0,-1;2,0,-2;1,0,-1]/8;
    ySobel = [1,2,1;0,0,0;-1,-2,-1]/8;
    Ix = myImageFilter(img, xSobel);
    %Ix = conv2(img, xSobel);
    Iy = myImageFilter(img, ySobel);
    %Iy = conv2(img, ySobel);
    Im = sqrt(Ix.^2 + Iy.^2);
    %imshow(Im);
    Io = atan2(Iy,Ix);
    ImNew = Im;
    sizeIm = size(Im);
    %{%}
    for i = 1:sizeIm(1)
        ImNew(i,1) = 0;
        ImNew(i,sizeIm(2)) = 0;
    end
    for i = 1:sizeIm(2)
        ImNew(1,i) = 0;
        ImNew(sizeIm(1),i) = 0;
    end
    for i = 2:sizeIm(1)-1
        for j = 2:sizeIm(2)-1
            z = Io(i,j);
            x = mod(z, pi);
            y = Im(i,j);
            if (x < 0.3925) || (2.7475<=x)
                if (y<Im(i,j-1)) || (y<Im(i,j+1))
                    ImNew(i,j) = 0;
                end
            elseif 0.3925 <= x && x < 1.1775
                if (y<Im(i-1,j-1)) || (y<Im(i+1,j+1))
                    ImNew(i,j) = 0;
                end
            elseif 1.1775 <= x && x < 1.9625
                if (y<Im(i-1,j)) || (y<Im(i+1,j))
                    ImNew(i,j) = 0;
                end
            elseif 1.9625 <= x && x < 2.7475 
                if (y<Im(i+1,j-1)) || (y<Im(i-1,j+1))
                    ImNew(i,j) = 0;
                end
            end
        end
    end
    %{%}
    
    %imshow(ImNew);
    %imshow(ImNew/max(ImNew(:)));
    %impixelinfo(ImNew);
    Im = ImNew;
end
    
                
        
        
