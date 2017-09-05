%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1). 
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the 
%   network where M(i) represents the ith variable and M(i).val represents 
%   the marginals of the ith variable. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
result = [];
P = CreateCliqueTree(F, E)
if (isMax)
	P = CliqueTreeCalibrate(P,1)
else
	P = CliqueTreeCalibrate(P, 0)
end
N = length(P.cliqueList)
for i = 1:N
	v = P.cliqueList(i).var
	for j = 1:length(v)
		if(isMax)
			result = [result FactorMaxMarginalization(P.cliqueList(i), v(j))]
		else
			result = [result ComputeMarginal(v(j),P.cliqueList(i),[])]
		end
	end
end

maximum = max([result.var])
M = repmat(struct('var',[],'card',[],'val',[]),maximum,1)
for i = 1:maximum
	idx = find([result.var]==i)
	M(i) = result(idx(1))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
