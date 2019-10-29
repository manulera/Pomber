function [membtrace,pointint,xmaxi,ymaxi,crashed]=TraceSpindle(origima, strelradius, rotateangle, stepsize,xmaxi,ymaxi,TraceNumPoints,PreciseMax)
%--------------------------------------------------------------------------
% This function was inspired by TRACEPON by L. Holtzer, from Marcos
% Gonzalez-Gaitan in the University of Geneva, most of the tracing
% algortihm is kept, but certain things were added or changed
%
%  Input: origima     - image array (uint16 with 2 dimensions)
%         strelradius - radius of probed area from each point while tracing
%         rotateangle - angle over which to look finding the next point
%         stepsize    - distance between 2 points during membrane tracing
%         xmaxi       - starting xpoint for the trace
%         ymaxi       - starting ypoint for the trace
%         TraceNumPoints - The number of coordinate points you want in the
%                          trace
%         PreciseMax  - logical variable, true if the starting is provided
%                       and no need for videotracer_StrongPointfinder
%
%  Output:membtrace   - coordinates of traced membrane in pixels units
%         pointint    - intensity profile along those coordinates
%         xmaxi       - strongest point in the vicinity of xmaxi
%         ymaxi       - strongest point in the vicinity of ymaxi
%         crashed     - true if the tracing went wrong (old versions)
%
%--------------------------------------------------------------------------
if nargin<7||isempty(TraceNumPoints)
    TraceNumPoints=450;
end
if nargin<8||isempty(PreciseMax)
    PreciseMax=0;
end
% Keep the original image, so that we can measure the intensity in the end
% on the real image, and not the treated/filtered one 
im2=imgaussfilt(origima);
% This is the radius of the circle in which the maximum is looked once you 
% click, please read the function ahead to understand
sqsize=5; 
% This is the angle used for making the pies to measure intensity in
% different directions, please read the function ahead to understand.
ExploreAngle=20;
pointint=[];
% True if the tracing went wrong
crashed=0; 
%% Filtering of the image
% subtract background
bgimage=Parabolaback16(im2,2);
% This does not make much sense now
%im2=im2-bgimage;
% Check if too noisy
% Create empty objects for the storing of the means and std of 20x20
% squares in the image
[xsize,ysize]=size(im2);
imagemean=zeros(floor(xsize/20),floor(ysize/20));
imagestd=zeros(floor(xsize/20),floor(ysize/20));

for i=1:floor(xsize/20)
    for j=1:floor(ysize/20)
        imagemean(i,j)=mean2(im2((i-1)*20+1:i*20,(j-1)*20+1:j*20));
        %mean2 calculates the mean of the whole matrix
        %EACH POINT OF THIS MATRIX WILL BE THE MEAN OF SQUARES OF 20
        %POINTS
        imagestd(i,j)=std2(im2((i-1)*20+1:i*20,(j-1)*20+1:j*20));
        %THIS WILL BE THE STD OF 20X20 SQUARES
    end
end

backgroundmean=median(sort(imagemean(:)));
%THE MEDIAN OF THE MATRIX OF MEANS
backgroundstd=median(sort(imagestd(:)));
%THE MEDIAN OF THE MATRIX OF STD

%filter noise and threshold
im2=hmf(im2);
%This was enough filtering for my images
                % This was in the old version of Laurent, it made my tracing worse, because
                % some traces were very weak, but it might be helpful in some cases, feel
                % free to try
                %thresim2=medfi.*uint16(im2bw(uint8(medfi),.05));
                %se=strel('ball',1,1,0);
                %im2=imerode(thresim2,se);

%% Tracing
if ~PreciseMax
[xmaxi,ymaxi]=videotracer_StrongPointFinder(xmaxi,ymaxi,origima,sqsize);
end
xmax=xmaxi;
ymax=ymaxi;
membtrace=[xmax ymax];

% DONE is a logical variable that indicates that the tracing is finished
DONE=0;
% DecreasedRadius is a logical variable that is true in case that the
% distance between the point we are scanning at the moment and any of the
% boundaries of the image is smaller than strelradius
NewPoint=[xmax,ymax];
% The tracing is done as follows: first towards the brightest side of the
% membrane starting from the strongest point. If the trace is closed,
% meaning that it meets the begining, the trace is finished. If not, it
% will start again towards the opposite side
% SecondRound is a logical value that indicates whether we are in the first
% round of tracing (towards the most intense) or the second one (towards
% the other side).
SecondRound=0;
i=1;
% As you will see, strelradius can be reduced if the point that is being
% analyzed is too close to the border. For the next point we restore the
% old strelradius
oldstrelradius=strelradius;
while DONE==0
    % membtrace had previously been set to [xmax,ymax], we will add the
    % values of the trace to this array as we calculate them. 
    % In order to get the next point, we take the previous one, and move in
    % that direction a distance of stepsize
    membtrace(i,:)=NewPoint; 
    strelradius=oldstrelradius;
    %% Check if too close to image border
    if (round(membtrace(i,1))-strelradius)<1||(round(membtrace(i,1))+strelradius)>xsize||(round(membtrace(i,2))-strelradius)<1||(round(membtrace(i,2))+strelradius>ysize)
        % In case the point was too close to the border, we stablish a new
        % stelradius for the direction determination in that point, that is
        % the distance of the point to the closest edge of the image.
        strelradius=min([round(membtrace(i,1))-1 xsize-round(membtrace(i,1)) round(membtrace(i,2))-1 ysize-round(membtrace(i,2))]);
        % In case we got too close to the border 
        if strelradius<1
            if SecondRound
                crashed=1;
                break
            else
                AngleMove=First_AngleMove+180;
                first_membtrace=membtrace;
                membtrace=[xmax,ymax];
                SecondRound=1;
                NewPoint = [xmax,ymax];
                i=1;
                continue
            end
        end
    end

    %% Create a circular subset of the matrix for the scanning
    
    % se is a strel object, circle of radius=strelradius, used later as a
    % mask on im2 around the point we are at
    se=strel('ball',strelradius,0,0);
    % StrelSquare is a subset of im2 of size
    % ((2*strelradius)+1,(2*strelradius)+1), centered in the point i of
    % membtrace
    xlims=round(membtrace(i,1))-strelradius:round(membtrace(i,1))+strelradius;
    ylims=round(membtrace(i,2))-strelradius:round(membtrace(i,2))+strelradius;
    StrelSquare=im2(xlims,ylims);
    % We multiply by getnhood(se), a binary circle, so that we keep only
    % the values of StrelSquare that were inside the circle, and the rest
    % are made 0.
    % CircleArea is the matrix of size ((2*strelradius)+1,(2*strelradius)+1)
    % that contains that circle with the intensity values
    CircleArea=StrelSquare.*uint16(getnhood(se));
    
    %% Scanning for the strongest intensity direction
    % Selecting the angles of the directions that we are going to scan 
    if i==1 && ~SecondRound
        SeriesOfAngles=1:360;
    else
        % We scan only a susbset of the directions in all cases except for
        % the first time, beacause otherwise we would move back and forward
        % all the time.
        SeriesOfAngles=AngleMove-ExploreAngle*stepsize:2.5/stepsize:AngleMove+ExploreAngle*stepsize;
    end
    % PieIntens is a nx2 matrix, which contains the angles indicating the
    % direction of the different pies in the first column, and the values
    % of intensity in those pies in the second column.
    PieIntens=nan(numel(SeriesOfAngles),2);
    q=1;
    for j=SeriesOfAngles
        % In order to understand this step please look at
        % "TraceAntVid_PieMaker" help.
        [xpolygon,ypolygon]=TraceAntVid_PieMaker(j,strelradius,rotateangle);
        % PolyImage is a binary mask with the shape of pie slice
        PolyImage=roipoly(getnhood(se),xpolygon,ypolygon);
        if j<1
            PieIntens(q,1)=j+360; 
        else
            PieIntens(q,1)=j;
        end
        PieIntens(q,2)=sum(sum(uint16(PolyImage).*CircleArea));
        
        q=q+1;
    end
    
    [~,StrongestIndex]=max(PieIntens(:,2)); 
    % AngleMove is the angle that has the most intensity, and therefore the
    % one to which the trace should move
    AngleMove=PieIntens(StrongestIndex,1);
    %% Various checks
    if i==1
        % For when we do the tracing in the opposite direction
        First_AngleMove=AngleMove;
    end

    % check if colliding with other side:
    % see if any point of the trace (except for the last 10) is closer than
    % stepsize to any of the points of the trace. That would mean that
    % trace is closed
    if sum((membtrace(i,1)-membtrace(1:max([1 i-10]),1)).^2+(membtrace(i,2)-membtrace(1:max([1 i-10]),2)).^2<stepsize^2)>0&&i>10
        DONE=1;
        %remove overhangs, find where the trace collides with itself
        collindex=find(((membtrace(i,1)-membtrace(1:i-1,1)).^2+(membtrace(i,2)-membtrace(1:i-1,2)).^2)<stepsize^2);
        membtrace=membtrace(collindex:end,:);
    else
        % Generate the new point
        NewPoint(1)=(stepsize*sind(AngleMove)+membtrace(i,1));
        NewPoint(2)=(stepsize*cosd(AngleMove)+membtrace(i,2));
    end
    % Check whether the intensity in a quadrant the same size, but full of
    % noise is greater than the one you just chose
    if max(PieIntens(:,2))<(sum(sum(PolyImage))*(backgroundmean+backgroundstd))/10
        if SecondRound==1
            DONE=1;
        else
            AngleMove=First_AngleMove+180;
            first_membtrace=membtrace;
            membtrace=[xmax,ymax];
            SecondRound=1;
            i=1;
            continue
        end
    end
    i=i+1;
end

%% Linking he two half traces/centering
if SecondRound
    % We flip updown the trace, we invert the column so that this half of
    % the trace starts in its previous last point (in principle, the 
    % weakest) and finishes by (xmax,ymax), like this, the strongest point
    % will be in the joint place of the two traces
    first_membtrace=flipud(first_membtrace);
    % Here we join both half traces, we start from the second value in the
    % second trace, otherwise we would count the starting point twice
    membtrace=[first_membtrace; membtrace(2:end,:)];
else
    q=size(membtrace);
    % In this case, we copy the last half part of membtrace and paste it
    % into the begining (AB->BAB). Then we eliminate the last part and get
    % BA. This will leave the starting point in the middle
    membtrace=[membtrace(end-round(q(1)/2):end,:);membtrace];
    membtrace=membtrace(1:end-round(q(1)/2),:);
end

%% Expanding the trace
% Since it was not performing very good, and the contours were a little
% smaller than they should (they were inside the membrane, rather than on
% it), I tried the following algorithm that draws lines from the center of
% the circle and looks for the strongest point in the line from the contour
% to a certain radius.
%membtrace=ExpandTrace(im2,membtrace,8,TraceNumPoints);
%% Intensity profile extraction and centering
% plot intensity profile along the contour
if ~any( isnan(membtrace))
    pointint=(improfile(im2, membtrace(:,2), membtrace(:,1),size(membtrace,1)))';
end
[from,to] = get_limits(pointint);
pointint = pointint(from:to);
membtrace = membtrace(from:to,:);
