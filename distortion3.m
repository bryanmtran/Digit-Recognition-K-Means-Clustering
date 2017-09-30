function distances = distortion3(a,b)
% distances = distortion3(Data, CodeWords)
% Compute the pairwise Euclidean distortions between a 
% set of D column vectors (Data), and a set of C codewords
% (C column vectors of the same length).  
%
% distances(c,d) represents the Euclidean distortion
% between the c'th codeword and the d'th data vector.
%
%
%    This fully vectorized (VERY FAST!) m-file computes the 
%    Euclidean distortion between two vectors by:
%
%                 ||A-B||^2 = ( ||A||^2 + ||B||^2 - 2*A.B )
%
% Example : 
%    A = rand(400,100); B = rand(400,200);
%    d = distortion(A,B);
%
% Author   : Roland Bunschoten
%            University of Amsterdam
%            Intelligent Autonomous Systems (IAS) group
%            Kruislaan 403  1098 SJ Amsterdam
%            tel.(+31)20-5257524
%            bunschot@wins.uva.nl
% Last Rev : Oct 29 16:35:48 MET DST 1999
% Tested   : PC Matlab v5.2 and Solaris Matlab v5.3
% Thanx    : Nikos Vlassis
%
% Copyright notice: You are free to modify, extend and distribute 
%    this code granted that the author of the original code is 
%    mentioned as the original author of the code.
%
% Contains minor modifications of original code

if (nargin ~= 2)
   error('Not enough input arguments');
end

if (size(a,1) ~= size(b,1))
   error('A and B should be of same dimensionality');
end

aa=sum(a.*a,1)'; 
bb=sum(b.*b,1); 
ab=a'*b; 

% abs accounts for rounding errors
distances = ...
    abs(aa(:, ones(size(bb, 2), 1)) + bb(ones(size(aa,1),1), :)- 2*ab)';
