function M1=vary(M,t,T)
%功能：变异函数。M为待变异量，t为变异代数，T为总的代数。
%变异时采用随代数变小的变异方法，且变异后仍然满足约束条件
global bwMax;
global boMax;
global A;
r1=rand();
r2=randi([0,1],1,1);
aw=M(1);
bw=M(2);
bo=M(3);
%若r2为0，则向大处变异，并保证不超过最大值，若r2为1则向小处变异，并保证不小于0
if(r2==0)
    bw1=bw+(bwMax-bw)*r1*(1-t/T)^2;
elseif(r2==1)
    bw1=bw-bw*r1*(1-t/T)^2;
end
r1=rand();
r2=randi([0,1],1,1);
%若r2为0，则向大处变异，并保证不超过最大值，若r2为1则向小处变异，并保证不小于0
if(r2==0)
    bo1=bo+(boMax-bo)*r1*(1-t/T)^2;
elseif(r2==1)
    bo1=bo-bo*r1*(1-t/T)^2;
end
r1=rand();
r2=randi([0,1],1,1);
Abw=A.^(-bw1);
MinAbw=min(Abw);
%若r2为0，则向大处变异，并保证不超过最大值，若r2为1则向小处变异，并保证不小于0
if(r2==0)
    aw1=aw+(MinAbw-aw)*r1*(1-t/T)^2;
elseif(r2==1)
    aw1=aw-aw*r1*(1-t/T)^2;
end
M1=[aw1,bw1,bo1];