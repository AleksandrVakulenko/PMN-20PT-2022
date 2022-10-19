% v(1) - R
% v(2) - I_bias
% v(3) - Eps

% clc
% Eps_out = find_eps(feloop)


function [Eps_out, Err, R_out] = find_eps(feloop)

Ref_P = feloop.ref.P.p;

I_bias_gain = 1e-8;

model = @(v) charge_calc(feloop, 10^v(1), v(2)*I_bias_gain, v(3)) - Ref_P;


Lower = [  0    -1        1  ];
Start = [  15    0      100  ];
Upper = [  15   +1    20000  ];


options = optimoptions('lsqnonlin', ...
    'FiniteDifferenceType','central', ...
    'MaxFunctionEvaluations', 800000, ...
    'FunctionTolerance', 1E-12, ...
    'TolFun', 1e-12, ...
    'Algorithm','trust-region-reflective', ... %levenberg-marquardt trust-region-reflective
    'MaxIterations', 5000, ...
    'StepTolerance', 1e-12, ...
    'PlotFcn', '', ... %optimplotresnorm optimplotstepsize OR ''  (for none)
    'Display', 'off', ... %final off iter
    'FiniteDifferenceStepSize', 1e-12, ...
    'CheckGradients', true, ...
    'DiffMaxChange', 1e-8);

% [vestimated,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(ModelFunction, Start, Lower, Upper, options);
[vout,~,residual,~,~,~,jacobian] = lsqnonlin(model, Start, Lower, Upper, options);

R = 10^vout(1);
I_bias = vout(2)*I_bias_gain;
Eps = vout(3);

Eps_out = Eps;
Hess =jacobian'*jacobian;
DataSize = size(residual,1);
ParSize = size(vout,2);
sigmSqr = (residual'*residual)/(DataSize-ParSize);
VarCovar = inv(Hess)*sigmSqr;
% 
for k=1:3
    error(k) = (full(VarCovar(k,k))).^0.5;
end
Err = error(3)*3; %3 сигма

R_out = R;
end





function out = charge_calc(feloop, R, Bias_current, Eps)

Time = feloop.ref.time.p;
Volt = feloop.ref.volt.p;
Field = feloop.ref.E.p;
Surface = feloop.sample.S;

Current = Volt/R + Bias_current; %A
Current_charge = cumsum(Current)*mean(diff(Time)); %C
Current_polarization = (Current_charge*1e6)/(Surface*1e4) ; %uC/cm^2

% Polar_charge = 
Field = Field*1000*100; %V/m
% Polarization = 8.85e-12 * ((Eps-1)*Field + (Eps2-1)*Field.^2);% C/m^2
Polarization = 8.85e-12 * (Eps-1)*Field;% C/m^2

Polarization = Polarization * (1e6/1e4);% uC/cm^2

out = Current_polarization + Polarization;
end
























