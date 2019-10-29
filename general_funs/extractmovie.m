
function[imstack,zimsize,tlen,resolution,metadata]=extractmovie(filename)
%This function creates a 4D matrix out of a tif video with a z stack and
%time
%It returns
%     -imstack: number array of the video (uint16)
%     -zimsize: the number of frames in the z stack
%     -tlen: number of timepoints
%     -resolution: resolution in x y z t in um and secs
%     -metadata array
try
    raw=bfopen(filename);
    %allimages is an array, in the first column there is the image, in the
    %second there is the info
    metadata=raw([2 4]);
    allimages=raw{1,1};
    %In the old version of this function, the resolution was obtained from a
    %string using general expressions, but now it uses the metadata format,
    %because I think it will be better that way and it will also be helpful
    %maybe for different formats. In any case, I keep the old code in
    %another file and it is invoked when there is no metadata.
    [yimsize,ximsize]=size(allimages{1,1});
    zimsize=raw{1,4}.getPixelsSizeZ(0).getValue();
    tlen=ceil(size(allimages,1)/zimsize);
    imstack=uint16(zeros(yimsize,ximsize,zimsize,tlen));
    for i=1:size(allimages,1)
        imstack(:,:,i)=allimages{i,1};
    end;
    omeMeta=raw{4};
    xresol=omeMeta.getPixelsPhysicalSizeX(0).getValue();
    yresol=omeMeta.getPixelsPhysicalSizeY(0).getValue();
    %I could not manage to extract this in other way
    
    metadatastring=raw{2};
    zresol=str2double(metadatastring.get('Global VoxelSizeZ'));
    
    tresol=double(omeMeta.getPixelsTimeIncrement(0));
    resolution=[xresol yresol zresol tresol];
catch
    beep
    warning('General Expressions were used')
    [imstack,zimsize,tlen,resolution]=extractmoviegenexp(filename);
end

