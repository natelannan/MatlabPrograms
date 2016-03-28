clc
clear all
close all

x=1:10;
y=1:20;
h=[3 3 3 3 3];
sig=cat(2,x,10+x,20+x,30+x,40+x,50+x);
straightUp=conv(sig,h);
for i=1:5
    if i==1
        init=conv(sig(1:20), h);
    else
        wrong(i-1,:)=conv(sig((i*10+1):((i+1)*10)),h);
    end
end

foo1=padarray(init,[0 64-24], 'post');
foo2=padarray(wrong(1,:),[0 20],'pre');
foo2=padarray(foo2,[0 64-34], 'post');
foo3=padarray(wrong(2,:),[0 30],'pre');
foo3=padarray(foo3,[0 64-44], 'post');
foo4=padarray(wrong(3,:),[0 40],'pre');
foo4=padarray(foo4,[0 64-54], 'post');
foo5=padarray(wrong(4,:),[0 50],'pre');

fuck=foo1+foo2+foo3+foo4+foo5;
figure(1)
subplot(2,1,1)
plot(straightUp)
subplot(2,1,2)
plot(fuck)
