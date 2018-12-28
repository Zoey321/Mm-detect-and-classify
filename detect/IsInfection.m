function [circleBioMarker,subRegion,area] = IsInfection(circen,cirrad,im,bioMarker,threCircle)
% This is for infected group. Since not all of the cells are infected, the
% uninfected need to be rejected.The determination is based on the
% bioMarker.
%
%  INPUT: (circen,cirrad,im,bioMarker,threCircle)
%  circen:    Center of the circle
%  cirrad:       Radius of the circle
%  im:    image in white light
%  bioMarker: image of fluorescence
%  threCircle: additional constent, 0-5 is appropriate.
%
%  OUTPUT: (circleBioMarker,subRegion,area)
%
%  Author:  Xinzhuo Zhao
%           BMIE, Northeastern University,Shenyang,110869,China
%           xzhzhao@mail.neu.edu.cn



circleBioMarker = [];
subRegion = [];
area = [];
for i = 1:length(cirrad)
    if cirrad(i) == 0
        area(i,1) = 0;
    else
        subImg = imcrop(im,[circen(i,1)-cirrad(i)-threCircle/2,...,
            circen(i,2)-cirrad(i)-threCircle/2,cirrad(i)*2+threCircle, cirrad(i)*2+threCircle]);
        subBioMarker = imcrop(bioMarker,[circen(i,1)-cirrad(i)-threCircle/2,...,
            circen(i,2)-cirrad(i)-threCircle/2,cirrad(i)*2+threCircle, cirrad(i)*2+threCircle]);
        if circen(i,1) < cirrad(i)+threCircle/2
            m1 = -circen(i,1) : cirrad(i)*2+threCircle - circen(i,1);
            n1 = -cirrad(i)-threCircle/2 : cirrad(i)+threCircle/2;
        elseif circen(i,2) < cirrad(i)+threCircle/2
            m1 = -cirrad(i)-threCircle/2 : cirrad(i)+threCircle/2;
            n1 = -circen(i,2) : cirrad(i)*2+threCircle-circen(i,2);
        else
            m1 = -cirrad(i)-threCircle/2 : cirrad(i)+threCircle/2;
            n1 = -cirrad(i)-threCircle/2 : cirrad(i)+threCircle/2;
        end
        [x,y]=meshgrid(m1,n1);
        circle=x.^2+y.^2;
        mask=zeros(size(circle));
        mask(find(circle<=cirrad(i)^2))=1;  %find the pixel inside the circle
        mask(find(circle>cirrad(i)^2))=0;
        mask = mask(1:size(subImg,1),1:size(subImg,2));
        
        subRegion{i,1} = mask .* double(subImg);
        circleBioMarker{i,1} = mask .* double(subBioMarker);
        area(i,1) = sum(sum(circleBioMarker{end,1}));
        
        %         figure();
        %                     subplot(1,4,1);imshow(subImg,[]);
        %                     subplot(1,4,2);imshowpair(subImg,subBioMarker,'falsecolor');
        %                     subplot(1,4,3);imshow(subRegion{i,1},[]);
        %                     subplot(1,4,4);imshow(circleBioMarker{i,1},[]);
        %         end
    end
end

end
