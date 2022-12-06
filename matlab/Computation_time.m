clc
close all

inp=[1 1 1 1 1 1 1 1 ;
     2 2 2 2 2 2 2 2 ;
     3 3 3 3 3 3 3 3 ;
     4 4 4 4 4 4 4 4 ;
     5 5 5 5 5 5 5 5 ;
     6 6 6 6 6 6 6 6 ;
     7 7 7 7 7 7 7 7 ;
     8 8 8 8 8 8 8 8 ;];

t1=cputime;
for i=1:10000
fft_mat=fft2(inp);
end
t2=cputime;
tend=t2-t1;
disp(tend)
disp(t2)
disp(t1)