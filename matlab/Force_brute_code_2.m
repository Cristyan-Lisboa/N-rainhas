clear; clc;
n=input('Board Size : ');
if n==2 | n==3
    A=0;
    disp(A)
else
t=0; A=0; k=1; r=1:n:n*n;
while k<=n
    x=k; ;y=ceil(r(randi(length(r)))/n);
for i=1:n
    for j=1:n
        A(x,j)=1;
        A(i,y)=1;
        if i-j==x-y
        A(i,j)=1;
        elseif j+i==y+x
        A(i,j)=1;
        end
    end
end
A(x,y)=2;
k=k+1;
if k>n
    break
end
r=k:n:n*n; d=(find(A==1))';
for i=1:length(d)
    r(r==d(i))=[];
end
if isempty(r)
    k=1; A=0; r=1:n:n*n;
end
t=t+1;
end
A=A-1;
end
a=zeros(n)+0.6;
for i=1:n
    for j=1:n
    if rem(i+j,2)==0
    a(i,j)=0.9;
    end
    end
end
h=imshow(a,'InitialMagnification',5000);
axis equal
axis on
for i=1:n
    for j=1:n
    if A(i,j)==1;
    queen(i,j)=text(i,j,char(9819),...
        'HorizontalAlignment','center',...
        'FontSize',30);
    end
    end
end