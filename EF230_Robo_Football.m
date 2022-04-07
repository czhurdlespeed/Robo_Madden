% Project: EF230 Spring 2022 Group Project D3
% Names: Calvin Wetzel, Harlee Petretta, Dusty Waters, Mindy Le
% Created: 4/07/2022
% Class: EF230 Spring 2022
% Group D3
% Problem Description: Develop functions that command a sphero robot to
%                      complete a task.
% Solution Method: Bring Madden Football to Robots ;-)
function EF230_Robo_Football()
% Purpose: Combine Robo_Madden and Robo_Route into one function 
% Inputs: None
% Outputs: None
% Usage: EF230_Robo_Football()
% Note: Calling EF230_Robo_Football() will first run Robo_Madden which will
% output the inputs to Robo_Route, which commands the RVR
[Turn_Angles,Distance_yrds,VectorMatrix,Sound]=Robo_Madden() % Runs Robo_Madden Function
Robo_Route(s,Turn_Angles,Distance_yrds,Sound) % Runs Robo_Route Function
...using the outputs from Robo_Madden
end % end of EF230_Robo_Football function