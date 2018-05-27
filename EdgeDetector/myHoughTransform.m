function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
%Your implementation here
%Im - grayscale image - 
%threshold - prevents low gradient magnitude points from being included
%rhoRes - resolution of rhos - scalar
%thetaRes - resolution of theta - scalar
    
    %Im_th = Im > threshold;
    %imshow(Im_th);
    ImSize = size(Im);
    far = floor(sqrt(ImSize(1)^2+ImSize(2)^2));
    rhoScale = -far:rhoRes:far;
    thetaScale = -pi/2:thetaRes:pi/2;
    realThetaScale = (180/pi)*thetaRes;
    H = zeros(size(rhoScale,2), size(thetaScale,2));
    for i = 1:ImSize(1)
        for j = 1:ImSize(2)
            if Im(i,j)>threshold
                for theta = thetaScale
                    x = (theta/pi)*180;
                    rho = j*cosd(x)+i*sind(x);
                    H(floor((rho+far)/rhoRes)+1,floor((x+90)/realThetaScale)+1) = H(floor((rho+far)/rhoRes)+1,floor((x+90)/realThetaScale)+1) + 1;
                end
            end
        end
    end
end
        
        
