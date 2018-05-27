function [ composite_img ] = compositeH(H2to1, template, img)

% composite_img = imfuse(template, img,'blend','Scaling','none');
% composite_img = imadd(template, img);
composite_img = template;
for i=1:size(img,1)
    for j=1:size(img,2)
        if img(i,j,:) == [255;255;255]
            continue;
        elseif img(i,j,:) == [0;0;0]
            continue;
        end
        composite_img(i,j,:) = img(i,j,:);
    end
end

end