function  heightMap = getSurface(surfaceNormals, method)
% GETSURFACE computes the surface depth from normals
%   HEIGHTMAP = GETSURFACE(SURFACENORMALS, IMAGESIZE, METHOD) computes
%   HEIGHTMAP from the SURFACENORMALS using various METHODs. 
%  
% Input:
%   SURFACENORMALS: height x width x 3 array of unit surface normals
%   METHOD: the intergration method to be used
%
% Output:
%   HEIGHTMAP: height map of object

x = -1*surfaceNormals(:,:,1)./surfaceNormals(:,:,3);
y = -1*surfaceNormals(:,:,2)./surfaceNormals(:,:,3);

switch method
    case 'column'
        heightMap = x;
        heightMap(:,1) = y(:,1);
        
        heightMap(:,1) = cumsum(heightMap(:,1),1);
        heightMap = cumsum(heightMap,2);
        
    case 'row'
        heightMap = y;
        heightMap(1,:) = x(1,:);
        
        heightMap(1,:) = cumsum(heightMap(1,:),2);
        heightMap = cumsum(heightMap,1);
        
       
    case 'average'
        
        heightMap1 = x;
        heightMap1(:,1) = y(:,1);
        heightMap2 = y;
        heightMap2(1,:) = x(1,:);
        
        heightMap1(:,1) = cumsum(heightMap1(:,1),1);
        heightMap1 = cumsum(heightMap1,2);
        heightMap2(1,:) = cumsum(heightMap2(1,:),2);
        heightMap2 = cumsum(heightMap2,1);
        
        heightMap = (heightMap1+heightMap2)/2;
        
    case 'random'
        
        [h w] = size(surfaceNormals(:,:,1));
        num = 50;
        map = zeros(h,w,num);
        
        %col->row->col->row
        for i = 1:(num)
            randh = randi(h-1);
            randw = randi(w/2);
            
            map(:,:,i) = x;
            map(:,1,i) = y(:,1);
            map((randh+1):h,1:randw,i) = y((randh+1):h,1:randw);
            
            map(1:randh,1,i) = cumsum(map(1:randh,1,i),1);
            map(1:randh,1:w,i) = cumsum(map(1:randh,1:w,i),2);
            map(randh:h,1:randw,i) = cumsum(map(randh:h,1:randw,i),1);
            map((randh+1):h,randw:w,i) = cumsum(map((randh+1):h,randw:w,i),2);
            
        end
        %{
        %row->col->row->col
        for j = (7*num+1):(8*num)
            randh = randi(h/2);
            randw = randi(w/2);
            map(:,:,j) = y;
            map(1,:,j) = x(1,:);
            map(1:randh,(randw+1):w,j) = x(1:randh,(randw+1):w);
            
            map(1,1:randw,j) = cumsum(map(1,1:randw,j),2);
            map(1:h,1:randw,j) = cumsum(map(1:h,1:randw,j),1);
            map(1:randh,randw:w,j) = cumsum(map(1:randh,randw:w,j),2);
            map(randh:h,(randw+1):w,j) = cumsum(map(randh:h,(randw+1):w,j),1);
            
        end
        %}
        sumMap = zeros(h,w);
        for k = 1:(num)
            sumMap = sumMap+map(:,:,k);
        end
        heightMap = sumMap/(num);
    %{
    case 'superRandom'
       [h w] = size(surfaceNormals(:,:,1));
        num = 10;
        map = zeros(h,w,2*num);
        for n = 1:num
            for i = 1:h
                for j = 1:w
                    randw = randi(w-1);
                    map(i,j,n) = map(i,j,n)+sum(x(1,1:randw));
                    map(i,j,n) = map(i,j,n)+sum(y(2:h,randw));
                    map(i,j,n) = map(i,j,n)+sum(x(h,(randw+1):w));
                    
                    randh = randi(h-1);
                    map(i,j,n+num) = map(i,j,n+num)+sum(y(1:randh,1));
                    map(i,j,n+num) = map(i,j,n+num)+sum(x(randh,2:w));
                    map(i,j,n+num) = map(i,j,n+num)+sum(y((randh+1):h,w));
                    
                end
            end
        end
        sumMap = zeros(h,w);
        for k = 1:(2*num)
            sumMap = sumMap+map(:,:,k);
        end
        heightMap = sumMap/(2*num);
    %}
end


