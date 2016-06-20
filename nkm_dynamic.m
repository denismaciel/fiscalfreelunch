function [residual, g1, g2, g3] = nkm_dynamic(y, x, params, steady_state, it_)
%
% Status : Computes dynamic model for Dynare
%
% Inputs :
%   y         [#dynamic variables by 1] double    vector of endogenous variables in the order stored
%                                                 in M_.lead_lag_incidence; see the Manual
%   x         [M_.exo_nbr by nperiods] double     matrix of exogenous variables (in declaration order)
%                                                 for all simulation periods
%   params    [M_.param_nbr by 1] double          vector of parameter values in declaration order
%   it_       scalar double                       time period for exogenous variables for which to evaluate the model
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the dynamic model equations in order of 
%                                          declaration of the equations
%   g1        [M_.endo_nbr by #dynamic variables] double    Jacobian matrix of the dynamic model equations;
%                                                           rows: equations in order of declaration
%                                                           columns: variables in order stored in M_.lead_lag_incidence
%   g2        [M_.endo_nbr by (#dynamic variables)^2] double   Hessian matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence
%   g3        [M_.endo_nbr by (#dynamic variables)^3] double   Third order derivative matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

%
% Model equations
%

residual = zeros(11, 1);
T47 = 1/params(13);
T49 = 1/(params(13)*params(14));
lhs =y(4);
rhs =y(15)-params(13)*(y(6)-y(16)-y(8));
residual(1)= lhs-rhs;
lhs =y(5);
rhs =y(16)*params(1)+y(4)*params(15);
residual(2)= lhs-rhs;
lhs =y(6);
rhs =y(5)*params(10)+y(4)*params(9);
residual(3)= lhs-rhs;
lhs =y(7);
rhs =params(13)*1/params(14)*(params(5)*y(11)+(1-params(5))*params(6)*y(10));
residual(4)= lhs-rhs;
lhs =y(8);
rhs =T47*(1-T49*(params(5)*(y(11)-y(18))+(1-params(5))*params(6)*(y(10)-y(17))));
residual(5)= lhs-rhs;
lhs =y(12);
rhs =params(5)*y(11)+(1+params(17))*y(3)-params(16)*params(12)*(y(14)+y(4)*params(14))-y(9);
residual(6)= lhs-rhs;
lhs =y(9);
rhs =y(3)*params(11);
residual(7)= lhs-rhs;
lhs =y(13);
rhs =y(6)-y(16);
residual(8)= lhs-rhs;
lhs =y(14);
rhs =y(4)+y(7);
residual(9)= lhs-rhs;
lhs =y(10);
rhs =(1-params(8))*y(1)+x(it_, 1);
residual(10)= lhs-rhs;
lhs =y(11);
rhs =(1-params(8))*y(2)+x(it_, 2);
residual(11)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(11, 20);

  %
  % Jacobian matrix
  %

  g1(1,4)=1;
  g1(1,15)=(-1);
  g1(1,16)=(-params(13));
  g1(1,6)=params(13);
  g1(1,8)=(-params(13));
  g1(2,4)=(-params(15));
  g1(2,5)=1;
  g1(2,16)=(-params(1));
  g1(3,4)=(-params(9));
  g1(3,5)=(-params(10));
  g1(3,6)=1;
  g1(4,7)=1;
  g1(4,10)=(-(params(13)*1/params(14)*(1-params(5))*params(6)));
  g1(4,11)=(-(params(13)*1/params(14)*params(5)));
  g1(5,8)=1;
  g1(5,10)=(-(T47*(-((1-params(5))*params(6)*T49))));
  g1(5,17)=(-(T47*(-(T49*(-((1-params(5))*params(6)))))));
  g1(5,11)=(-(T47*(-(params(5)*T49))));
  g1(5,18)=(-(T47*(-(T49*(-params(5))))));
  g1(6,4)=params(14)*params(16)*params(12);
  g1(6,9)=1;
  g1(6,11)=(-params(5));
  g1(6,3)=(-(1+params(17)));
  g1(6,12)=1;
  g1(6,14)=params(16)*params(12);
  g1(7,9)=1;
  g1(7,3)=(-params(11));
  g1(8,16)=1;
  g1(8,6)=(-1);
  g1(8,13)=1;
  g1(9,4)=(-1);
  g1(9,7)=(-1);
  g1(9,14)=1;
  g1(10,1)=(-(1-params(8)));
  g1(10,10)=1;
  g1(10,19)=(-1);
  g1(11,2)=(-(1-params(8)));
  g1(11,11)=1;
  g1(11,20)=(-1);
end
if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],11,400);
end
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],11,8000);
end
end