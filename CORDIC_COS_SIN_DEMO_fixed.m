% CORDIC ԭ�������� - ������
% �ο� https://blog.csdn.net/qq_39210023/article/details/77456031
clear
N = 14; % ����λ��
theta = -45; % ����Ƕȣ����Ƕ��Ʒ������ʵ��
iterN = 14;
x = zeros(1,1+iterN);
y = zeros(1,1+iterN);
z = zeros(1,1+iterN);
x(1) = round (0.607253 * 2^(N-1)*0.9); % CORDIC��ֵ
z(1) = round(theta / 360 * 2^(N-1));
atand_table = zeros(1,iterN);
for iter = 1:iterN
    atand_table(iter) = round(atand(2^(-iter+1)) / 360 * 2^(N-1));
end
% Ҫ������ֵ x(1) �����б� atand_table

for iter = 1:iterN
    if (z(iter)>=0) % d ��������z�ķ���λ��FPGA��ֱ��ȡ�ÿɱ����ӳ�
        d = 1;
    else
        d = -1;
    end
    x(iter+1) = x(iter) - d*floor(y(iter)*2^(-iter+1));
    y(iter+1) = y(iter) + d*floor(x(iter)*2^(-iter+1));
    % z(iter+1) = z(iter) - d*atand(2^(-iter+1));
    z(iter+1) = z(iter) - d*atand_table(iter);
end

fprintf('sin(theta) = %f\n',y(end)/(2^(N-1))/0.9);
fprintf('cos(theta) = %f\n',x(end)/(2^(N-1))/0.9);