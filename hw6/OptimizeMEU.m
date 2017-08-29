% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  EUF = CalculateExpectedUtilityFactor(I) 
  decision = D.var(1)

  if (length(I.DecisionFactors.var) == 1) 
    [MEU,index] = max(EUF.val) 
    OptimalDecisionRule = D
    OptimalDecisionRule.val = zeros(1,D.card(1))
    OptimalDecisionRule.val(index) = 1
  else
    MEU = 0
    OptimalDecisionRule = D
    OptimalDecisionRule.val = zeros(1,prod(EUF.card))
    %for i = 1:prod(EUF.card(1:end-1))
    %  a = EUF.val(i:prod(EUF.card(1:end-1)):end)
    %  [M,I]= max(EUF.val(i:prod(EUF.card(1:end-1)):end))
    %  MEU += M
    %  index = (I-1)*prod(EUF.card(1:end-1)) + i
    %  OptimalDecisionRule.val(index) = 1 
    %end 
    for i = 1:prod(EUF.card(2:end))
      offset = (i-1) * EUF.card(1) 
      [M,I]= max(EUF.val(1+offset:EUF.card(1)+offset))
      MEU += M
      OptimalDecisionRule.val(I+offset) = 1 
    end
  end
  


end
