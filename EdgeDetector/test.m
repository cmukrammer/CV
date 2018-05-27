clear;

datadir     = '../data';    %the directory containing the images
resultsdir  = '../results'; %the directory for dumping results

%parameters
sigma     = 2;
threshold = 0.01;
rhoRes    = 2;
thetaRes  = pi/90;
nLines    = 1000;
%end of parameters

imglist = dir(sprintf('%s/img02.jpg', datadir));

for i = 1:numel(imglist)
    
    %read in images%
    [path, imgname, dummy] = fileparts(imglist(i).name);
    img = imread(sprintf('%s/%s', datadir, imglist(i).name));
    
    if (ndims(img) == 3)
        img = rgb2gray(img);
    end
    
    %imshow(img);
    img = double(img) / 255;
    %img = double(img);
    
    
    [Im Io Ix Iy] = myEdgeFilter(img, sigma);
%     Im = edge(img);
    imshow(Im>threshold);
    %thetaRes = pi/4500;
    %[H,rhoScale,thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes);
    %thetaScale = 180*(thetaScale/pi);
    [H,thetaScale,rhoScale] = hough(Im, 'RhoResolution',rhoRes,'ThetaResolution',thetaRes);
    %thetaScale = (thetaScale*pi)/180;
    
    %[rhos, thetas] = myHoughLines(H, nLines);
    peaks = houghpeaks(H, nLines, 'threshold',threshold);
    
    %lines = houghlines(Im>threshold, 180*(thetaScale/pi), rhoScale, [rhos,thetas],'FillGap',5,'MinLength',10);
    lines = houghlines(Im>threshold, thetaScale, rhoScale, peaks,'FillGap',5,'MinLength',10);
    
    img2 = img;
    for j=1:numel(lines)
       img2 = drawLine(img2, lines(j).point1, lines(j).point2); 
    end
    imshow(img2);
    break;
end