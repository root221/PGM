% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  D = I.DecisionFactors(1);
  U = I.UtilityFactors
  I.UtilityFactors = U(1)
  EUF = CalculateExpectedUtilityFactor(I)
  for i = 2:length(U)
    I.UtilityFactors = U(i)
    EUF = FactorSum(EUF,CalculateExpectedUtilityFactor(I))  
  end
  if (length(I.DecisionFactors.var) == 1) 
    [MEU,index] = max(EUF.val) 
    OptimalDecisionRule = D
    OptimalDecisionRule.val = zeros(1,D.card(1))
    OptimalDecisionRule.val(index) = 1
  else
    MEU = 0
    OptimalDecisionRule = D
    OptimalDecisionRule.val = zeros(1,prod(EUF.card))
  
    for i = 1:prod(EUF.card(2:end))
      offset = (i-1) * EUF.card(1) 
      [M,I]= max(EUF.val(1+offset:EUF.card(1)+offset))
      MEU += M
      OptimalDecisionRule.val(I+offset) = 1 
    end
  end
end
