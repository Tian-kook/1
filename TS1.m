%%һ��������Ҫ�ݷ�31��ʡ����У���ÿ������ֻ�ܰݷ�һ�Σ�������·��֮�е���Сֵ


%%���������㷨���TSP����
clear;
clc;%���ԭ�е�����

Clist=[1304 2312;3639 1315;4177 2244;3712 1399;3488 1535;3326 1556;3238 1229;...
    4196 1044;4312 790;4386 570;3007 1970;2562 1756;2788 1491;2381 1676;...
    1332 695;3715 1678;3918 2179;4061 2370;3780 2212;3676 2578;4029 2838;...
    4263 2931;3429 1908;3507 2376;3394 2643;3439 3201;2935 3240;3140 3550;...
    2545 2357;2778 2826;2370 2975];%ȫ��31��ʡ���������
figure(1);
plot(Clist(:,1),Clist(:,2),'*');%��������ͼ



%���ó��е�����������֮��ľ��루�Ҳ���Ҫ��һ�������Ѿ��о���ֵ�ˣ�
CityNum=size(Clist,1);%TSP����Ĺ�ģ����������Ŀ
dislist=zeros(CityNum);%����һ�����ݣ����ڴ洢��������֮��ľ������
for i=1:CityNum
    for j=1:CityNum
        dislist(i,j)=((Clist(i,1)-Clist(j,1))^2+(Clist(i,2)-Clist(j,2))^2)^0.5      %������֮��Ĺ��ɶ���
    end
end

TabuList=zeros(CityNum);                            %(tabu list)�������ɱ�
TabuLength=round((CityNum*(CityNum-1)/2)^0.5);       %���ɱ���
Candidates=200;                                     %��ѡ���ĸ�����ȫ������������ÿ�θ��µ������ĸ�����
CandidateNum=zeros(Candidates,CityNum);             %��ѡ�⼯�ϣ����ڴ洢���еĺ�ѡ��
S0=randperm(CityNum);                               %���������ʼ��
BSF=S0;                                             %��ǰ���·��
BestL=Inf;                                          %��ǰ��ѽ����
p=1;                                                %��¼��������
StopL=2000;                                         %����������

figure(2);
stop = uicontrol('style','toggle','string'...
    ,'stop','background','white');   %����ѭ�������б��ֻ�ͼ
tic;                                 %�������浱ǰʱ��
%%%%%%%%%%%%%%%%%%%��������ѭ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while p<StopL
    if Candidates>CityNum*(CityNum-1)/2
        disp('��ѡ�����������n*(n-1)/2!');
        break;
    end
    ALong(p)=Fun(dislist,S0);
    
    i=1;
    A=zeros(Candidates,2);               %���ڴ洢���н����ĳ��о���
    
    %����while�� �����������200��2�ľ���A��ÿ��Ԫ�ض�����1-31֮���
    while i<=Candidates
        M=CityNum*rand(1,2);  %���������������0-1, ����31
        M=ceil(M);   %���������������ȡ��
        if M(1)~=M(2)  %��������������
            A(i,1)=max(M(1), M(2));
            A(i,2)=min(M(1), M(2));%�����ǰ��մ�С˳����ھ���A���е�i��λ��
            if i==1
                isa=0; %�����Ƿ�Ϊ��һ�����ɣ� ��-�����������ж��Ƿ���֮ǰ���ظ�
            else
                for j=1:i-1
                    if A(i, 1)==A(j,1) && A(i, 2)==A(j, 2)
                        isa=1;
                        break;%������ǵ�һ�����ɣ���ô��Ҫ��֮ǰ�ĶԱ��Ƿ��ظ�
                        %����ظ�����ʶ����ֵ1����ʾ����ѭ����Ч��������������
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
    %%%%%%%%%%%%���������%%%%%%%%%%%%%%%
    BestCandidateNum=100;          %����ǰ����ú�ѡ�⣬��ѡ���ĸ���
    BestCandidate=Inf*ones(BestCandidateNum,4);         %�ֱ����ڴ洢���Ž�Ķ�Ӧ���������ţ����Ž������ȡ�������Ž��Ӧ�����·��
    F=zeros(1,Candidates);
    
    
    %���൱���ǲ���һ��S0�����򡣡���
    %���������������ڳǣ�������к�ѡ��
    for i=1:Candidates
        CandidateNum(i, :)=S0;
        CandidateNum(i,[A(i, 2),A(i, 1)])=S0([A(i, 1), A(i, 2)]);%���ɵ�1����ѡ�⡣
        F(i)=Fun(dislist,CandidateNum(i,:));%���㵱ǰ�ĺ�ѡ���Ӧ����·��
        if i<=BestCandidateNum
            BestCandidate(i, 2)= F(i);
            BestCandidate(i, 1)=i;
            BestCandidate(i, 3)=S0(A(i, 1));
            BestCandidate(i, 4)=S0(A(i, 2));%�������˼��ǰһ-�ٸ�ֱ�ӱ��棬����һ �ٸ�֮����Ҫ��ǰһ�ٸ��Ƚ�
%�����֮ǰ��С�������Լ������棬���û�б�֮ǰ��С���ǾͲ�����
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
    %��BostCandidate
    [JL,Index]=sort(BestCandidate(:, 2));%���ø���·������̾���Ա����һ�ٸ���ѡ���������
    SBest=BestCandidate(Index, :);%���������ĺ�ѡ�⼰���Ӧ������
    BestCandidate=SBest;
    %%%%%%%%%%%%%����׼��%%%%%%%%%%%%%
    if BestCandidate(1,2)<BestL         %�����ǰ��С�Ľ��ȫ����С�Ľ⻹С������ȫ����С·�̼����Ӧ�Ľ�
        BestL=BestCandidate(1,2);
        S0=CandidateNum(BestCandidate(1,1),:);
        BSF=S0;
        for m=1:CityNum
            for n=1:CityNum
                if TabuList(m,n)~=0
                    TabuList(m,n)=TabuList(m,n)-1;%���½��ɱ���֮ǰ��¼���Ķ������ƶ�һλ
                end
            end
        end
        TabuList(BestCandidate(1,3),BestCandidate(1,4))=TabuLength; % ���½��ɱ�����һ����õĽ�����µ����ɱ��У���Ϊ���-�θ���
    else
    
        for i=1:BestCandidateNum %����µĽ⵱��û������֮ǰ�Ľ�ģ��ͽ����еĺ�ѡ�����еĽ�ȫ�����½�����ɱ�
            if TabuList(BestCandidate(i,3),BestCandidate(i,4))==0
                S0=CandidateNum(BestCandidate(i,1),:);
                for m=1:CityNum
                    for n=1:CityNum
                        if TabuList(m,n)~=0
                            TabuList(m,n)=TabuList(m,n)-1;%���½��ɱ�ԭ�����ڽ��ɱ�Ľ�������
                        end
                    end
                end
                TabuList(BestCandidate(i, 3), BestCandidate(i, 4))=TabuLength;   %���½��ɱ�û���ڽ��ɱ��еļ�����ɱ�
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
    title(['��������:', int2str(p),'�Ż���̾���:' ,num2str(BestL)]);
    hold off;
    pause(0.005);
    if get(stop, 'value' )==1
        break;
    end
%�洢�м���ΪͼƬ
%It 1010100105151 4000001p010-200
    p=p+1;
end

toc;        %�����������ʱ��
BestShortcut=BSF;  %���·��
theMinDistance=BestL;      %���·�߳���
set(stop, 'style','pushbutton','string','close','callback','close(gcf)');

figure(3);
plot(ArrBestL,'b');
xlabel('ѡ������');
ylabel('Ŀ�꺯��ֵ');
title('��Ӧ�Ƚ�������');
grid;
hold on;



    
    

