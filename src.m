xPos=[]
yPos=[]
% 五次多项式插值，0-1，插值50个点
% s=tpoly(0 ,1 ,49);
t=[0:1:49]'; %仿真时间
[s,sd,sdd]=tpoly(0,10,50);  %把速度，加速度也得出来
figure 
subplot(1,4,1)
plot(t,s,'r')
xlabel('时间t/s');ylabel('目标位置');
grid on

subplot(1,4,2)
plot(t,sd,'g')
xlabel('时间t/s');ylabel('速度指令');
grid on

subplot(1,4,3)
plot(t,sdd)
xlabel('时间t/s');ylabel('加速度指令');
grid on

% 加载库(remoteApiProto.m)
vrep=remApi('remoteApi'); 
% 关闭所有连接，连接复位
vrep.simxFinish(-1); 
%建立连接。第2个参数是CoppeliaSim服务端的IP地址；第2个参数是端口号；第3个参数表示此时等待连接成功或超时（block函数调用）；第4个参数表示一旦连接失败，不再重复尝试连接；第5个参数是超时时间设定（毫秒）；第6个参数是数据包通信频率，默认为5ms。返回值是当前Client的ID，如果是-1，表示未能连接成功。%}
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
    % 连接成功
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
    xlabel('时间t/s');ylabel('实际X位置');
    grid on

    subplot(1,2,2)
    plot(t,yPos,'g')
    xlabel('时间t/s');ylabel('实际Y位置');
    grid on
else
    % 连接失败
     disp('Connecte failure');
end  
%关闭与CoppeliaSim的连接。
vrep.simxFinish(clientID);
vrep.delete(); 