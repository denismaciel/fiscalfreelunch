// Erceg and Lind�(2014): Is there a fiscal free lunch in a liquidity trap?
// Denis Maciel and Tobias M�ller
// standard log-linarized version of the New Keynesian model with zero lower bound

// Compute responses analytically for small NK model 
// monetary policy follow Taylor rule after exit
// makes restrictive assumption that govt spending and taste shocks are AR1



// List endogenous variables
var
xV piV iV ypotV rpotV debtg conshk govshk lumptax yV rV;


// List exogenous shock(s)
varexo
eps_con eps_gov;


// List structural parameters and assign values
parameters
beta alpha sigma chi shrgy nuc xip rho 
gam_xgap gam_pi phi_tax thetap sigma_hat phi_mc kappap rbar taxsub sig_con pibar ibar sig_gov;



///////////////////////////////////////////////////7
// Initialize Parameters
sig_gov = 1;
beta    =  0.995  ;        // discount factor
alpha   =  0.3    ;        // capital share, so (1-alpha) = labor share
sigma   =  1      ;        // intertemporal elasticity of substitution in consumption
chi     =  2.5    ;        // inverse of Frisch elasticity of labor supply

shrgy   =  0.2    ;        // government share of steady-state output
nuc     =  0.01   ;        // scale parameter on the consumption taste shock

xip    =  0.8       ;          // Calvo price parameter - stickiness and contract duration: 5 quarter duration
//xip  =  1       ;        // Calvo price parameter - stickiness and contract duration: No inflation responses
//xip  =  0       ;        // Calvo price parameter - stickiness and contract duration: flexible prices

gam_xgap=  0.2   ;        // coefficient on output gap: Taylor rule feedback on output gap (Werte aus anderem Model Jesper 1000/ standard value 0.2)
gam_pi  =  1.5   ;        // coefficient on inflation: Taylor rule feedback on expected inflation (Werte aus anderem Model Jesper 1000/standard value 1.5)

rho     =  0.1    ;        // AR(1) natural rate (preference and government shock)

phi_tax =  0.01   ;        // tax rule parameter

thetap  =  0.7    ;        // steady-state labor share - (1-alpha) capital share

sig_con =  15  ;         // Std of consumption taste shock(in percent?)  random value

rbar = (1/beta) -1  ;      // steady state real interest rate

//maxoperator ZLB
pibar = 1.005;
ibar = (pibar/beta) - 1;    //nominal nominal interest rate - duration of the liquidity trap depends solely on how lon rpotV remains below -ibar

//sigma_hat
sigma_hat = sigma*(1-shrgy)*(1-nuc);            // sensitivity of the output gap to the real interest rate
                                              

//phi_mc
//phi_mc = lam_mrs+lam_mpl;
phi_mc= (chi/(1-alpha) + 1/sigma_hat) + (alpha/(1-alpha));

//lam_mrs = chi/(1-alpha) + 1/sigma_hat;        // slope of MRS schedule (how supply real wage varies with output -
                                                // Fish elasticity of labor supply - interest sensitivity of aggregate demand
//lam_mpl = alpha/(1-alpha);                    // slope of MPL schedule (how demand real wage varies with output in abs value)
                                                // labor share of production



//kappap
kappap = ((1-xip)*(1-beta*xip)/xip)*phi_mc;  // Calvo-Yun contract structure - set kappap close to zero to keep inflation konstant
//kappap*xip = (1-xip)*(1-beta*xip)*phi_mc    // multiply with xip to set psis=0 and get model with flexible prices


//financing government spending
taxsub= shrgy/thetap;




///////////////////////////////////////////////////////
// Write down system of equilibrium equations
model;

//New Keynesian IS equation
xV= xV(+1)- sigma_hat*(iV-piV(+1) - rpotV);


//Phillips curve
piV= beta*piV(+1)+kappap*xV;


//Taylor rule
iV= max(-ibar,gam_pi*piV+gam_xgap*xV);   //Taylor rule subject to zero lower bound


//Potential output
ypotV= (1/phi_mc*sigma_hat)*(shrgy*govshk+(1-shrgy)*nuc*conshk);


//Natural real interest rate
rpotV= 1/sigma_hat * (1 - 1/(phi_mc*sigma_hat)) * ( shrgy*(govshk-govshk(+1)) + (1-shrgy)*nuc*(conshk-conshk(+1)) );


//government budget constraint
debtg=(1+rbar)*debtg(-1)+shrgy*govshk-taxsub*thetap*(yV+phi_mc*xV)-lumptax;


//lump-sum tax (adjusts according to the reaction function)
lumptax= phi_tax*debtg(-1);


//output yV
yV=xV+ypotV;

// real interest rate rV
rV=4*iV-piV(+1);


// shock processes
conshk= (1-rho)*conshk(-1)+eps_con;
govshk= (1-rho)*govshk(-1)+eps_gov;


end;
///////////////////////////////////////////////////////

//exogenous evolution of g(t) and v(t)
//rho_g1 = 0;
//rho_g2 = .1;
//rho_v2 = .1;
//rho_c2 = rho_v2;
//shrgy = 0.2;



//if chi=2.5 and sigma =1, then this value gives a duration of the liquidity
//trap of 8 quarters for xip=0.8


// Assign analytical steady state values as initial values
initval;
xV=0;
piV=0;      
iV=0	;       
ypotV=0;
rpotV=0;
debtg=0;
lumptax=0;
yV=0;
conshk=0;
govshk=0;
end;


// calculate analytical steady state values of endog. variables
steady ;

// Check stability conditions 
check;


// government spending shock
shocks;
var eps_gov;
periods 1:1;
values (sig_gov);
end;
///eps_gov_0= 1/shrgy = 1/0.2 = 5

shocks;
var eps_con;
periods 1:1;
values(-sig_con); 
end;


A = zeros(11,42);	
@#define x = ["0","0.019474","0.038947","0.058421","0.077895","0.097368","0.11684","0.13632","0.15579","0.17526","0.19474","0.21421","0.23368","0.25316","0.27263","0.29211","0.31158","0.33105","0.35053","0.37"]

@#for sig_gov_val in x
	sig_gov = @{sig_gov_val};

	shocks;
	var eps_gov;
	periods 1:1;
	values (sig_gov);
	end;

	simul(periods=40);
	A = cat(3, A, oo_.endo_simul);
@#endfor

A = A(:,:,2:end);
	
liqduration = zeros(1,size(A,3));
for i = 1:size(A,3)
	x = sum(A(3, 1:end, i) == -ibar);
	liqduration(i) = x;	
end
	
x = [0,0.019474,0.038947,0.058421,0.077895,0.097368,0.11684,0.13632,0.15579,0.17526,...
	0.19474,0.21421,0.23368,0.25316,0.27263,0.29211,0.31158,0.33105,0.35053,0.37];

plot(x, liqduration) //get the amazing plot of the Stair...
