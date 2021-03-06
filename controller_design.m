%% Load state space model from .mat file and obtain the open loop tf

[A,B,C,D] = ssdata(linsys1);
s = tf('s');
[num,den] = ss2tf(A,B,C,D);
Gs = tf(num, den);

% Convert this digital tf to discrete and eliminate the pole-zeroes
T_samp = 0.001;
d_Gs = c2d(Gs, T_samp, 'zoh');
d_Gs = minreal(d_Gs, 0.001);

Gs = d2c(d_Gs);

% apply unity feedback and check the output
sys = feedback(Gs, 1);
os_per = 7.16       % Percentage overshoot obtained from step response
z = sqrt(((log(os_per/100))^2) / (pi^2 + (log(os_per/100))^2));

% % zpk(sys)  % To see the poles of the system.
% % Dominant closed loop poles: (29.61 +- 35.28*i)
% 

%% Find the angle made by the zeta line and the new point of rootlocus
z_angle = pi - atan(35.28/29.61);

Ts = 0.035;      % choose a setting time < 0.04
real_part = 4/Ts
img_part = real_part * tan(pi - z_angle);

%% Find the location of the zero to be added.
% 59.23 is one of the open loop poles, 0 is another open-loop pole
zero_angle = pi + (pi - atan(img_part/(real_part - 59.23))) + (pi - atan(img_part / real_part))
zero_angle = mod((zero_angle) * 180/pi, 360);       % angle in degrees
zero_angle = zero_angle * pi / 180;                 % angle in radians

zero_real_part = real_part - (img_part / tan(pi - zero_angle));

PD = (s + zero_real_part);
PI = (s + 0.01)/s;
sys = feedback(PD*Gs*PI, 1);
step(sys);

% controller equation: s + 186.57 + 1.86/s
% Kp = 186.57
% Kd = 1
% Ki = 1.86
