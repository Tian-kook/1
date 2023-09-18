%%一个旅行商要拜访31个省会城市，且每个城市只能拜访一次，求所有路径之中的最小值


%%禁忌搜索算法求解TSP问题
clear;
clc;%清空原有的数据

Clist=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;...
    4196 1044;4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;...
    1332 695;3715 1678;3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;...
    4263 2931;3429 1908;3507 2376;3394 2643;3439 3201;2935 3240;3140 3550;...
    2545 2357;2778 2826;2370 2975];%全国31个省会城市坐标
figure(1);
plot(Clist(:,1),Clist(:,2),'*');%绘制坐标图



%利用城市的坐标计算城市之间的距离（我不需要这一步，我已经有距离值了）
CityNum=size(Clist,1);%TSP问题的规模，即城市数目
dislist=zeros(CityNum);%建立一个数据，用于存储各个城市之间的距离矩阵
for i=1:CityNum
    for j=1:CityNum
        dislist(i,j)=((Clist(i,1)-Clist(j,1))^2+(Clist(i,2)-Clist(j,2))^2)^0.5      %求两点之间的勾股定理
    end
end

TabuList=zeros(CityNum);                            %(tabu list)建立禁忌表
TabuLength=round((CityNum*(CityNum-1)/2)^0.5);       %禁忌表长度
Candidates=200;                                     %候选集的个数（全部领域解个数，每次更新的领域解的个数）
CandidateNum=zeros(Candidates,CityNum);             %候选解集合，用于存储所有的候选集
S0=randperm(CityNum);                               %随机产生初始解
BSF=S0;                                             %当前最佳路线
BestL=Inf;                                          %当前最佳解距离
p=1;                                                %记录迭代次数
StopL=2000;                                         %最大迭代次数

figure(2);
stop = uicontrol('style','toggle','string'...
    ,'stop','background','white');   %设置循环过程中保持绘图
tic;                                 %用来保存当前时间
%%%%%%%%%%%%%%%%%%%禁忌搜索循环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while p<StopL
    if Candidates>CityNum*(CityNum-1)/2
        disp('候选解个数不大于n*(n-1)/2!');
        break;
    end
    ALong(p)=Fun(dislist,S0);
    
    i=1;
    A=zeros(Candidates,2);               %用于存储解中交换的城市矩阵
    
    %以下while的 是生成随机的200×2的矩阵A。每个元素都是在1-31之间的
    while i<=Candidates
        M=CityNum*rand(1,2);  %产生两个随机数，0-1, 乘以31
        M=ceil(M);   %将两个随机数向上取整
        if M(1)~=M(2)  %如果两个数不相等
            A(i,1)=max(M(1), M(2));
            A(i,2)=min(M(1), M(2));%把他们按照大小顺序放在矩阵A当中第i个位置
            if i==1
                isa=0; %区分是否为第一次生成， 第-次生成无需判断是否与之前的重复
            else
                for j=1:i-1
                    if A(i, 1)==A(j,1) && A(i, 2)==A(j, 2)
                        isa=1;
                        break;%如果不是第一次生成，那么需要与之前的对比是否重复
                        %如果重复将标识符赋值1，表示本次循环无效，继续重新生成
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
    %%%%%%%%%%%%产生领域解%%%%%%%%%%%%%%%
    BestCandidateNum=100;          %保留前个最好候选解，候选集的个数
    BestCandidate=Inf*ones(BestCandidateNum,4);         %分别用于存储最优解的对应的领域的序号，最优解的领域取法，最优解对应的最短路径
    F=zeros(1,Candidates);
    
    
    %这相当于是产生一个S0的领域。。。
    %利用上述产生的邻城，获得所有候选集
    for i=1:Candidates
        CandidateNum(i, :)=S0;
        CandidateNum(i,[A(i, 2),A(i, 1)])=S0([A(i, 1), A(i, 2)]);%生成第1个候选解。
        F(i)=Fun(dislist,CandidateNum(i,:));%计算当前的候选解对应的总路程
        if i<=BestCandidateNum
            BestCandidate(i, 2)= F(i);
            BestCandidate(i, 1)=i;
            BestCandidate(i, 3)=S0(A(i, 1));
            BestCandidate(i, 4)=S0(A(i, 2));%这里的意思是前一-百个直接保存，超过一 百个之后需要与前一百个比较
%如果比之前的小，还可以继续保存，如果没有比之前的小，那就不保存
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
    [JL,Index]=sort(BestCandidate(:, 2));%利用各个路径的最短距离对保存的一百个候选解进行排序
    SBest=BestCandidate(Index, :);%保存排序后的候选解及其对应的邻域
    BestCandidate=SBest;
    %%%%%%%%%%%%%蔑视准则%%%%%%%%%%%%%
    if BestCandidate(1,2)<BestL         %如果当前最小的解比全局最小的解还小，更新全局最小路程及其对应的解
        BestL=BestCandidate(1,2);
        S0=CandidateNum(BestCandidate(1,1),:);
        BSF=S0;
        for m=1:CityNum
            for n=1:CityNum
                if TabuList(m,n)~=0
                    TabuList(m,n)=TabuList(m,n)-1;%更新禁忌表，将之前记录过的都往下推多一位
                end
            end
        end
        TabuList(BestCandidate(1,3),BestCandidate(1,4))=TabuLength; % 更新禁忌表，将第一个最好的结果更新到禁忌表当中，作为最近-次更新
    else
    
        for i=1:BestCandidateNum %如果新的解当中没有优于之前的解的，就将所有的候选集当中的解全部更新进入禁忌表，
            if TabuList(BestCandidate(i,3),BestCandidate(i,4))==0
                S0=CandidateNum(BestCandidate(i,1),:);
                for m=1:CityNum
                    for n=1:CityNum
                        if TabuList(m,n)~=0
                            TabuList(m,n)=TabuList(m,n)-1;%更新禁忌表，原来就在禁忌表的将其下移
                        end
                    end
                end
                TabuList(BestCandidate(i, 3), BestCandidate(i, 4))=TabuLength;   %更新禁忌表，没有在禁忌表中的加入禁忌表
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
%存储中间结果为图片
%It 1010100105151 4000001p010-200
    p=p+1;
end

toc;        %用来保存完成时间
BestShortcut=BSF;  %最佳路线
theMinDistance=BestL;      %最佳路线长度
set(stop, 'style','pushbutton','string','close','callback','close(gcf)');

figure(3);
plot(ArrBestL,'b');
xlabel('选代次数');
ylabel('目标函数值');
title('适应度进化曲线');
grid;
hold on;



    
    

