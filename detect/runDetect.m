%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This is the main function for the cell detection, which can run directly.
%  The path and resultPath need to be modified. Time means different hours
%  posted infection. Class 0 presents the control group(uninfected) and
%  Class 1 is the infected group.
%  Last updated: 12/01/2018
%  Author: Xinzhuo Zhao
%  https://www.researchgate.net/profile/Xinzhuo_Zhao3/research
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
time = 2;
class = 1;
path = ['../data/',num2str(time),'hpi/',num2str(class),'/'];
resultPath = ['Detect/',num2str(time),'/',num2str(class),'/'];
mkdir(resultPath);
if class == 1
    file1 = dir([path,'white\']);
    file2 = dir([path,'red\']);
else
    file1 = dir(path);
end
threCircle = 5;


for i = 3:length(file1)
    
    %%%%%%%%%%%%%%%%%  load  image   %%%%%%%%%%%%%%%%%%%%%%
    
    if class == 1
        im = imread([path,'white\',file1(i).name]);
        bioMarker = imread([path,'red\',file2(i).name]);
        bioMarker = imbinarize(bioMarker);
    else
        im = imread([path,file1(i).name]);
        im = squeeze(im(:,:,1));
        %figure();imshow(im,[]); title(file1(i).name);
    end
    
    %%%%%%%%%%%%%%%%%  cell detection    %%%%%%%%%%%%%%%%%%%%%%
    prm_LM_LoBndRa = 0.4;
    fltr4accum = [1 2 1; 2 6 2; 1 2 1];
    fltr4accum = fltr4accum / sum(fltr4accum(:));
    radrange = [8 15]; %[minimum_radius , maximum_radius]  (unit: pixels)
    grdthres = 0.01* max(im(:)); %A value of 4% to 10% of the maximum intensity may work for general cases.
    fltr4LM_R = 10; %default is 8, minimum is 3, The less perfect circle, the larger radius
    multirad = 0.5;
    
    %%%%%%%%%%%%%%%%%%%  processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [accum, circen,cirrad] = CircularHough_Grd(im,radrange, grdthres, fltr4LM_R, 0.5, fltr4accum);
    
    %%%%%%%%%%%%%%%%%%%   Reduco the FP  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    temp = round(circen);
    [~, rank] = sort(temp,1);
    circenNew = temp(rank(:,1),:);
    cirradNew = cirrad(rank(:,1),:);
    for j = length(temp):-1:2
        if circenNew(j,1) == circenNew(j-1,1) && circenNew(j,2) == circenNew(j-1,2)
            circenNew(j,:) = [];
            cirradNew(j) = [];
        end
    end
    
    [~, rank2] = sort(circenNew,1);
    circenNew2 = circenNew(rank2(:,2),:);
    cirradNew2 = cirradNew(rank2(:,2),:);
    for j = length(cirradNew):-1:2
        if circenNew2(j,1) == circenNew2(j-1,1) && circenNew2(j,2) == circenNew2(j-1,2)
            circenNew2(j,:) = [];
            cirradNew2(j) = [];
        end
    end
    circen = circenNew2;
    cirrad = cirradNew2;
    
    %     %%%%%%%%%%%%%%%%%%  data save   %%%%%%%%%%%%%%%%%%%%%%%%%
    if class == 1
        % Infection area
        [circleBioMarker,subRegion,area] = IsInfection(circen,cirrad,im,bioMarker,threCircle);
        circenInf = circen;
        circenInf(area == 0,:) = [];
        cirradInf = cirrad;
        cirradInf(area == 0) = [];
        cirradDouble = cirradInf;
        circenDouble = circenInf;
    elseif class == 0
        cirradDouble = cirrad;
        circenDouble = circen;
    end
    
    
    %%%%%%%%%%%%%%%%%%  plot image   %%%%%%%%%%%%%%%%%%%%%%%%%
    im = double(im);
    im2 = (im - min(im(:)))/(max(im(:))-min(im(:)));
    figure();imshow(im,[]);
    hold on; plot(circenDouble(:,1), circenDouble(:,2), 'r+');
    for k = 1 : size(circenDouble, 1)
        DrawCircle(circenDouble(k,1), circenDouble(k,2), cirradDouble(k)+3, 440, 'g-');
    end
    hold off;
    title(['FP result', file1(i).name]);
    
    %     %%%%%%%%%%%%%%%%%%  data save   %%%%%%%%%%%%%%%%%%%%%%%%%
    
    idx = regexp(file1(i).name,'-');
    name = file1(i).name;
    if class ==0
        name = name(idx(2)+1:idx(3)-2);
    elseif class == 1
        name = name(idx(3)+1: idx(4)-2);
    end
    
    save([resultPath,'im',name,'.mat'],'im');
    if class == 1
        save([resultPath,'bioMarker',name,'.mat'],'bioMarker');
        %         save([resultPath,'combimg',name,'.mat'],'combimg');
    end
    save([resultPath,'circen',name,'.mat'],'circenDouble');
    save([resultPath,'cirrad',name,'.mat'],'cirradDouble');
    save([resultPath,'area',name,'.mat'],'area');
end


