%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree. 
%   
%   It returns the standard form of a clique tree P that we will use through 
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors 
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree. 
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [P,assignment] = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials 
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques. 
% Then use that assignment to initialize the cliques in cliqueList to 
% their initial potentials. 

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
P.edges = C.edges

for i = 1:N
    P.cliqueList(i).var = C.nodes{i};
    P.cliqueList(i).card = zeros(1,length(P.cliqueList(i).var))
end


assignment = zeros(1,length(C.factorList))
for j = 1:N
    for i = 1:length(C.factorList)
        % check whether C.factorList(i).var is a subset of P.cliqueList.var(j)
        [TF,S_IDX] = ismember(C.factorList(i).var,P.cliqueList(j).var) 
        for k = 1:length(S_IDX)
            if(TF(k))
                P.cliqueList(j).card(S_IDX(k)) = C.factorList(i).card(k)
            end
        end
        if(all(TF))
            assignment(i) = j
        end
        if(length(find(P.cliqueList(j).card)) == length(P.cliqueList(j).card))
            break
        end
    end
end

for i = 1:N
    P.cliqueList(i).val = ones(1,prod(P.cliqueList(i).card))
end

for i = 1:length(assignment)
     P.cliqueList(assignment(i)) = FactorProduct(P.cliqueList(assignment(i)),C.factorList(i))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

