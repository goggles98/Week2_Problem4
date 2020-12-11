step(linsys1);
hold on;
[A,B,C,D] = ssdata(linsys1);
s = tf('s');
[num,den] = ss2tf(A,B,C,D);
Gs = tf(num, den);
step(Gs);