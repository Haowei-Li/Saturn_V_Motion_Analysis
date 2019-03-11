%Define Variables
syms t;
MAT_Gm=[2290000, 496200, 123000];
MAT_Isp=[263, 421, 421];
MAT_mr=[130000, 40100, 13500];%Categorizing the parameters provided and store them in marices.  

for i=1:3 %Iterate three times using a for loop to calculate the velocity function of each stage. 
    if i==1%Calculation of the first stage. 
    Isp=MAT_Isp(1);
    mi=sum(MAT_Gm);%The initial mass is the sum of the gross mass. 
    mf=MAT_Gm(2)+MAT_Gm(3)+MAT_mr(1);
    u1(t)=9.81.*(Isp.*log(mi./(mi-(mi-mf).*(t./165)))-t);%ln is log in Matlab
    v1=u1(165);
    elseif i==2
    Isp=MAT_Isp(2);
    mi=MAT_Gm(2)+MAT_Gm(3);%The initial mass is the sum of the gross mass of stages 2 and 3. 
    mf=MAT_mr(2)+MAT_Gm(3);%The final mass is the sum of the gross mass of stage 3 and remaining mass of Stage 2. 
    u2(t)=9.81.*(Isp.*log(mi./(mi-(mi-mf).*((t-165)./360)))-(t-165))+v1;%The ending velocity from the previous stage is added
    %t is subtracted 165 because each stage is considered individually.
    v2=u2(525);
    elseif i==3
    Isp=MAT_Isp(3);
    mi=MAT_Gm(3);%The initial mass is the gross mass of Stage 3. 
    mf=MAT_mr(3);%The final mass is the remaining mass of Stage 3.
    u3(t)=9.81.*(Isp.*log(mi./(mi-(mi-mf).*((t-525)./500)))-(t-525))+v2;%The ending velocity from the previous stage is added
    end
end
figure(1)%Determines the position function by integrating the piecewise velocity function
h1(t)=int(u1,t,0,t);
fplot(h1-h1(6.5),[0,165],'r-');%subtract h1(6.5) because it is known that the rocket doesn't leave the tower until 6.5s, h(t=6.5)=0.
hold on;
grid on;
h2(t)=int(u2,t,0,t);
hf1=h2(165)-h1(165);
fplot((h2-hf1)-h1(6.5),[165,525],'b-');%Set the initial value of the second piece to the ending value of the previous piece
hold on;
h3(t)=int(u3,t,0,t);
hf2=h3(525)-h2(525);
fplot((h3-(h3(525)-(h2(525)-hf1))-h1(6.5)),[525,1025],'g-');
hold on;
%Generate legend, title, and axis labels. 
legend('Stage 1','Stage 2','Stage 3');
title('Position Versus Burn Time for the Three Stages of Saturn V Rocket');
xlabel('Burn Time (s)');
ylabel('Position (m)');

figure(2) %Plots the piecewise function of velocity
fplot (u1,[0,165],'r-');
hold on;
grid on;
fplot (u2,[165,525],'b-');
hold on;
fplot (u3,[525,1025],'g-');
hold on;
%Generate legend, title, and axis labels. 
legend('Stage 1','Stage 2','Stage 3');
title('Velocity Versus Burn Time for the Three Stages of Saturn V Rocket');
xlabel('Burn Time (s)');
ylabel('Velocity (m/s)');

figure(3)%Figure for acceleration versus time.%acceleration???C?
a1(t)=diff(u1);%Differentiates the velocity function to obtain an acceleration function.
fplot(a1,[0,165],'r-');
hold on;
grid on;
a2(t)=diff(u2);
fplot(a2,[165,525],'b-');
hold on;
a3(t)=diff(u3);
fplot(a3,[525,1025],'g-');
hold on;
%Generate legend, title, and axis labels. 
legend('Stage 1','Stage 2','Stage 3');
title('Acceleration Versus Burn Time for the Three Stages of Saturn V Rocket');
xlabel('Burn Time (s)');
ylabel('Acceleration (m/s^2)');

%Output the final velocity
fprintf('For part (b), the estimated final velocity once all fuel is used is %.2f m/s.\n', round(u3(1025)));

%Compare the estimated final velocity with the velocity required to exit
%earth's orbit, 11.2km/s. 
if u3(1025)>=11200
    disp ("For part (c), The rocket has achieved the exit velocity required to leave earth's orbit.");
else
    disp ("For part (c), The rocket has not achieved the exit velocity required to leave earth's orbit.");
end



