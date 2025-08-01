%don't think it is being marked correctly, also it's possible that a
%particular colour is always at a particular location.
close all;
clear all;
vsgInit('');
global CRS;
cd('C:\Users\John Maule\Documents\MATLAB\EEG_decoding');
load Feb20_2025_160_primaries;
XYZ=SelectConeFundamentals('StockmanMacleodJohnson');
RGBs=Feb20_2025_160_primaries(:,2:4);r
RGBs=interp1([380:4:780]',RGBs,[380:1:780]');
[RGB2LMS,LMS2RGB]=RGBToXYZ(XYZ,RGBs,0);
%This new screen size-based system is functional, but a lot of values need
%tweaking. Also want to find out why objects too close to the left and
%right borders are getting cut off, maybe it's something about the draw
%function. - Abi
screenWidth = crsGetScreenWidthPixels();
screenHeight = crsGetScreenHeightPixels();
% Size of gabors and test colours could be synced - Abi

%minverse=[36354.1511889944,-70606.9011235271,1358.88830089028;-5004.75735987464,28378.5596320230,-1308.04065979287;-402.210902369006,-807.682679743925,4020.45812439132];
% Calibration with Dylan Jan 2022
minverse=LMS2RGB;
participantcode=input('Enter participant code: ','s');
%up response,  v4
%v2 left
%v3 down
%v1 right
%TODO - These values are wrong! Fix them.. - Abi
coords=[
    ( 2/10)*screenWidth  -0.0625*screenHeight
    (-2/10)*screenWidth  -0.0625*screenHeight
    0                   ( 2/10)*screenHeight-0.0625*screenHeight
    0                   (-2/10)*screenHeight-0.0625*screenHeight
    ];
v1 = makegabor(screenHeight,0,0,40,coords(1,1),coords(1,2),0,1,1);
v1=v1-1;
v1=v1./max(max(v1));
v2 = makegabor(screenHeight,0,0,40,coords(2,1),coords(2,2),0,1,1);
v2=v2-1;
v2=v2./max(max(v2));
v3 = makegabor(screenHeight,0,0,40,coords(3,1),coords(3,2),0,1,1);
v3=v3-1;
v3=v3./max(max(v3));
v4 = makegabor(screenHeight,0,0,40,coords(4,1),coords(4,2),0,1,1);
v4=v4-1;
v4=v4./max(max(v4));

%fixation dot
xinit=linspace(size(v4,2)/2,-size(v4,2)/2,size(v4,2));
yinit=linspace(size(v4,1)/2,-size(v4,1)/2,size(v4,1));
[xbig,ybig]=meshgrid(xinit,yinit-0.0625*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
m=zeros(size(v4));
m(rbig<3)=1;

% Modify these to be fractions of width and height soon, as well as -350
% thing
coords=linspace((-3/10)*screenWidth,(3/10)*screenWidth,5);
coords_testcols=[
    coords(1) (4/10)*screenHeight
    coords(2) (4/10)*screenHeight
    coords(3) (4/10)*screenHeight
    coords(4) (4/10)*screenHeight
    coords(5) (4/10)*screenHeight
    ];
[xbig,ybig]=meshgrid(xinit+coords_testcols(1,1),yinit+(4/10)*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
testrow=zeros(size(v4));
testrow(rbig<40)=2;

[xbig,ybig]=meshgrid(xinit+coords_testcols(2,1),yinit+(4/10)*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
testrow(rbig<40)=3;

[xbig,ybig]=meshgrid(xinit+coords_testcols(3,1),yinit+(4/10)*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
testrow(rbig<40)=4;

[xbig,ybig]=meshgrid(xinit+coords_testcols(4,1),yinit+(4/10)*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
testrow(rbig<40)=5;

[xbig,ybig]=meshgrid(xinit+coords_testcols(5,1),yinit+(4/10)*screenHeight);
[thbig,rbig]=cart2pol(xbig,ybig);
testrow(rbig<40)=6;

v=v1+v2+v3+v4;
m2=m*254;
m=m*-2;

v=round(v*125)+1+m2;
v(testrow~=0)=testrow(testrow~=0);
v1=round(v1*125)+127+m;
v2=round(v2*125)+127+m;
v3=round(v3*125)+127+m;
v4=round(v4*125)+127+m;
v1(testrow~=0)=testrow(testrow~=0);
v2(testrow~=0)=testrow(testrow~=0);
v3(testrow~=0)=testrow(testrow~=0);
v4(testrow~=0)=testrow(testrow~=0);

v1(v1==125)=254;
v2(v2==125)=254;
v3(v3==125)=254;
v4(v4==125)=254;

lum=0.000075*4;
llmmax=0.735;
slmmax=1.7;
lummax=1.5*lum;
%set pixel levels for adapting blob

%Put response chromaticities into the palette

%background grey
LMS(1,1)=0.7.*lum;
LMS(1,3)=1.*lum;
LMS(1,2)=lum.*(1-0.7);
RGB=LMS*minverse';
palette=zeros(256,3);
palette(1,:)=RGB;

%red
LMS(1,1)=llmmax.*lum;
LMS(1,3)=1.*lum;
LMS(1,2)=lum.*(1-llmmax);
RGB=LMS*minverse';
palette(2,:)=RGB;

%teal
LMS(1,1)=(.7-(llmmax-.7)).*lum;
LMS(1,3)=1.*lum;
LMS(1,2)=lum.*(1-(.7-(llmmax-.7)));
RGB=LMS*minverse';
palette(3,:)=RGB;

%violet
LMS(1,1)=0.7.*lum;
LMS(1,3)=slmmax.*lum;
LMS(1,2)=lum.*(1-.7);
RGB=LMS*minverse';
palette(4,:)=RGB;

%lime
LMS(1,1)=.7.*lum;
LMS(:,3)=(1-(slmmax-1)).*lum;
LMS(:,2)=lum.*(1-.7);
RGB=LMS*minverse';
palette(5,:)=RGB;

%grey
LMS(1,1)=.7.*lum*1.3;
LMS(:,3)=1.*lum*1.3;
LMS(:,2)=1.3*lum.*(1-.7);
RGB=LMS*minverse';
palette(6,:)=RGB;

palette(254,:)=[0 0 0];
palette(255,:)=[1 1 1];
crsPaletteSet(palette);
m(m==-2)=253;
m=m+1;
m(testrow~=0)=testrow(testrow~=0);
m(testrow~=0)=testrow(testrow~=0);
m(testrow~=0)=testrow(testrow~=0);
m(testrow~=0)=testrow(testrow~=0);

crsSetDrawPage(CRS.VIDEOPAGE,1,1);
crsDrawMatrixPalettised(m); %page 1 is black 254

m_white=m;
m_white(m_white==254)=255;
crsSetDrawPage(CRS.VIDEOPAGE,7,1);
crsDrawMatrixPalettised(m_white); %page 7 is white 255

%crsSetDrawPage(CRS.VIDEOPAGE,2,1); %all white
%crsDrawMatrixPalettised(v);
crsSetDrawPage(CRS.VIDEOPAGE,3,1);
crsDrawMatrixPalettised(v1); %right
crsSetDrawPage(CRS.VIDEOPAGE,4,1);
crsDrawMatrixPalettised(v2); %left
crsSetDrawPage(CRS.VIDEOPAGE,5,1);
crsDrawMatrixPalettised(v3);%bottom
crsSetDrawPage(CRS.VIDEOPAGE,6,1);
crsDrawMatrixPalettised(v4);%top

%create 8 staircases, 4 tracking color responses, 4 tracking position
%responses
StartingLLMIncrement=(0.7409-0.7)/2;
StartingSLMIncrement=(1.7-1)/2;
StartingLumIncrement=0.000075/4;
%L/(L+M) increment
Colour_staircase_1=QuestCreate(log10(StartingLLMIncrement),1,0.70,2.5,0.01,0);
%L/(L+M) decrement
Colour_staircase_2=QuestCreate(log10(StartingLLMIncrement),1,0.70,2.5,0.01,0);
%S/(L+M) increment
Colour_staircase_3=QuestCreate(log10(StartingSLMIncrement),1,0.70,2.5,0.01,0);
%S/(L+M) decrement
Colour_staircase_4=QuestCreate(log10(StartingSLMIncrement),1,0.70,2.5,0.01,0);
%Luminance increment
Colour_staircase_5=QuestCreate(log10(StartingLumIncrement),1,0.70,2.5,0.01,0);
%L/(L+M) increment
Position_staircase_1=QuestCreate(log10(StartingLLMIncrement),1,0.70,2.5,0.01,0);
%L/(L+M) decrement
Position_staircase_2=QuestCreate(log10(StartingLLMIncrement),1,0.70,2.5,0.01,0);
%S/(L+M) increment
Position_staircase_3=QuestCreate(log10(StartingSLMIncrement),1,0.70,2.5,0.01,0);
%S/(L+M) decrement
Position_staircase_4=QuestCreate(log10(StartingSLMIncrement),1,0.70,2.5,0.01,0);
% Luminance increment
Position_staircase_5=QuestCreate(log10(StartingLumIncrement),1,0.70,2.5,0.01,0);


%Need to randomise position (4 possibilities) and staircase (8
%possibilities). Total number of trials is 100 (expect them to do 40 or so)
%per staircase 8*20x5

%creat first 160 trials and then concatenate in blocks
Stimulusdecider=[];
StimulusdeciderA=[];
StimulusdeciderB=[];
for k=1:5
    Stimulusdecider2(:,1)=repmat([1:10]',20,1);
    Stimulusdecider2(:,2)=rand(200,1);
    Stimulusdecider2=sortrows(Stimulusdecider2,2);
    StimulusdeciderA=[StimulusdeciderA;Stimulusdecider2];
end
for k=1:5
    Stimulusdecider3(:,1)=repmat([1:4]',50,1);
    Stimulusdecider3(:,2)=rand(200,1);
    Stimulusdecider3=sortrows(Stimulusdecider3,2);
    StimulusdeciderB=[StimulusdeciderB;Stimulusdecider3];
end
Stimulusdecider=[StimulusdeciderA(:,1) StimulusdeciderB(:,1)];

crsSetDrawPage(CRS.VIDEOPAGE,9,1);
crsSetDrawPage(CRS.VIDEOPAGE,8,1);

crsSetStringMode([0, screenWidth/25],CRS.ALIGNCENTRETEXT,CRS.ALIGNCENTRETEXT,0,CRS.FONTNORMAL);
textHeights = linspace((-3/10)*screenHeight,(3/10)*screenHeight,6);
crsDrawString([0 textHeights(1)],'You are now ready to start the experiment.');
crsDrawString([0 textHeights(2)],'The session will last for 40 minutes.');
crsDrawString([0 textHeights(3)],'Please take a short (1-2 minute) break');
crsDrawString([0 textHeights(4)],'every now and then as you need to.');
crsDrawString([0 textHeights(5)],'Please remember to maintain fixation all the time.' );
crsDrawString([0 textHeights(6)],'Are you ready? Press any ARROW key to start' );

crsSetDisplayPage(8);
moveon=0;
while moveon==0
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyIsDown==1
        moveon=1;
    end
end
crsSetDisplayPage(9)
pause(3);
SessionStart=GetSecs;
tic;
sessionTime=0;
k=0;
while sessionTime < 40*60 % Runs trials for 40 minutes
    k=k+1;
    CurrentTime=GetSecs;
    sessionTime=CurrentTime-SessionStart;
    crsSetDisplayPage(7);
    time1=crsGetTimer;
    time2=crsGetTimer;
    if Stimulusdecider(k,1)==1
        intensity=10^QuestMean(Colour_staircase_1);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>llmmax-0.7
            intensity=llmmax-0.7;
        end
    elseif Stimulusdecider(k,1)==2
        intensity=10^QuestMean(Colour_staircase_2);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>llmmax-0.7
            intensity=llmmax-0.7;
        end
    elseif Stimulusdecider(k,1)==3
        intensity=10^QuestMean(Colour_staircase_3);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>slmmax-1
            intensity=slmmax-1;
        end
    elseif Stimulusdecider(k,1)==4
        intensity=10^QuestMean(Colour_staircase_4);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>slmmax-1
            intensity=slmmax-1;
        end
    elseif Stimulusdecider(k,1)==5
        intensity=10^QuestMean(Colour_staircase_5);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>lummax-lum
            intensity=lummax-lum;
        end
    elseif Stimulusdecider(k,1)==6
        intensity=10^QuestMean(Position_staircase_1);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>llmmax-0.7
            intensity=llmmax-0.7;
        end
    elseif Stimulusdecider(k,1)==7
        intensity=10^QuestMean(Position_staircase_2);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>llmmax-0.7
            intensity=llmmax-0.7;
        end
    elseif Stimulusdecider(k,1)==8
        intensity=10^QuestMean(Position_staircase_3);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>slmmax-1
            intensity=slmmax-1;
        end
    elseif Stimulusdecider(k,1)==9
        intensity=10^QuestMean(Position_staircase_4);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>slmmax-1
            intensity=slmmax-1;
        end
    elseif Stimulusdecider(k,1)==10
        intensity=10^QuestMean(Position_staircase_5);
        if intensity<0.000001
            intensity=0.000001;
        elseif intensity>lummax-lum
            intensity=lummax-lum;
        end
    end
    if Stimulusdecider(k,1)==1 || Stimulusdecider(k,1)==6
        pixellevelgradientllmT=(linspace(0.7,0.7+intensity,126))'; %red blob
    elseif Stimulusdecider(k,1)==2 || Stimulusdecider(k,1)==7
        pixellevelgradientllmT=(linspace(0.7,0.7-intensity,126))'; % green blob
    elseif Stimulusdecider(k,1)==3 || Stimulusdecider(k,1)==8
        pixellevelgradientslmT=(linspace(1,1+intensity,126))'; % purple blob
    elseif Stimulusdecider(k,1)==4 || Stimulusdecider(k,1)==9
        pixellevelgradientslmT=(linspace(1,1-intensity,126))'; % lime blob
    elseif Stimulusdecider(k,1)==5 || Stimulusdecider(k,1)==10
        pixellevelgradientsLumT=(linspace(lum,lum+intensity,126))'; % grey blob
    end
    if Stimulusdecider(k,1)==1 || Stimulusdecider(k,1)==2 || Stimulusdecider(k,1)==6 || Stimulusdecider(k,1)==7
        LMSgradientT(:,1)=pixellevelgradientllmT.*lum;
        LMSgradientT(:,3)=ones(126,1).*lum;
        LMSgradientT(:,2)=lum.*(1-pixellevelgradientllmT);
        RGBgradientT=LMSgradientT*minverse';
        palette(127:252,:)=RGBgradientT;
    elseif  Stimulusdecider(k,1)==3 || Stimulusdecider(k,1)==4 || Stimulusdecider(k,1)==8 || Stimulusdecider(k,1)==9
        LMSgradientT(:,1)=0.7*ones(126,1).*lum;
        LMSgradientT(:,3)=pixellevelgradientslmT.*lum;
        LMSgradientT(:,2)=lum.*(1-0.7*ones(126,1));
        RGBgradientT=LMSgradientT*minverse';
        palette(127:252,:)=RGBgradientT;
    elseif Stimulusdecider(k,1)==5 || Stimulusdecider(k,1)==10
        LMSgradientT(:,1)=0.7*ones(126,1).*pixellevelgradientsLumT;
        LMSgradientT(:,3)=ones(126,1).*pixellevelgradientsLumT;
        LMSgradientT(:,2)=pixellevelgradientsLumT.*(1-0.7*ones(126,1));
        RGBgradientT=LMSgradientT*minverse';
        palette(127:252,:)=RGBgradientT;
    end
    crsPaletteSet(palette);
    
    crsSetDisplayPage(7); %display page 7 (blank fixation white) for delay
    OnsetTime=crsGetTimer;
    time2=crsGetTimer;
    while time2-OnsetTime<1500000 %1500 ms delay
        time2=crsGetTimer;
    end
    Beeper(400,0.01);
    if Stimulusdecider(k,2)==1
        crsSetDisplayPage(3)
    elseif Stimulusdecider(k,2)==2
        crsSetDisplayPage(4)
    elseif Stimulusdecider(k,2)==3
        crsSetDisplayPage(5)
    elseif Stimulusdecider(k,2)==4
        crsSetDisplayPage(6)
    end
    time1=crsGetTimer;
    OnsetTime=time1;
    time2=crsGetTimer;
    while time2-time1<100000 %100 ms TEST PROBE DURATION
        time2=crsGetTimer;
    end
    
    crsSetDisplayPage(1); %display page 1 with black fixation to mark onset of response interval
    
    stimluspresentationtime=time2-time1;
    
    %response interval - use CT3 box or keyboard with arrows.
    response=NaN;
    FlushEvents;
    
    time2=crsGetTimer;
    keyCode=[];
    feedback_frame=m_white;
    happy_with_reponse=0;
    while happy_with_reponse==0
        ResponseReceived_p=0;
        ResponseReceived_c=0;
        while ResponseReceived_p==0||ResponseReceived_c==0
            time2=crsGetTimer;
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
            if keyIsDown==1
                if (max(strcmp(KbName(keyCode),'8'))==1)||(max(strcmp(KbName(keyCode),'4'))==1)||(max(strcmp(KbName(keyCode),'2'))==1)||(max(strcmp(KbName(keyCode),'6'))==1)
                    ResponseReceived_p=1;
                    if (max(strcmp(KbName(keyCode),'8'))==1)
                        Response_string_position='8';
                    elseif (max(strcmp(KbName(keyCode),'4'))==1)
                        Response_string_position='4';
                    elseif (max(strcmp(KbName(keyCode),'6'))==1)
                        Response_string_position='6';
                    elseif (max(strcmp(KbName(keyCode),'2'))==1)
                        Response_string_position='2';
                    end
                    time2=crsGetTimer;
                    ResponseTime_p=time2-OnsetTime;
                    % TODO add response type for grayscale blob - Abi
                elseif (max(strcmp(KbName(keyCode),'z'))==1)||(max(strcmp(KbName(keyCode),'x'))==1)||(max(strcmp(KbName(keyCode),'c'))==1)||(max(strcmp(KbName(keyCode),'v'))==1)||(max(strcmp(KbName(keyCode),'b'))==1)
                    Response_string_colour=KbName(keyCode);
                    if size(Response_string_colour)==1
                        ResponseReceived_c=1;
                        time2=crsGetTimer;
                        ResponseTime_c=time2-OnsetTime;
                    end
                else
                    %Beeper(100,0.3);
                    errorkey=1;
                end
            end
        end
        
        a1=0; b1=0; c1=0; d1=0; e1=0; f1=0; g1=0; h1=0; i1=0;
        crsSetDisplayPage(7); %white fixation
        if strmatch(Response_string_position,'8')==1%up response,  v4
            a1=1;
            if Stimulusdecider(k,2)==4 %correct
                response_p=1;
                % Beeper(1000,0.1);
                pause(0.1)
            else
                response_p=0;
                % Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_position,'4')==1%left response, v2
            b1=1;
            if Stimulusdecider(k,2)==2 %correct
                response_p=1;
                %  Beeper(1000,0.1);
                pause(0.1)
            else
                response_p=0;
                % Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_position,'6')==1%right response,
            c1=1;
            if Stimulusdecider(k,2)==1 %correct
                response_p=1;
                %  Beeper(1000,0.1);
                pause(0.1)
            else
                response_p=0;
                %  Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_position,'2')==1%down response,v3
            d1=1;
            if Stimulusdecider(k,2)==3 %correct
                response_p=1;
                %   Beeper(1000,0.1);
                pause(0.1)
            else
                response_p=0;
                %   Beeper(400,0.1);
                pause(0.1)
            end
        end
        
        if strmatch(Response_string_colour,'z')==1%red
            e1=1;
            if Stimulusdecider(k,1)==1 || Stimulusdecider(k,1)==6 %correct
                response_c=1;
                %  Beeper(1000,0.1);
                pause(0.1)
            else
                response_c=0;
                %  Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_colour,'x')==1%teal
            f1=1;
            if Stimulusdecider(k,1)==2 || Stimulusdecider(k,1)==7 %correct
                response_c=1;
                %  Beeper(1000,0.1);
                pause(0.1)
            else
                response_c=0;
                %  Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_colour,'c')==1%violet
            g1=1;
            if Stimulusdecider(k,1)==3 || Stimulusdecider(k,1)==8 %correct
                response_c=1;
                %  Beeper(1000,0.1);
                pause(0.1)
            else
                response_c=0;
                %  Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_colour,'v')==1%lime
            h1=1;
            if Stimulusdecider(k,1)==4 || Stimulusdecider(k,1)==9            %correct
                response_c=1;
                %   Beeper(1000,0.1);
                pause(0.1)
            else
                response_c=0;
                %   Beeper(400,0.1);
                pause(0.1)
            end
        elseif strmatch(Response_string_colour,'b')==1%grey
            i1=1;
            if Stimulusdecider(k,1)==5 || Stimulusdecider(k,1)==10 %correct
                response_c=1;
                %   Beeper(1000,0.1);
                pause(0.1)
            else
                response_c=0;
                %   Beeper(400,0.1);
                pause(0.1)
            end
        end
        %draw frames around responded regions
        %position
        if a1==1
            coordindex=4;
        elseif b1==1
            coordindex=2;
        elseif c1==1
            coordindex=1;
        elseif d1==1
            coordindex=3;
        end
        %colour
        if e1==1
            coordindex_c=1;
        elseif f1==1
            coordindex_c=2;
        elseif g1==1
            coordindex_c=3;
        elseif h1==1
            coordindex_c=4;
        elseif i1==1
            coordindex_c=5;
        end
        coords=[
            ( 2/10)*screenWidth  -0.0625*screenHeight
            (-2/10)*screenWidth  -0.0625*screenHeight
            0                   ( 2/10)*screenHeight-0.0625*screenHeight
            0                   (-2/10)*screenHeight-0.0625*screenHeight
            ];
        [xbig,ybig]=meshgrid(xinit+coords(coordindex,1),yinit+coords(coordindex,2));
        [thbig,rbig]=cart2pol(xbig,ybig);
        feedback_frame(rbig<50&rbig>48)=255;
        
        [xbig,ybig]=meshgrid(xinit+coords_testcols(coordindex_c,1),yinit+coords_testcols(coordindex_c,2));
        [thbig,rbig]=cart2pol(xbig,ybig);
        feedback_frame(rbig<45&rbig>43)=255;
        crsSetDrawPage(CRS.VIDEOPAGE,10,1);
        crsDrawMatrixPalettised(feedback_frame);
        
        crsSetDisplayPage(10);
        [secs, keyCode, deltaSecs] = KbWait;
        if (strcmp(KbName(keyCode),'space')==1)
            happy_with_reponse=1;
        else
            feedback_frame=m_white;
            FlushEvents;
        end
        crsSetDisplayPage(7);
        
    end
    
    %update positional staircases with position response and colour staircases
    %with colour response
    if Stimulusdecider(k,1)==6
        Position_staircase_1=QuestUpdate(Position_staircase_1,log10(intensity), response_p);
    elseif Stimulusdecider(k,1)==7
        Position_staircase_2=QuestUpdate(Position_staircase_2,log10(intensity), response_p);
    elseif Stimulusdecider(k,1)==8
        Position_staircase_3=QuestUpdate(Position_staircase_3,log10(intensity), response_p);
    elseif Stimulusdecider(k,1)==9
        Position_staircase_4=QuestUpdate(Position_staircase_4,log10(intensity), response_p);
    elseif Stimulusdecider(k,1)==10
        Position_staircase_5=QuestUpdate(Position_staircase_5,log10(intensity), response_p);
    end
    if Stimulusdecider(k,1)==1
        Colour_staircase_1=QuestUpdate(Colour_staircase_1,log10(intensity), response_c);
    elseif Stimulusdecider(k,1)==2
        Colour_staircase_2=QuestUpdate(Colour_staircase_2,log10(intensity), response_c);
    elseif Stimulusdecider(k,1)==3
        Colour_staircase_3=QuestUpdate(Colour_staircase_3,log10(intensity), response_c);
    elseif Stimulusdecider(k,1)==4
        Colour_staircase_4=QuestUpdate(Colour_staircase_4,log10(intensity), response_c);
    elseif Stimulusdecider(k,1)==5
        Colour_staircase_5=QuestUpdate(Colour_staircase_5,log10(intensity), response_c);
    end
    % Bit of a hacky redesign, just copied the loop. Check if this properly
    % works, might change it - Abi
    HappyWithAwarenessRating=0;
    while HappyWithAwarenessRating==0
        crsSetDrawPage(CRS.VIDEOPAGE,11,1);
        textHeights = linspace((-2/10)*screenHeight,(2/10)*screenHeight,5);
        crsDrawString([0 textHeights(1)],'Please rate your awareness of the stimulus.');
        crsDrawString([0 textHeights(2)],'1. No experience');
        crsDrawString([0 textHeights(3)],'2. A brief glimpse');
        crsDrawString([0 textHeights(4)],'3. Almost clear experience');
        crsDrawString([0 textHeights(5)],'4. Clear experience');
        FlushEvents;
        crsSetDisplayPage(11)
        ResponseReceived_a=0;
        while ResponseReceived_a==0
            time2=crsGetTimer;
            [secs, keyCode, deltaSecs] = KbWait;
            time2=crsGetTimer;
            if strcmp(KbName(keyCode),'4$')==1
                ResponseReceived_a=4;
                AwarenessRating=4;
            elseif strcmp(KbName(keyCode),'3#')==1
                ResponseReceived_a=3;
                AwarenessRating=3;
            elseif strcmp(KbName(keyCode),'2@')==1
                ResponseReceived_a=2;
                AwarenessRating=2;
            elseif strcmp(KbName(keyCode),'1!')==1
                ResponseReceived_a=1;
                AwarenessRating=1;
            else
            end
        end
        pause(0.2);
        crsDrawString([0 (4/10)*screenHeight],mat2str(AwarenessRating));
        [secs, keyCode, deltaSecs] = KbWait;
        if (strcmp(KbName(keyCode),'space')==1)
            HappyWithAwarenessRating=1;
        end
        ResponseTime_a=time2-OnsetTime;
    end
    HappyWithChromaRating=0;
    while HappyWithChromaRating==0
        crsSetDrawPage(CRS.VIDEOPAGE,11,1);
        textHeights = linspace((-2/10)*screenHeight,0,3);
        crsDrawString([0 textHeights(1)],'Did the stimulus appear to be coloured?');
        crsDrawString([0 textHeights(2)],'1. Yes');
        crsDrawString([0 textHeights(3)],'2. No');
        FlushEvents;
        crsSetDisplayPage(11)
        ResponseReceived_chr=0;
        while ResponseReceived_chr==0
            time3=crsGetTimer;
            [secs, keyCode, deltaSecs] = KbWait;
            time3=crsGetTimer;
            if strcmp(KbName(keyCode),'2@')==1
                ResponseReceived_chr=2;
                ChromaRating=2;
            elseif strcmp(KbName(keyCode),'1!')==1
                ResponseReceived_chr=1;
                ChromaRating=1;
            else
            end
        end
        pause(0.2);
        crsDrawString([0 (4/10)*screenHeight],mat2str(ChromaRating));
        [secs, keyCode, deltaSecs] = KbWait;
        if (strcmp(KbName(keyCode),'space')==1)
            HappyWithChromaRating=1;
        end
        ResponseTime_chr=time3-OnsetTime;
    end
    FlushEvents;
    crsSetDisplayPage(7);
    Results(k,1)=k;
    Results(k,2)=Stimulusdecider(k,1);
    Results(k,3)=Stimulusdecider(k,2);
    Results(k,4)=response_c;
    Results(k,5)=response_p;
    Results(k,6)=intensity;
    Results(k,7)=AwarenessRating;
    Results(k,8)=ChromaRating;
    Results(k,9)=ResponseTime_p;
    Results(k,10)=ResponseTime_c;
    Results(k,11)=ResponseTime_a;
    Results(k,12)=ResponseTime_chr;
    Response_key_Results{k,1}=Response_string_colour;
    Response_key_Results{k,2}=Response_string_position;
end

crsSetDrawPage(CRS.VIDEOPAGE,11,1);
textHeights = linspace((-1/10)*screenHeight,0,2);
crsDrawString([0 textHeights(1)],'This is the end of the experiment!');
crsDrawString([0 textHeights(2)],'Thank you for taking part!');

FlushEvents;
crsSetDisplayPage(11)

TimeTaken=toc;
cd data
filename=[participantcode,'ResultsExperiment',mat2str(now),'.mat'];
save(filename);
cd ..