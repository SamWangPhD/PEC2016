%%%%%%%%%%%%%%%%%%%%%%
%
% By Sam Wang, January 2016.
% GNU license: Distribute freely but retain this header
% Princeton Election Consortium - election.princeton.edu
%
% - generate percentages for primary states
% - do it for the candidates in candidatemeans
% - assign delegates according to descriptions from TheGreenPapers.com:
% http://www.thegreenpapers.com/P16/ccad.phtml
%
% This version of the code does not implement rounding rules.
%
% Statewide quantities of interest:
%    Percentage for each candidate (renormalize after IA/NH)
%    #1 ranked finisher, and whether that person gets >50%
%    which candidates are above threshold (threshold varies by state)
%    number of districts
%
% By district or other region:
%    Percentage for each candidate (renormalize after IA/NH)
%    #1 finisher, and whether that person gets >50%
%    number of candidates above threshold
%
%
%%%%%%%%%%%%%%%%%%%%%%

for j=1:length(candidatemeans)
    statewide(:,j)=primaries(candidatemeans(j),numstates);
end

for i=1:2
    statewide(i,:)=statewide(i,:)/max(sum(statewide(i,:)),100)*100;
end

for i=3:(size(statewide,1))
    statewide(i,:)=statewide(i,:)/sum(statewide(i,:))*100;
end

[maxpct,leader]=max(statewide,[],2); % find leader in each state and his percentage
majoritywins=find(maxpct>50); % find states where leader won more than 50%

% delegate_state(irank(1))=delegate_state(irank(1))+statedels(i);

for i=1:(size(statewide,1))
%    states(3*i-2:3*i-1)
    [pcts,irank]=sort(statewide(i,:),'descend');
    foo = zeros(1,length(candidatemeans));
    switch i % specialized rules for each state
        case 1 % Iowa
            foo=round(statewide(i,:)*statedels(i)/100);
        case 2 % New Hampshire
            above=find(statewide(i,:)>10);
            foo(above)=round(statewide(i,above)*statedels(i)/100);
            if sum(foo)<statedels(i)
                foo(irank(1))=foo(irank(1))+statedels(i)-sum(foo);
            end
        case 3 % South Carolina
            foo(irank(1))=statedels(i);
        case 4 % Nevada
            above=find(statewide(i,:)>3.33);
            abovepct=sum(statewide(i,above));
            foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
        case 5 % Alaska
            above=find(statewide(i,:)>13);
            abovepct=sum(statewide(i,above));
            foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            if sum(foo)>statedels(i)
                foo(irank(1))=foo(irank(1))-sum(foo)+statedels(i); % actual rule
            end
            if sum(foo)<statedels(i)
                foo(irank(1))=foo(irank(1))+sum(foo)-statedels(i); % actual rule
            end
        case 6 % Alabama
            if maxpct(i)>50
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>20);
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 7 % Arkansas
            above=find(statewide(i,:)>15);
            foo(above)=1;
            if maxpct(i)>50
                foo(irank(1))=foo(irank(1))+statedels(i)-1;
            else
                abovepct=sum(statewide(i,above));
                foo(above)=foo(above)+round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 8 % Georgia
            if maxpct(i)>50
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>20);
                if length(above)==0
                    above=find(statewide(i,:)>15);
                end
                if length(above)==0
                    above=find(statewide(i,:)>10);
                end
                if length(above)==0
                    above=[1:length(candidatemeans)];
                end
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 9 % Massachusetts
            above=find(statewide(i,:)>5);
            if isempty(above)
                above=[1:length(candidatemeans)];
            end
            ilast = irank(length(above));
            abovepct=sum(statewide(i,above));
            foo(above)=foo(above)+round(statewide(i,above)*statedels(i)/abovepct);
            while sum(foo)~=statedels(i)
                if sum(foo)>statedels(i)
                    foo(ilast)=foo(ilast)-1;
                end
                if sum(foo)<statedels(i)
                    foo(irank(1))=foo(irank(1))+1;
                end
            end
        case 10 % Minnesota
            if maxpct(i)>85
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>10);
                if isempty(above)
                    above=1:length(candidatemeans);
                end
                abovepct=sum(statewide(i,above));
                j=1;
                while and(sum(foo)<statedels(i),j<=length(above))
                    foo(irank(j))=round(statewide(i,irank(j))*statedels(i)/abovepct);
                    j=j+1;
                end
                while sum(foo)>statedels(i)
                    foo(irank(j-1))=foo(irank(j-1))-1;
                end
            end
        case 11 % Oklahoma
            if maxpct(i)>50
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>15);
                if isempty(above)
                    above=1:length(candidatemeans);
                end
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 12 % Tennessee
            if maxpct(i)>66.7
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>20);
                if isempty(above)
                    above=1:length(candidatemeans);
                end
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 13 % Texas
            if maxpct(i)>50
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>20);
                if isempty(above)
                    above=1:length(candidatemeans);
                end
                if length(above)==1
                    above=irank(1:2);
                end
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
            end
        case 14 % Vermont
            if maxpct(i)>50
                foo(irank(1))=statedels(i);
            else
                above=find(statewide(i,:)>20);
                if length(above)==0
                    above=find(statewide(i,:)>15);
                end
                if length(above)==0
                    above=find(statewide(i,:)>10);
                end
                if length(above)==0
                    above=1:length(candidatemeans);
                end
                abovepct=sum(statewide(i,above));
                foo(above)=round(statewide(i,above)*statedels(i)/abovepct);
                while sum(foo)-statedels(i)~=0
                    ilast = irank(length(above));
                    if sum(foo)>statedels(i)
                        if foo(ilast)>0
                            foo(ilast)=foo(ilast)-1;
                        else
                            foo(irank(1))=foo(irank(1))-1;
                        end
                    end
                    if sum(foo)<statedels(i)
                        foo(irank(1))=foo(irank(1))+1;
                    end
                end
            end
        case 15 % Virginia
            foo=round(statewide(i,:)*statedels(i)/100);
        otherwise
    end
    
    % now a kludge to make sure the total number is correct
	while sum(foo)>statedels(i)
        foo(irank(1))=foo(irank(1))-1;
    end
	while sum(foo)<statedels(i)
        foo(irank(1))=foo(irank(1))+1;
    end
    % this is in place of implementing the actual rounding rules
        delegate_state=delegate_state+foo;
end
% [delegate_state round(delegate_state/sum(delegate_state)*100)]
