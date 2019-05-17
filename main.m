clear;
clc;
%给定参数，为在其他函数内使用，这里定义为全局变量
global RHOo;
global MUo;
global Bo;
global RHOw;
global MUw;
global Bw;
global Swi;
global Sor;
global N;
global Np;
global fw;
global Sw;
global R;
RHOo=0.9199;
MUo=140.1;
Bo=1.3;
RHOw=1.141;
MUw=1.5;
Bw=1;
Swi=0.25;
Sor=0.26;
N=528847;
load DATA;%注意，DATA第一列为Sw，第二列为fw
Sw=DATA(:,1);
fw=DATA(:,2);

%%
load DATA2; %第一列为测量Sw，第二列为测量的krw，第3列为测量的kro
Sw_measure=DATA2(:,1);
Krw_measure=DATA2(:,2);
Kro_measure=DATA2(:,3);
%遗传算法参数
global max_gen;
pop_size=60;%种群大小
lamda=0.75;%采用算术交叉，交叉的常数为0.75，假设交叉前的两数为a,b，对于bo和bw,交叉后a'=0.25a+0.75b,b'=0.75a+0.25b,对于aw，交叉后a'=a^0.25*b^0.75,b'=a^0.75*b^0.25
max_gen=3000; %最大代数
pm=0.1;       %变异概率,采用非均匀变异，且变异范围将随着时间的推移降低
pc=0.4;       %交叉概率
Error=1e-6;   %停止的误差
%%
%遗传算法开始，
%这里采用父子混合选择遗传算法，即在种群进化中，
%独立地对中的对母体执行交叉，生成中间种群，独立地对中的每一个中间个体执行变异，生成子代种群，
%在父代种群与子代种群的并集中选择母体作为新一代父代种群
%终止条件为最大代数条件和适应度不变条件
M=InitGen(pop_size);%产生初始种群
solution=[];
for i=1:max_gen
    %种群每个个体计算适应度
    eval=[];
    for j=1:pop_size
        eval(j)=penalty(M(j,:));
    end
    %交叉过程
    [M,eval]=CrossOperater(M,lamda,eval,pop_size,pc);
    %变异过程
    [M,eval]=VaryOperater(M,pm,eval,pop_size,i);
    %选择过程
    [M,eval]=SelectOperater(eval,M,pop_size);
    %下面解的构成，每一行为一代种群的适应度最大的个体及其适应度，第一列表示aw，第二列表示bw，第三列表示bo，第四列表示适应度
    solution=[solution;M(1,:),max(eval)];
    aw=solution(1);
    bw=solution(2);
    bo=solution(2);
    ao=1;
    %若种群代数大于300戴，且适应度等于300代前的适应度，则停止迭代
    if(i>300)
        if(solution(end,4)-solution(end-299,4)<Error)
            break;
        end
    end
end
FinalSolution=solution(end,1:3);%最后的结果，按顺序aw,bw,bo
%%
%画适应度收敛图
plot(solution(:,end));
xlabel('种群代数');
ylabel('适应度值');

%%
%画拟合前后的图
aw=FinalSolution(1);
bw=FinalSolution(2);
bo=FinalSolution(3);
ao=1;
Krw=aw*((Sw-Swi)/(1-Swi-Sor)).^bw;
Kro=ao*((1-Sw-Sor)/(1-Swi-Sor)).^bo;
fw0=1./(1+RHOo*MUw*Bw/RHOw/MUo/Bo*Kro./Krw);
figure;
plot(Sw,fw);
hold on;
plot(Sw,fw0);
hold off;
xlabel('Sw');
ylabel('fw');
legend('实际值','计算值');

%%
figure;
Krw_cal=aw*((Sw_measure-Swi)/(1-Swi-Sor)).^bw;
Kro_cal=ao*((1-Sw_measure-Sor)/(1-Swi-Sor)).^bo;
plot(Sw_measure,Krw_cal,'^-r');
hold on;
plot(Sw_measure,Krw_measure,'^-g');
plot(Sw_measure,Kro_cal,'s-r');
plot(Sw_measure,Kro_measure,'s-g');
xlabel('含水饱和度');
xlim([0,1]);
ylabel('相对渗透率');
ylim([0,1]);
legend('计算值Krw','测量值Krw','计算值Kro','测量值Kro');
hold off;
%%
figure;
plot(R,fw,'g');
hold on;
plot(R,fw0,'r');
hold off;
xlabel('采收率R');
ylabel('fw');
