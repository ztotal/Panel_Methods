function [Mx,My] = STREAMLINE_SPM(XP,YP,XB,YB,phi,S)

% Written by: JoshTheEngineer
% YouTube   : www.youtube.com/joshtheengineer
% Website   : www.joshtheengineer.com
%
% PURPOSE
% - Compute the geometric integral at point P due to source panels
% - Source panel strengths are constant, but can change from panel to panel
% - Geometric integral for X-direction: Mx(ij)
% - Geometric integral for Y-direction: My(ij)
% 
% REFERENCE
% - [1]: Streamline Geometric Integral SPM, Mx(ij) and My(ij)
%           Link: https://www.youtube.com/watch?v=BnPZjGCatcg
% INPUTS
% - XP     : X-coordinate of computation point, P
% - YP     : Y-coordinate of computation point, P
% - XB     : X-coordinate of boundary points
% - YB     : Y-coordinate of boundary points
% - phi    : Angle between positive X-axis and interior of panel
% - S      : Length of panel
% 
% OUTPUTS
% - Mx     : Value of X-direction geometric integral (Ref [1])
% - My     : Value of Y-direction geometric integral (Ref [1])

% Number of panels
numPan = length(XB)-1;                                                      % Number of panels/control points

% Initialize arrays
Mx = zeros(numPan,1);                                                       % Initialize Mx integral array
My = zeros(numPan,1);                                                       % Initialize My integral array

% Compute Mx and My
for j = 1:1:numPan                                                          % Loop over the j panels
    % Compute intermediate values
    A  = -(XP-XB(j))*cos(phi(j))-(YP-YB(j))*sin(phi(j));                    % A term
    B  = (XP-XB(j))^2+(YP-YB(j))^2;                                         % B term
    Cx = -cos(phi(j));                                                      % C term (X-direction)
    Dx = XP - XB(j);                                                        % D term (X-direction)
    Cy = -sin(phi(j));                                                      % C term (Y-direction)
    Dy = YP - YB(j);                                                        % D term (Y-direction)
    E  = sqrt(B-A^2);                                                       % E term
    if (isnan(E) || ~isreal(E))                                             % If E is a NaN or not real
        E = 0;                                                              % Set E equal to zero
    end
    
    % Compute Mx, Ref [1]
    term1 = 0.5*Cx*log((S(j)^2+2*A*S(j)+B)/B);                              % First term in Mx equation
    term2 = ((Dx-A*Cx)/E)*(atan2((S(j)+A),E) - atan2(A,E));                 % Second term in Mx equation
    Mx(j) = term1 + term2;                                                  % X-direction geometric integral
    
    % Compute My, Ref [1]
    term1 = 0.5*Cy*log((S(j)^2+2*A*S(j)+B)/B);                              % First term in My equation
    term2 = ((Dy-A*Cy)/E)*(atan2((S(j)+A),E) - atan2(A,E));                 % Second term in My equation
    My(j) = term1 + term2;                                                  % Y-direction geometric integral
end
