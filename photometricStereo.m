function [albedoImage, surfaceNormals] = photometricStereo(imArray, lightDirs)
% PHOTOMETRICSTEREO compute intrinsic image decomposition from images
%   [ALBEDOIMAGE, SURFACENORMALS] = PHOTOMETRICSTEREO(IMARRAY, LIGHTDIRS)
%   comptutes the ALBEDOIMAGE and SURFACENORMALS from an array of images
%   with their lighting directions. The surface is assumed to be perfectly
%   lambertian so that the measured intensity is proportional to the albedo
%   times the dot product between the surface normal and lighting
%   direction. The lights are assumed to be of unit intensity.
%
%   Input:
%       IMARRAY - [h w n] array of images, i.e., n images of size [h w]
%       LIGHTDIRS - [n 3] array of unit normals for the light directions
%
%   Output:
%        ALBEDOIMAGE - [h w] image specifying albedos
%        SURFACENORMALS - [h w 3] array of unit normals for each pixel
%
% Author: Subhransu Maji
%
% Acknowledgement: Based on a similar homework by Lana Lazebnik


%%% implement this %% 
[height width num] = size(imArray);
%{
imTrans = [];
for i = 1:num
  imTrans = cat(1,imTrans,reshape(imArray(:,:,i),[1,(height*width)]));
end
x = lightDirs\imTrans;
albedo = zeros(1,height*width);
for j = 1:(height*width)
    albedo(1,j) = norm(x(:,j));
end
albedoImage = reshape(albedo,[height, width]);

for k = 1:3
   surfaceNormals(:,:,k) = reshape(x(k,:)./albedo(1,:),[height, width]);
end
%}

imSize = height*width;
transArray = (reshape(imArray,[imSize, num]))';
x = lightDirs\transArray;
albedo = zeros(imSize,1);
for i = 1:imSize
    albedo(i) = norm(x(:,i));
end
albedoImage = reshape(albedo,[height, width]);
normals = normc(x);
surfaceNormals = reshape(normals',[height, width, 3]);
