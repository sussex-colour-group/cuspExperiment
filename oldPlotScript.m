clear all
close all
load '/home/aflowers/Documents/Vision Lab/Cloud/Abigail/CuspExperiment/Data/pp8_2_time739767.51237088_cusp_results.mat'
%Results- column 1 is trial number, 2 staircase number, 3 stimulus
%location, correct(location?), correct(hue?), 6 is intensity, 7 PAS rating 8
% chroma rating
% This formats the staircase in a way that looks nice - making the range same as trial count
% and limiting the 10,000 strong array too.
figure
subplot(2,2,1)
plot(1:Colour_staircase_1.trialCount,10.^(Colour_staircase_1.intensity(1:Colour_staircase_1.trialCount)),'-','Color',[0.5 0 0])
hold on
plot(1:Colour_staircase_2.trialCount,10.^(Colour_staircase_2.intensity(1:Colour_staircase_2.trialCount)),'-','Color',[0 0.5 0])
subplot(2,2,3)
plot(1:Colour_staircase_3.trialCount,10.^(Colour_staircase_3.intensity(1:Colour_staircase_3.trialCount)),'-','Color',[0.5 0 0.5])
hold on
plot(1:Colour_staircase_4.trialCount,10.^(Colour_staircase_4.intensity(1:Colour_staircase_4.trialCount)),'-','Color',[0.5 0.5 0.25])
subplot(2,2,2)
plot(1:Position_staircase_1.trialCount,10.^(Position_staircase_1.intensity(1:Position_staircase_1.trialCount)),'--','Color',[0.5 0 0])
hold on
plot(1:Position_staircase_2.trialCount,10.^(Position_staircase_2.intensity(1:Position_staircase_2.trialCount)),'--','Color',[0 0.5 0])
subplot(2,2,4)
plot(1:Position_staircase_3.trialCount,10.^(Position_staircase_3.intensity(1:Position_staircase_3.trialCount)),'--','Color',[0.5 0 0.5])
hold on
plot(1:Position_staircase_4.trialCount,10.^(Position_staircase_4.intensity(1:Position_staircase_4.trialCount)),'--','Color',[0.5 0.5 0.25])

figure(2)
subplot(1,2,1)
plot(1:Colour_staircase_1.trialCount,10.^(Colour_staircase_1.intensity(1:Colour_staircase_1.trialCount)),'-','Color',[0.5 0 0])
hold 
plot(1:Colour_staircase_2.trialCount,10.^(Colour_staircase_2.intensity(1:Colour_staircase_2.trialCount)),'-','Color',[0 0.5 0])
plot(1:Position_staircase_1.trialCount,10.^(Position_staircase_1.intensity(1:Position_staircase_1.trialCount)),'--','Color',[0.5 0 0])
hold on
plot(1:Position_staircase_2.trialCount,10.^(Position_staircase_2.intensity(1:Position_staircase_2.trialCount)),'--','Color',[0 0.5 0])
subplot(1,2,2)
plot(1:Colour_staircase_3.trialCount,10.^(Colour_staircase_3.intensity(1:Colour_staircase_3.trialCount)),'-','Color',[0.5 0 0.5])
hold on
plot(1:Colour_staircase_4.trialCount,10.^(Colour_staircase_4.intensity(1:Colour_staircase_4.trialCount)),'-','Color',[0.5 0.5 0.25])
plot(1:Position_staircase_3.trialCount,10.^(Position_staircase_3.intensity(1:Position_staircase_3.trialCount)),'--','Color',[0.5 0 0.5])
hold on
plot(1:Position_staircase_4.trialCount,10.^(Position_staircase_4.intensity(1:Position_staircase_4.trialCount)),'--','Color',[0.5 0.5 0.25])

% My goal was originally to refactor this in a way


%%
cd '/home/aflowers/Documents/Vision Lab/Cloud/Abigail/CuspExperiment/Data';
filenames={'pp10_1_time739779.57438875_cusp_results.mat'};
for p=1:length(filenames)
    load(filenames{p})
    Results=Results(30:end,:);
    %loop through the PAS and pull out data for each pas rating type
    for j=1:7
        subresults=Results(Results(:,7)==j,:);
        correctL(j,p)=sum(subresults(:,5));
        trialsL(j,p)=length(subresults);
        correctH(j,p)=sum(subresults(:,4));
        trialsH(j,p)=length(subresults);
    end
end
figure
data=[mean((correctL./trialsL),2,"omitnan") mean((correctH./trialsH),2,"omitnan")];

err=[std((correctL./trialsL).',"omitnan").' std((correctH./trialsH).',"omitnan").'];
err=err./5^0.5;
hb=bar(data);
hold on
for k = 1:size(data,2)
    % get x positions per group
    xpos = hb(k).XData + hb(k).XOffset;
    % draw errorbar
    errorbar(xpos, data(:,k), err(:,k), 'LineStyle', 'none', ...
        'Color', 'k', 'LineWidth', 1);
end
xlabel('PAS rating')
ylabel('Proportion correct')
legend({'stimulus position','stimulus hue'},'Location','northwest')

%%
cd '/home/aflowers/Documents/Vision Lab/Cloud/Abigail/CuspExperiment/Data';
filenames={'pp10_1_time739779.57438875_cusp_results.mat'};
for p=1:length(filenames)
    load(filenames{p})
    Results=Results(30:end,:);
    %loop through the PAS and pull out data for each pas rating type
    for j=1:7
        
        subresults=Results(Results(:,7)==j,:);
        subresultsLM=subresults(subresults(:,2)==1|subresults(:,2)==2|subresults(:,2)==5|subresults(:,2)==6,:);
        subresultsSLM=subresults(subresults(:,2)==3|subresults(:,2)==4|subresults(:,2)==7|subresults(:,2)==8,:);
        intensityStimulusSLM(j,p)=mean(subresultsSLM(:,6),"omitnan");
        intensityStimulusLM(j,p)=mean(subresultsLM(:,6),"omitnan");
    end
end
dataLM=[mean(intensityStimulusLM,2,"omitnan")];
dataSLM=[mean(intensityStimulusSLM,2,"omitnan")];

errLM=[std(intensityStimulusLM.',"omitnan")].';
errLM=errLM./5^0.5;


errSLM=[std(intensityStimulusSLM.',"omitnan")].';
errSLM=errSLM./5^0.5;



figure
hbLM=bar(dataLM);
hold on
for k = 1:size(dataLM,2)
    % get x positions per group
    xpos = hbLM(k).XData + hbLM(k).XOffset;
    % draw errorbar
    errorbar(xpos, dataLM(:,k), errLM(:,k), 'LineStyle', 'none', ...
        'Color', 'k', 'LineWidth', 1);
end
xlabel('PAS rating')
ylabel('L/(L+M) physical intensity')

figure
hbSLM=bar(dataSLM);
hold on
for k = 1:size(dataSLM,2)
    % get x positions per group
    xpos = hbSLM(k).XData + hbSLM(k).XOffset;
    % draw errorbar
    errorbar(xpos, dataSLM(:,k), errSLM(:,k), 'LineStyle', 'none', ...
        'Color', 'k', 'LineWidth', 1);
end
xlabel('PAS rating')
ylabel('S/(L+M) physical intensity')
%%
clear all;
cd '/home/aflowers/Documents/Vision Lab/Cloud/Abigail/CuspExperiment/Data';
filenames={'pp10_1_time739779.57438875_cusp_results.mat'};
figure
NumBins=12;
for p=1:length(filenames)
    load(filenames{p})
    Results=Results(30:end,:);
    subresultsLM=Results(Results(:,2)==1|Results(:,2)==2|Results(:,2)==5|Results(:,2)==6,:);
    subresultsSLM=Results(Results(:,2)==3|Results(:,2)==4|Results(:,2)==7|Results(:,2)==8,:);
    
    edges=linspace(0,100,NumBins);
    y=prctile(subresultsLM(:,6),edges);
    [counts,Id] = histc(subresultsLM(:,6),y);
    recordcounts(p,:)=counts;
    %Now find proportion correct for each intensity bin
    correctlocation=subresultsLM(:,5);
    correcthue=subresultsLM(:,4);
    for j=1:NumBins
        correctLocLM(j,p)=sum(correctlocation(Id==j))./sum(Id==j);
    end
        for j=1:NumBins
        correctHueLM(j,p)=sum(correcthue(Id==j))./sum(Id==j);
    end
    
    
        edges=linspace(0,100,NumBins);
    y2=prctile(subresultsSLM(:,6),edges);
    [counts,Id] = histc(subresultsSLM(:,6),y2);
    recordcounts(p,:)=counts;
    %Now find proportion correct for each intensity bin
    correctlocation=subresultsSLM(:,5);
    correcthue=subresultsSLM(:,4);
    for j=1:NumBins
        correctLocSLM(j,p)=sum(correctlocation(Id==j))./sum(Id==j);
    end
        for j=1:NumBins
        correctHueSLM(j,p)=sum(correcthue(Id==j))./sum(Id==j);
    end
    
end
subplot(1,2,1)
plot(y(1:end-1),mean(correctLocLM(1:end-1,:),2),'.r','LineWidth',2,'MarkerSize',20)
hold on
plot(y(1:end-1),mean(correctHueLM(1:end-1,:),2),'.b','LineWidth',2,'MarkerSize',20)
xlabel('L/(L+M) intensity');
ylabel('Proportion correct');

subplot(1,2,2)
plot(y2(1:end-1),mean(correctLocSLM(1:end-1,:),2),'.r','LineWidth',2,'MarkerSize',20)
hold on
plot(y2(1:end-1),mean(correctHueSLM(1:end-1,:),2),'.b','LineWidth',2,'MarkerSize',20)
xlabel('S/(L+M) intensity');
ylabel('Proportion correct');

