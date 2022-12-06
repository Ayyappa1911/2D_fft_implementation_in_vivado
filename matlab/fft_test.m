inp = [
         1,1,1,1,1,1,1,1;
         0,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0;
         1,1,1,1,1,1,1,1;
         0,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0;
         0,0,0,0,0,0,0,0;
      ];


tmp = zeros(8,8);

for i = 1 : 1 : 8
    tmp(:,i) = fft(inp(:,i));
end
out = zeros(8,8);
for i = 1 : 1 : 8
    out(i,:) = fft(tmp(i,:));
end

out1 = fft2(inp);

disp(inp)
disp('out = ')
disp(out)
disp('out1 = ')
disp(out1)

