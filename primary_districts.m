function y=primary_districts(statewide,N,SD,thresh,rule)

%%%%%%%%%%%%%%%%%%%%%%
%
% By Sam Wang, January 2016.
% GNU license: Distribute freely but retain this header
% Princeton Election Consortium - election.princeton.edu
%
% - assign delegates according to descriptions from TheGreenPapers.com:
% http://www.thegreenpapers.com/P16/ccad.phtml
%
% This version of the code does not implement rounding rules.
%
% rule parameter has to be three characters
% WT winner-take-all - SC
% mj majority gets all; if no majority, next person gets 1. AR, GA
%
%%%%%%%%%%%%%%%%%%%%%%

C=length(statewide); % number of candidates

for ii=1:N
    district(ii,:)=normrnd(statewide,SD);
    district(ii,:)=max(district(ii,:),zeros(1,length(statewide)));
    district(ii,:)=min(district(ii,:),100+zeros(1,length(statewide)));
    district(ii,:)=district(ii,:)/sum(district(ii,:))*100;
end % we have a random set of outcomes

foo=zeros(1,C); % this initializes the number of delegates, by candidate

for ii=1:N
    [pcts,irank]=sort(district(ii,:),'descend');
    if rule=='WT'
        foo(irank(1))=foo(irank(1))+3;
    end
    if rule=='mj'
        foo(irank(1))=foo(irank(1))+2;
        if pcts(1)>50
            foo(irank(1))=foo(irank(1))+1;
        else
            foo(irank(2))=foo(irank(2))+1;
        end
    end
    if rule=='AL'
        iabove=length(find(district(ii,:)>thresh));
        if or(iabove==1,pcts(1)>50)
            foo(irank(1))=foo(irank(1))+3;
        else
            if iabove>1
                foo(irank(1))=foo(irank(1))+2;
                foo(irank(2))=foo(irank(2))+1;
            else % nobody is above threshold
                foo(irank(1))=foo(irank(1))+1; % this part not perfect - fix later
                foo(irank(2))=foo(irank(2))+1; % this part not perfect - fix later
                foo(irank(3))=foo(irank(3))+1; % this part not perfect - fix later
            end
        end
    end
    if rule=='MN'
        iabove=length(find(district(ii,:)>thresh));
        if iabove==0
            foo(irank(1))=foo(irank(1))+1; % this part not perfect - fix later
            foo(irank(2))=foo(irank(2))+1; % this part not perfect - fix later
            foo(irank(3))=foo(irank(3))+1; % this part not perfect - fix later
        else
            district(ii,:)=district(ii,:)/sum(district(ii,iabove))*100; % renormalize
            if pcts(1)>83
                foo(irank(1))=foo(irank(1))+3;
            else
                if pcts(1)>50 % the top finisher is 50-83%
                    foo(irank(1))=foo(irank(1))+2;
                    foo(irank(2))=foo(irank(2))+1;
                else % what if the top finisher is <=50%
                    foo(irank(1))=foo(irank(1))+1; % this part not perfect - fix later
                    foo(irank(2))=foo(irank(2))+1; % this part not perfect - fix later
                    foo(irank(3))=foo(irank(3))+1; % this part not perfect - fix later
                end
            end
        end
    end
    if rule=='OK'
        iabove=length(find(district(ii,:)>thresh));
        if or(iabove==1,pcts(1)>50)
            foo(irank(1))=foo(irank(1))+3;
        else
            if iabove==2    
                foo(irank(1))=foo(irank(1))+2;
                foo(irank(2))=foo(irank(2))+1;
            else
                foo(irank(1))=foo(irank(1))+1;
            	foo(irank(2))=foo(irank(2))+1;
            	foo(irank(3))=foo(irank(3))+1;
            end
        end
    end
    if rule=='TN'
        iabove=length(find(district(ii,:)>thresh));
        if or(iabove==1,pcts(1)>66.7)
            foo(irank(1))=foo(irank(1))+3;
        else
            if iabove==2
                foo(irank(1))=foo(irank(1))+2;
                foo(irank(2))=foo(irank(2))+1;
            else
                foo(irank(1))=foo(irank(1))+1;
            	foo(irank(2))=foo(irank(2))+1;
            	foo(irank(3))=foo(irank(3))+1;
            end
        end
    end
    if rule=='TX'
        iabove=length(find(district(ii,:)>thresh));
        if pcts(1)>50
            foo(irank(1))=foo(irank(1))+3;
        else
            if iabove>=1
                foo(irank(1))=foo(irank(1))+2;
                foo(irank(2))=foo(irank(2))+1;
            else
                foo(irank(1))=foo(irank(1))+1;
            	foo(irank(2))=foo(irank(2))+1;
            	foo(irank(3))=foo(irank(3))+1;
            end
        end
    end
end % now we have run all Congressional districts
y=foo;
end
