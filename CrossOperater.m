function [M,eval]=CrossOperater(M1,lamda,eval1,pop_size,pc)
%%
%交叉算子
%按概率选取一定的父本进行交叉
rand1=rand(1,pop_size)<pc;
%ordinal为选取的交叉母本的序号
ordinal=find(rand1);
%num为母本的个数
num=length(ordinal);
M=M1;
eval=eval1;
if num~=0 && num~=1 %个数小于2，则不交叉，否则交叉
    if mod(num,2)==0  %个数为偶数，则全部两两交叉
        for j=0:num/2-1
            ind1=M(ordinal(j*2+1),:);
            ind2=M(ordinal(j*2+2),:);
            [ind3,ind4]=cross(ind1,ind2,lamda);
            eval3=penalty(ind3);
            eval4=penalty(ind4);
            eval=[eval,eval3,eval4];
            M=[M;ind3;ind4];
        end
    else
        for j=1:(num-1)/2  %个数为奇数，则前n-1个两两交叉
            ind1=M(ordinal(j*2-1),:);
            ind2=M(ordinal(j*2),:);
            [ind3,ind4]=cross(ind1,ind2,lamda);
            eval3=penalty(ind3);
            eval4=penalty(ind4);
            eval=[eval,eval3,eval4];
            M=[M;ind3;ind4];
        end
    end
end