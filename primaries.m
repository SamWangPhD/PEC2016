function [x] = primaries(pmean,N_primary_states)

%%%%%%%%%%%%%%%%%%%%%%
%
% By Sam Wang, January 2016.
% GNU license: Distribute freely but retain this header
% Princeton Election Consortium - election.princeton.edu
%
% This function generates a bunch of random primary-election results for
% one candidate, based on 2012 data for Romney, Paul, Gingrich, and 
% Santorum.
%
% In 2012, candidates averaging at least 15% by Super Tuesday had an SD of
% 12.0-13.5%, with some right-skew.
%
% From this, a candidate's state-by-state percentage can be simulated as
% P=p0+p, where p0 is their average support and empirically from 2012 data, log(p+35) is normally distributed with SD=0.36.
% That is: p+35=exp(normx) where normx has mean=3.4929 and SD=0.3608.
% In other words, P=p0+32.88*exp(normx)-35
% or P=p0+exp(normrnd(3.4929,0.3608))-35
% (then obviously put a floor and ceiling on it of 0 and 100)
%
%%%%%%%%%%%%%%%%%%%%%%

for i_state=1:N_primary_states
    foo=pmean+exp(normrnd(3.4929,0.3608))-35;
    foo=min(foo,100);
    foo=max(foo,0);
    x(:,i_state)=foo;
end
