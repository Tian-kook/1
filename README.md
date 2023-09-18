# 1
clear;
clc;

Clist=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;...
    4196 1044;4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;...
    1332 695;3715 1678;3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;...
    4263 2931;3429 1908;3507 2376;3394 2643;3439 3201;2935 3240;3140 3550;...
    2545 2357;2778 2826;2370 2975];
figure(1);
plot(Clist(:,1),Clist(:,2),'*');
CityNum=size(Clist,1);
dislist=zeros(CityNum);
for i=1:CityNum
    for j=1:CityNum
        dislist(i,j)=((Clist(i,1)-Clist(j,1))^2+(Clist(i,2)-Clist(j,2))^2)^0.5
    end
end

TabuList=zeros(CityNum); 
TabuLength=round((CityNum*(CityNum-1)/2)^0.5);
Candidates=200;                                    
CandidateNum=zeros(Candidates,CityNum); 
S0=randperm(CityNum); 
BSF=S0;
BestL=Inf;
p=1;
StopL=2000;

figure(2);
stop = uicontrol('style','toggle','string'...
    ,'stop','background','white'); 
tic; 
while p<StopL
    if Candidates>CityNum*(CityNum-1)/2
        disp('候选解个数不大于n*(n-1)/2!');
        break;
    end
    ALong(p)=Fun(dislist,S0);
    
    i=1;
    A=zeros(Candidates,2); 
    while i<=Candidates
        M=CityNum*rand(1,2); 
        M=ceil(M);
        if M(1)~=M(2)  
            A(i,1)=max(M(1), M(2));
            A(i,2)=min(M(1), M(2));
            if i==1
                isa=0; 
            else
                for j=1:i-1
                    if A(i, 1)==A(j,1) && A(i, 2)==A(j, 2)
                        isa=1;
                        break;
                    else
                        isa=0;
                    end
                end
            end
            if~isa
                i=i+1;
            else
            end
       else
       end
    end
  
    BestCandidateNum=100;
    BestCandidate=Inf*ones(BestCandidateNum,4);
    F=zeros(1,Candidates);
    
    
    for i=1:Candidates
        CandidateNum(i, :)=S0;
        CandidateNum(i,[A(i, 2),A(i, 1)])=S0([A(i, 1), A(i, 2)]);
        F(i)=Fun(dislist,CandidateNum(i,:));
        if i<=BestCandidateNum
            BestCandidate(i, 2)= F(i);
            BestCandidate(i, 1)=i;
            BestCandidate(i, 3)=S0(A(i, 1));
            BestCandidate(i, 4)=S0(A(i, 2));
        else
            for j=1:BestCandidateNum
                if F(i)<BestCandidate(j, 2)
                    BestCandidate(j, 2)=F(i);
                    BestCandidate(j, 1)=i;
                    BestCandidate(j, 3)=S0(A(i, 1));
                    BestCandidate(j, 4)=S0(A(i, 2));
                    break;
                end
            end
        end
    end
    %对BostCandidate
    [JL,Index]=sort(BestCandidate(:, 2));
    SBest=BestCandidate(Index, :);
    BestCandidate=SBest;
  
    if BestCandidate(1,2)<BestL         
        BestL=BestCandidate(1,2);
        S0=CandidateNum(BestCandidate(1,1),:);
        BSF=S0;
        for m=1:CityNum
            for n=1:CityNum
                if TabuList(m,n)~=0
                    TabuList(m,n)=TabuList(m,n)-1;
                end
            end
        end
        TabuList(BestCandidate(1,3),BestCandidate(1,4))=TabuLength; 
    else
    
        for i=1:BestCandidateNum 
            if TabuList(BestCandidate(i,3),BestCandidate(i,4))==0
                S0=CandidateNum(BestCandidate(i,1),:);
                for m=1:CityNum
                    for n=1:CityNum
                        if TabuList(m,n)~=0
                            TabuList(m,n)=TabuList(m,n)-1;
                        end
                    end
                end
                TabuList(BestCandidate(i, 3), BestCandidate(i, 4))=TabuLength;   
                break;
            end
        end
    end
    ArrBestL(p)=BestL;
    
    
    for i=1:CityNum-1
        plot([Clist(BSF(i),1),Clist(BSF(i+1),1)],[Clist(BSF(i),2),Clist(BSF(i+1),2)],'bo-');
        hold on;
    end
    plot([Clist(BSF(CityNum),1),Clist(BSF(1),1)], [Clist(BSF(CityNum), 2),Clist(BSF(1),2)],'ro-');
    title(['迭代次数:', int2str(p),'优化最短距离:' ,num2str(BestL)]);
    hold off;
    pause(0.005);
    if get(stop, 'value' )==1
        break;
    end
    p=p+1;
end

toc;
BestShortcut=BSF;
theMinDistance=BestL;
set(stop, 'style','pushbutton','string','close','callback','close(gcf)');

figure(3);
plot(ArrBestL,'b');
xlabel('选代次数');
ylabel('目标函数值');
title('适应度进化曲线');
grid;
hold on;
