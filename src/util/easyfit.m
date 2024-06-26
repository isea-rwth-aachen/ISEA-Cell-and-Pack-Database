function [pbest,delta_p,ybest,delta_y,chi0,exitflag,output]=easyfit(x,y,varargin)
% 
% [pbest,delta_p,ybest,delta_y,chi0,exitflag,output]=easyfit(x,y,varargin)
%
% numerous examples are given belower in this help.
%
% EASYFIT fits the experimental data (x,y) to a model function y = fun(p,x).
% If a model function is not given as an input argument, a polynomial model is used.
% Bounds (constraints) may be applied on the parameters pbest values returned by easyfit.
% An optional plot can be generated which presents the data as well the
% "best" curve and confidence intervals for data. the pbest and their uncertainties
% are displayed in the command window. For programmatic purposes, this graphical mode can be switched off.
%
% outputs:
%
% PBEST     - best parameters in a least squares meaning
% DELTA_P   - uncertainties on pbest (95% confidence intervals)
% YBEST     - values returned by fun(pbest,x)
% DELTA_Y   - uncertainties on a new observation of y at x (95% confidence intervals)
% CHI0      - summed square of residuals at pbest : chi0 = sum((ybest-y)^2)
% EXITFLAG  - exit condition (see FMINSEARCH)
% OUTPUT    - structure that contains information (see FMINSEARCH)
%
% syntax and inputs:
%
% [...] = easyfit(x,y)
%       fits y=f(x) according to a polynomial of degree 1 : 
%       y = p(1)*x + p(2)
%       x and y have to be real vectors.
%
% [...] = easyfit(x,y,pinit)
%       fits data to a polynomial of degree n = [length(pinit)-1] : 
%       y = p(1)*x.^n + p(2)*x.^(n-1) + ... + p(n)*x.^1 + p(n+1).
%       pinit is a vector of initial guessed parameters from which the fit starts.
%
% [...] = easyfit(x,y,pinit,fhandle)
%       fits data according to a user-defined function which handle is
%       fhandle.
%
% [...] = easyfit(x,y,pinit,fhandle,LB)
%       fits data with a lower bound vector for the parameters, it
%       must be the same size as pinit. If no lower bounds exist for one
%       of the parameters, then supply -inf for that variable.
%       If no lower bounds at all, then LB may be left empty.
%
% [...] = easyfit(x,y,pinit,fhandle,LB,UB)
%       fits data with upper bound vector for the parameters, it
%       must be the same size as pinit. If no upper bounds exist for one
%       of the parameters, then supply +inf for that variable.
%       If no upper bounds at all, then LB may be left empty.
%
% [...] = easyfit(x,y,pinit,fhandle,LB,UB,'np')
%       switch the default state from PLOT to NON PLOT, leave empty otherwise.
%
% [...] = easyfit(x,y,pinit,fhandle,LB,UB,'np',options)
%       OPTIONS are to be set when for instance, function values are
%       typically lower than 10^-4. See OPTIMSET in the MATLAB help.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : linear fitting
    % x=-3:0.2:3;                                        
    % y=5*x+1+randn(size(x));
    % pbest=easyfit(x,y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : polynomial of degree 2 
    % x=0:0.2:3;                                        
    % y=5*x.^1.8+1+randn(size(x));
    % pinit=[1,2,3];
    % pbest=easyfit(x,y,pinit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : polynomial of degree 3 
    % x=0:0.2:3;                                        
    % y=5*x.^1.8+1+randn(size(x));
    % pinit=[1,2,3,4];
    % pbest=easyfit(x,y,pinit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : user-defined function.
% Prior to fit, the user-defined function given here as an example :
%   function y=myfun(p,x)
%	y=p(1)*x.^p(2)+p(3);
%	end
% must be saved in a file apart.
%
    % x=0:0.1:3;                                        
    % y=5*x.^1.8+1+randn(size(x));
    % pinit=[1,2,3];
    % pbest=easyfit(x,y,pinit);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : user-defined function with constraints.
% As above, except p3 is fixed to the interval 10 < p3 < 12 when p1 and p2)
% may have any value.
% Prior to fit, the user-defined function given here as an example :
%	function y=myfun(p,x)
%	y=p(1)*x.^p(2)+p(3);
%	end
% must be saved in a file apart.
%
    % x=0:0.1:3;
    % y=5*x.^1.8+1+randn(size(x));
    % pinit=[1,2,p_fixed];
    % LB = [-inf,-inf,10];
    % UB = [inf,inf,12];
    % pbest=easyfit(x,y,pinit,@myfun,LB,UB);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE : to fit numerous data and not generate plots to save time.
% Suppose you have N data files containing different experimental data [x,y]
% to be fitted by a polynomial of degree 3.
% Prior to fit, the user must define his function because the Non-Plot
% option only works with user-defined function :
%	function y=myPolynom(p,x)
%	y=p(1)*x.^3 + p(2)*x.^2 + p(3)*x + p(4);
%	end
% as usual, the function must be saved in a file apart.

    % N = 1000;
    % pbest=[];
    % pinit=[1,2,3,4];
    % for i=1:N
    %   [x,y] = importdata(file(i)); % or something like this to import the data
    %   pbest=[pbest; easyfit(x,y,pinit,@myPolynom,[],[],'np')]; 
    % end
% at each iteration in the loop, the pbest vector is concatening and
% to prevent the generation of a figure at each i, the string 'np' has been
% input when the preceeding options for LB and UB may left empty or not.
% A simple try with N = 100 has led to a 3 to 4 times faster process with the option 'np'.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       jean-luc.dellis@u-picardie.fr
%
%april 2006 :   first version
%may 2006 :
%               Special thanks to John D'Errico who created FMINSEARCHBND which 
%               allows to set bounds to the parameters values, please see :
%               http://www.mathworks.com/matlabcentral/fileexchange
%march 2008 : 
%               - put VARARGIN to simplify the use
%               - put UNCERTAINTIES as a subfunction to compute them as
%               well the data confidence intervals
%may 2018 :
%               - the examples have been improved and new one added
%               - the main results are displayed in the command window
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - note that the subfunctions FMINSEARCHBND, JACOB and UNCERTAINTIES may
% be saved in separated files. 
% - note that some sub-functions have been nested, this may cause crashes 
% when used with old versions of MATLAB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%!!!MODIFIED0412201!!!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% no plotting and output of the parameter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAIN
if nargin <2, error('Please, input at least X and Y'),end
x=x(:);y=y(:);
if isequal(nargin,2) % .... =easyfit(x,y)
    g_mode='np';
    pbest=polyfit(x,y,1);fhandle=@polyval;
    chi0=distance(pbest);
    exitflag=1;
    output=[];
    model='Linear : y = p(1)*x + p(2)';
end
if isequal(nargin,3) % .... =easyfit(x,y,pinit)
    pinit=varargin{1};g_mode='np';
    pbest=polyfit(x,y,length(pinit)-1);fhandle=@polyval;
    chi0=distance(pbest);
    exitflag=1;
    output=[];
    model='Polynomial : y = p1*x^n + p2*x^(n-1) + ... ';
end
switch nargin
    case 4 % .... =easyfit(x,y,pinit,fhandle)
    pinit=varargin{1};fhandle=varargin{2};LB=[];UB=[];
    g_mode='np';options=[];
    [pbest,chi0,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
    model='User-defined function';
    case 5 % .... =easyfit(x,y,pinit,fhandle,LB)
    pinit=varargin{1};fhandle=varargin{2};LB=varargin{3};UB=[];
    g_mode='np';options=[];
    [pbest,chi0,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
    model='User-defined function';
    case 6 % .... =easyfit(x,y,pinit,fhandle,LB,UB)
    pinit=varargin{1};fhandle=varargin{2};LB=varargin{3};UB=varargin{4};
    g_mode='np';options=[];
    [pbest,chi0,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
    model='User-defined function';
    case 7 % .... =easyfit(x,y,pinit,fhandle,LB,UB,'np')
    pinit=varargin{1};fhandle=varargin{2};LB=varargin{3};UB=varargin{4};
    g_mode=varargin{5};options=[];
    [pbest,chi0,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
    model='User-defined function';
    case 8 % .... =easyfit(x,y,pinit,fhandle,LB,UB,'np',options)
    pinit=varargin{1};fhandle=varargin{2};LB=varargin{3};UB=varargin{4};
    g_mode=varargin{5};options=varargin{6};
    [pbest,chi0,exitflag,output]=fminsearchbnd(@distance,pinit,LB,UB,options);
    model='User-defined function';
end

ybest=fhandle(pbest,x);
[jac,r] = jacob(x,y,fhandle,pbest);
delta_p=zeros(size(pbest));
delta_y=zeros(size(ybest));
[delta_p,delta_y] = uncertainties(pbest,r,jac,x,ybest);
if ~isnumeric(x) || ~isreal(x) || ~isreal(y),error('please input real vectors'),end         
if ~isequal(g_mode,'np')                    % plot and display the results
        model_s=func2str(fhandle);
        % draw the "best" y 
        plot(x, ybest,'color','r','linewidth',1.5)
        hold on
        % draw the experimental data together with the confidence intervals
        plot(x,y,'color','k','marker','.','markersize',20,'linestyle','none')
        plot(x, ybest+delta_y,'color','k','linewidth',1,'linestyle',':')
        plot(x, ybest-delta_y,'color','k','linewidth',1,'linestyle',':')
        legend('Best Curve','Data','location','best')
        % display Best parameters, Uncertainties and Chi0 in the command
        % window
        disp(' ')
        disp(['model = ',model])
        disp(['chi0 = ',num2str(chi0)])
        disp(' ')
        for i=1:length(pbest)
            st=['P',num2str(i),' = ',num2str(pbest(i)),' +/- ',num2str(delta_p(i))];
            disp(st)
        end
        disp(' ')
        hold off
end
%**************************************************************************
    % DISTANCE is "nested" so, it "knows" x,y and fhandle
    function dist=distance(pinit)      
            ymod=fhandle(pinit,x);
            dist=sum(sum((ymod-y).^2));
    end
%**************************************************************************
end % end of the main function EASYFIT

%****************************************************************************
function [x,chi0,exitflag,output]=fminsearchbnd(fun,x0,LB,UB,options,varargin)
% fminsearchbnd: fminsearch, but with bound constraints by transformation
% usage: fminsearchbnd(fun,x0,LB,UB,options,p1,p2,...)
% 
% arguments:
%  LB - lower bound vector or array, must be the same size as x0
%
%       If no lower bounds exist for one of the variables, then
%       supply -inf for that variable.
%
%       If no lower bounds at all, then LB may be left empty.
%
%  UB - upper bound vector or array, must be the same size as x0
%
%       If no upper bounds exist for one of the variables, then
%       supply +inf for that variable.
%
%       If no upper bounds at all, then UB may be left empty.
%
%  See fminsearch for all other arguments and options.
%  Note that TolX will apply to the transformed variables. All other
%  fminsearch parameters are unaffected.
%
% Notes:
%
%  Variables which are constrained by both a lower and an upper
%  bound will use a sin transformation. Those constrained by
%  only a lower or an upper bound will use a quadratic
%  transformation, and unconstrained variables will be left alone.
%
%  Variables may be fixed by setting their respective bounds equal.
%  In this case, the problem will be reduced in size for fminsearch.
%
%  The bounds are inclusive inequalities, which admit the
%  boundary values themselves, but will not permit ANY function
%  evaluations outside the bounds.
%
%
% Example usage:
% rosen = @(x) (1-x(1)).^2 + 105*(x(2)-x(1).^2).^2;
%
% fminsearch(rosen,[3 3])     % unconstrained
% ans =
%    1.0000    1.0000
%
% fminsearchbnd(rosen,[3 3],[2 2],[])     % constrained
% ans =
%    2.0000    4.0000

% size checks
xsize = size(x0);
x0 = x0(:);
n=length(x0);

if (nargin<3) || isempty(LB)
  LB = repmat(-inf,n,1);
else
  LB = LB(:);
end
if (nargin<4) || isempty(UB)
  UB = repmat(inf,n,1);
else
  UB = UB(:);
end

if (n~=length(LB)) || (n~=length(UB))
  error 'x0 is incompatible in size with either LB or UB.'
end

% set default options if necessary
if (nargin<5)|| isempty(options)
  options = optimset('fminsearch');
end

% stuff into a struct to pass around
params.args = varargin;
params.LB = LB;
params.UB = UB;
params.fun = fun;
params.n = n;

% 0 --> unconstrained variable
% 1 --> lower bound only
% 2 --> upper bound only
% 3 --> dual finite bounds
% 4 --> fixed variable
params.BoundClass = zeros(n,1);
for i=1:n
  k = isfinite(LB(i)) + 2*isfinite(UB(i));
  params.BoundClass(i) = k;
  if (k==3) && (LB(i)==UB(i))
    params.BoundClass(i) = 4;
  end
end

% transform starting values into their unconstrained
% surrogates. Check for infeasible starting guesses.
x0u = x0;
k=1;
for i = 1:n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      if x0(i)<=LB(i)
        % infeasible starting value. Use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(x0(i) - LB(i));
      end
      
      % increment k
      k=k+1;
    case 2
      % upper bound only
      if x0(i)>=UB(i)
        % infeasible starting value. use bound.
        x0u(k) = 0;
      else
        x0u(k) = sqrt(UB(i) - x0(i));
      end
      
      % increment k
      k=k+1;
    case 3
      % lower and upper bounds
      if x0(i)<=LB(i)
        % infeasible starting value
        x0u(k) = -pi/2;
      elseif x0(i)>=UB(i)
        % infeasible starting value
        x0u(k) = pi/2;
      else
        x0u(k) = 2*(x0(i) - LB(i))/(UB(i)-LB(i)) - 1;
        % shift by 2*pi to avoid problems at zero in fminsearch
        % otherwise, the initial simplex is vanishingly small
        x0u(k) = 2*pi+asin(max(-1,min(1,x0u(i))));
      end
      
      % increment k
      k=k+1;
    case 0
      % unconstrained variable. x0u(i) is set.
      x0u(k) = x0(i);
      
      % increment k
      k=k+1;
    case 4
      % fixed variable. drop it before fminsearch sees it.
      % k is not incremented for this variable.
  end
  
end
% if any of the unknowns were fixed, then we need to shorten
% x0u now.
if k<=n
  x0u(k:n) = [];
end

% were all the variables fixed?
if isempty(x0u)
  % All variables were fixed. quit immediately, setting the
  % appropriate parameters, then return.
  
  % undo the variable transformations into the original space
  x = xtransform(x0u,params);
  
  % final reshape
  x = reshape(x,xsize);
  
  % stuff chi0 with the final value
  chi0 = feval(params.fun,x,params.args{:});
  
  % fminsearchbnd was not called
  exitflag = 0;
  
  output.iterations = 0;
  output.funcount = 1;
  output.algorithm = 'fminsearch';
  output.message = 'All variables were held fixed by the applied bounds';
  
  % return with no call at all to fminsearch
  return
end

% now we can call fminsearch, but with our own
% intra-objective function.
[xu,chi0,exitflag,output] = fminsearch(@intrafun,x0u,options,params);

% undo the variable transformations into the original space
x = xtransform(xu,params);

% final reshape
x = reshape(x,xsize);

% ======================================
% ========= begin subfunctions =========
% ======================================
function chi0 = intrafun(x,params)
% transform variables, then call original function

% transform
xtrans = xtransform(x,params);

% and call fun
chi0 = feval(params.fun,xtrans,params.args{:});
end % end of the function INTRAFUN

% ======================================
function xtrans = xtransform(x,params)
% converts unconstrained variables into their original domains

xtrans = zeros(1,params.n);
% k allows soem variables to be fixed, thus dropped from the
% optimization.
k=1;
for i = 1:params.n
  switch params.BoundClass(i)
    case 1
      % lower bound only
      xtrans(i) = params.LB(i) + x(k).^2;
      
      k=k+1;
    case 2
      % upper bound only
      xtrans(i) = params.UB(i) - x(k).^2;
      
      k=k+1;
    case 3
      % lower and upper bounds
      xtrans(i) = (sin(x(k))+1)/2;
      xtrans(i) = xtrans(i)*(params.UB(i) - params.LB(i)) + params.LB(i);
      % just in case of any floating point problems
      xtrans(i) = max(params.LB(i),min(params.UB(i),xtrans(i)));
      
      k=k+1;
    case 4
      % fixed variable, bounds are equal, set it at either bound
      xtrans(i) = params.LB(i);
    case 0
      % unconstrained variable.
      xtrans(i) = x(k);
      
      k=k+1;
  end
end
end % end of the function XTRANSFORM

end % end of the function FMINSEARCHBND
%**************************************************************************
function [delta_p,delta_y] = uncertainties(parameters,r,jac,x,ybest)
%
% delta_p = uncertainties(parameters,r,jac)
%
% Compute the uncertainties DELTA_P on PARAMETERS from the residuals R and the
% jacobian JAC given by the function JACOB
r = r(:);
[m,n] = size(jac);
x = x(:);
ybest=ybest(:);

%calculate covariance
[Q R] = qr(jac,0);              % orthogonal-triangular decomposition of jac
Rinv = R\eye(size(R));          % compute R^-1
diag_info = sum((Rinv.*Rinv)')';
v = m-n;                        % number of degrees of liberty
rmse = sqrt(sum(r.*r)/v);
E = jac*Rinv;

% calculate confidence interval for the parameters
p_student_95=[8.34,-0.46,2.88,1.94];
t_student_95=polyval(p_student_95,1/v);
delta_p = sqrt(diag_info) .* rmse*t_student_95;
delta_p=delta_p';

% Calculate confidence interval
delta_y = sqrt(1 + sum(E.*E,2));
delta_y = delta_y .* rmse * t_student_95;
delta_y=delta_y(:);
end % end of the function UNCERTAINTIES
%*************************************************************
function [jac,r] = jacob(x,y,fhandle,parameters)
% 
% [jac,r] = jacob(x,y,fhandle,parameters)
%
% Compute the jacobian JAC = dY/dPARAMATERS of FHANDLE at the points X
% Compute the residuals R = Y - FHANDLE(PARAMETERS, X)
yfit = fhandle(parameters,x);
n = length(y);
p = length(parameters);
jac = zeros(n,p);
r = y(:) - yfit(:);
delta_p = 1e-6;
zp = zeros(size(parameters));
zerosp = zeros(p,1);
    for k = 1:p
        delta = zp;
        if (parameters(k) == 0)
            nb = sqrt(norm(parameters));
            delta(k) = delta_p * (nb + (nb==0));
        else
            delta(k) = delta_p*parameters(k);
        end
        yplus = fhandle(parameters+delta,x);
        dy = yplus(:) - yfit(:);
        jac(:,k) = dy/delta(k);
    end
end % end of the function JACOB
%*************************************************************