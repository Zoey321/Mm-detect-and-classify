%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This is used to crop the training and testing patches.
%  Last updated: 12/01/2018
%  Author: Xinzhuo Zhao
%  https://www.researchgate.net/profile/Xinzhuo_Zhao3/research
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
threCircle = 4;
time = 2;
class = 1;
sourcePath = ['Detect/',num2str(time),'/',num2str(class),'/'];
resultPath = ['Result/',num2str(time),'/',num2str(class),'/'];
mkdir(resultPath);
if class == 0
    n = (length(dir(sourcePath))-2)/3;
else
    n = (length(dir(sourcePath))-2)/5;
end
for num = 1:n
    if num < 10
        if ~exist([sourcePath,'cirrad0',num2str(num),'.mat'])
            continue;
        end
        load([sourcePath,'cirrad0',num2str(num),'.mat']);
        load([sourcePath,'circen0',num2str(num),'.mat']);
        load([sourcePath,'bioMarker0',num2str(num),'.mat']);
        load([sourcePath,'im0',num2str(num),'.mat']);
    else
        if ~exist([sourcePath,'cirrad',num2str(num),'.mat'])
            continue;
        end
        load([sourcePath,'cirrad',num2str(num),'.mat']);
        load([sourcePath,'circen',num2str(num),'.mat']);
        load([sourcePath,'bioMarker',num2str(num),'.mat']);
        load([sourcePath,'im',num2str(num),'.mat']);
    end
    im = double(im);
    im = (im - min(im(:)))/(max(im(:))-min(im(:)));

    for i = 2:length(cirradDouble)
        subImg = imcrop(im,[circenDouble(i,1)-cirradDouble(i)-threCircle/2,...,
            circenDouble(i,2)-cirradDouble(i)-threCircle/2,...,
            cirradDouble(i)*2+threCircle, cirradDouble(i)*2+threCircle]);
        subBioMarker = imcrop(bioMarker,[circenDouble(i,1)-cirradDouble(i)-threCircle/2,...,
            circenDouble(i,2)-cirradDouble(i)-threCircle/2,cirradDouble(i)*2+threCircle,...,
            cirradDouble(i)*2+threCircle]);
        if class == 1 || class == 2
            if circenDouble(i,1) < cirradDouble(i)+threCircle/2
                m1 = -circenDouble(i,1) : cirradDouble(i)*2+threCircle - circenDouble(i,1);
                n1 = -cirradDouble(i)-threCircle/2 : cirradDouble(i)+threCircle/2;
            elseif circenDouble(i,2) < cirradDouble(i)+threCircle/2
                m1 = -cirradDouble(i)-threCircle/2 : cirradDouble(i)+threCircle/2;
                n1 = -circenDouble(i,2) : cirradDouble(i)*2+threCircle-circenDouble(i,2);
            else
                m1 = -cirradDouble(i)-threCircle/2 : cirradDouble(i)+threCircle/2;
                n1 = -cirradDouble(i)-threCircle/2 : cirradDouble(i)+threCircle/2;
            end
            [x,y]=meshgrid(m1,n1);
            circle=x.^2+y.^2;
            mask=zeros(size(circle));
            mask(find(circle<=cirradDouble(i)^2))=1;  %找到圆内的元素，并复制为1
            mask(find(circle>cirradDouble(i)^2))=0;
            mask = mask(1:size(subImg,1),1:size(subImg,2));
            subRegion = mask .* (subImg);
        end
        combImg = cat(3,subImg+subBioMarker,subImg,subImg);
        sum(subBioMarker(:))
%         imshow(combImg);
        if class == 0
            imwrite(imresize(subImg,[256,256]),[resultPath,...,
                'Ctrl_',num2str(time),'_',num2str(num),'_p',num2str(i),'.png'],'png','Comment','cell');
        elseif class == 1
            imwrite(imresize(subImg,[256,256]),[resultPath,...,
                'WT_',num2str(time),'_',num2str(num),'_p',num2str(i),'.png'],'png','Comment','cell');
        end
        
        %             circleBioMarker = mask .* (subBioMarker);
        %             figure(i);
        %             subplot(2,3,1);imshow(subImg,[]);
        %             subplot(2,3,2);imshow(subregion,[]);
        %             subplot(2,3,3);imshow(circleBioMarker);
        % %             subplot(2,3,4);imshow(subImg,[]);
        % %             subplot(2,3,5);imshow(subregion,[]);
        % %             subplot(2,3,6);imshow(circleBioMarker);
        
    end
end
load handel
sound(y,Fs)