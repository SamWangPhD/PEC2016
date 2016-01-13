%%%%%%%%%%%%%%%%%%%%%%
%
% By Sam Wang, January 2016.
% GNU license: Distribute freely but retain this header
% Princeton Election Consortium - election.princeton.edu
%
% This master program calls primaries.m, primary_districts.m, and
% primary_states.m.
% 
% To put in real data, replace primaries.m and primary_districts.m
% with something more reasoned. Also, seed candidatemeans below.
%
%
%%%%%%%%%%%%%%%%%%%%%%

thresholds = [0 10 0 3.33 13 20 15 20 5 10 15 20 20 20 0 0];
regions = [1 1 7 1 1 7 4 14 1 8 5 1 36 1 1 12];
statedels=[27 20 29 30 25 26 25 34 39 14 25 28 47 16 46 14];

states='IA NH SC NV AK AL AR GA MA MN OK TN TX VT VA WY ';
numstates=round(length(states)/3);

%
% data structure is statewide(state,candidate)
% notation: (i,j) is i-th state, j-th candidate
%

candidatemeans = [37 18 12 6]; % 10-Jan for Trump/Cruz/Rubio/Bush

trump=[15:2.5:60];
maxreps=300;

clear statetot disttot trumpall

for t=1:length(trump)
    trump(t)
    candidatemeans(1)=trump(t);
    disttot(t,:)=zeros(1,length(candidatemeans)); 
    statetot(t,:)=zeros(1,length(candidatemeans));
    
    for reps=1:maxreps
        delegate_state = [0 0 0 0];            % statewide delegates
        primary_states

        delegate_district = [0 0 0 0];         % by Congressional or other district
        delegate_district = delegate_district + primary_districts(statewide(3,:),regions(3),10,0,'WT'); % SC
        delegate_district = delegate_district + primary_districts(statewide(6,:),regions(6),10,0,'AL'); % AL
        delegate_district = delegate_district + primary_districts(statewide(7,:),regions(7),10,0,'mj'); % AR
        delegate_district = delegate_district + primary_districts(statewide(8,:),regions(8),10,0,'mj'); % GA
        delegate_district = delegate_district + primary_districts(statewide(10,:),regions(10),10,0,'MN'); % MN
        delegate_district = delegate_district + primary_districts(statewide(11,:),regions(11),10,0,'OK'); % OK
        delegate_district = delegate_district + primary_districts(statewide(12,:),regions(12),10,0,'TN'); % TN
        delegate_district = delegate_district + primary_districts(statewide(13,:),regions(13),10,0,'TX'); % TX

        statetot(t,:)=statetot(t,:)+delegate_state;
        disttot(t,:)=disttot(t,:)+delegate_district;
    end
    statetot(t,:)=statetot(t,:)/maxreps;
    disttot(t,:)=disttot(t,:)/maxreps;

end

trumpall=(statetot(:,1)+disttot(:,1))/754*100;
cruzall=(statetot(:,2)+disttot(:,2))/754*100;
rubioall=(statetot(:,3)+disttot(:,3))/754*100;
plot(trump,trumpall,'-ok')
plot(trump,cruzall,'-or')
plot(trump,cruzall,'-og')
% plot(trump./(trump+sum(candidatemeans(2:4)))*100,trumpall,'-og')
grid
axis([0 60 0 100])
xlabel('Current level of support (%)')
ylabel('Fraction of delegates by Super Tuesday (%)')
hold on
