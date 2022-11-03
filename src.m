xPos=[]
yPos=[]
% ��ζ���ʽ��ֵ��0-1����ֵ50����
% s=tpoly(0 ,1 ,49);
t=[0:1:49]'; %����ʱ��
[s,sd,sdd]=tpoly(0,10,50);  %���ٶȣ����ٶ�Ҳ�ó���
figure 
subplot(1,4,1)
plot(t,s,'r')
xlabel('ʱ��t/s');ylabel('Ŀ��λ��');
grid on

subplot(1,4,2)
plot(t,sd,'g')
xlabel('ʱ��t/s');ylabel('�ٶ�ָ��');
grid on

subplot(1,4,3)
plot(t,sdd)
xlabel('ʱ��t/s');ylabel('���ٶ�ָ��');
grid on

% ���ؿ�(remoteApiProto.m)
vrep=remApi('remoteApi'); 
% �ر��������ӣ����Ӹ�λ
vrep.simxFinish(-1); 
%�������ӡ���2��������CoppeliaSim����˵�IP��ַ����2�������Ƕ˿ںţ���3��������ʾ��ʱ�ȴ����ӳɹ���ʱ��block�������ã�����4��������ʾһ������ʧ�ܣ������ظ��������ӣ���5�������ǳ�ʱʱ���趨�����룩����6�����������ݰ�ͨ��Ƶ�ʣ�Ĭ��Ϊ5ms������ֵ�ǵ�ǰClient��ID�������-1����ʾδ�����ӳɹ���%}
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
    % ���ӳɹ�
    disp('Connected to remote API server');
    for i=1:1:50
        vel_x = sd(i)
        [returnCode,outInts,outFloats,outStrings,outBuffer] = vrep.simxCallScriptFunction(clientID,'carBody',vrep.sim_scripttype_childscript,'remoteCmd',[1],[vel_x,0.0,0.0],['ss'],[],vrep.simx_opmode_blocking)
        xPos(i) = outFloats(1)
        yPos(i) = outFloats(2)
        disp('step:');disp(i);
        %X = ;
        disp([' speed X command: ',num2str(vel_x),' m/s'])
        pause(1)
    end 
    disp('finish');
    figure 
    subplot(1,2,1)
    plot(t,xPos,'r')
    xlabel('ʱ��t/s');ylabel('ʵ��Xλ��');
    grid on

    subplot(1,2,2)
    plot(t,yPos,'g')
    xlabel('ʱ��t/s');ylabel('ʵ��Yλ��');
    grid on
else
    % ����ʧ��
     disp('Connecte failure');
end  
%�ر���CoppeliaSim�����ӡ�
vrep.simxFinish(clientID);
vrep.delete(); 