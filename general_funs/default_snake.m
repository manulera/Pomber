function [ Options ] = default_snake( )
Options=struct;
Options.Verbose=true;
Options.Iterations=100;
Options.nPoints = 200;
% Useless
Options.Wedge=0;
Options.Wline=0;
Options.Wterm=0;
Options.Sigma1=1;
%
% For the isolated hard cell
Options.Kappa=10;
Options.Sigma2=1;
Options.Alpha=0.3;
Options.Beta=0.3; 
Options.Mu=0.04;
Options.Delta=0.06;
% For cells with fuzzy ends
Options.Kappa=2;
Options.Sigma2=1;
Options.Alpha=0.01;
Options.Beta=0.01; 
Options.Mu=0.05;
Options.Delta=0.03;
% For cells in the middle

%
Options.GIterations=600;

end

