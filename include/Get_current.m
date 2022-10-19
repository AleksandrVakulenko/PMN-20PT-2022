
function [Field, Current] = Get_current(feloop) %TODO: convert units to Amp

Sample = feloop.sample; %H(m), S(m^2), Gain(1)


Ep = feloop.E.p(1:end/2); %kV/cm
Qp = feloop.P.p(1:end/2) * Sample.S*100^2 * 1e-6; %Q
time_p = feloop.ref.time.p(1:end/2); %s

En = feloop.E.n(1:end/2);
Qn = feloop.P.n(1:end/2) * Sample.S*100^2 * 1e-6;
time_n = feloop.ref.time.n(1:end/2);


Size = size(time_p, 1);
Med_size = round(Size*0.00045);
Move_size = round(Size*0.0045);
if Med_size == 0
    Med_size = 1;
end
if Move_size == 0
    Move_size = 1;
end

Ep = medfilt1(Ep, Med_size);
Ep = movmean(Ep, Move_size);
Qp = medfilt1(Qp, Med_size);
Qp = movmean(Qp, Move_size);

En = medfilt1(En, Med_size);
En = movmean(En, Move_size);
Qn = medfilt1(Qn, Med_size);
Qn = movmean(Qn, Move_size);


Current.p = diff(Qp)./diff(time_p);
Current.p = medfilt1(Current.p, Med_size);
Current.p = movmean(Current.p, Move_size);
Current.p(Current.p<0) = 0;
Current.p(end+1) = Current.p(end);

Current.n = diff(Qn)./diff(time_n);
Current.n = medfilt1(Current.n, Med_size);
Current.n = movmean(Current.n, Move_size);
Current.n(Current.n>0) = 0;
Current.n(end+1) = Current.n(end);

Field.p = Ep;
Field.n = En;

end