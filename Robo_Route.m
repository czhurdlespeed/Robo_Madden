% Project: EF230 Spring 2022 Group Project D3
% Names: Calvin Wetzel, Harlee Petretta, Dusty Waters, Mindy Le
% Created: 04/07/2022
% Class: EF230 Spring 2022
% Group D3
% Problem Description: Develop functions that command a sphero robot to
%                      complete a task.
% Solution Method: Bring Madden Football to Robots ;-)
function Robo_Route(s,Turn_Angles,Distance_yrds,Sound)
% Purpose: Robo_Route takes the outputs of Robo_Madden and gives commands
...to the robot so the robot replicates the route ran in Robo_Madden
% Inputs: s=Robot/Object, Turn_Angles=Output Angle Vectors of Robo_Madden
...Distance_yrds=Output Distance Scalars of Robo_Madden, Sound=Sound position data
% Outputs: None
% Usage: Robo_Route(s,Turn_Angles,Distance_yrds, Sound)
% Note: Robo_Route must be called after Robo_Madden because it takes the
...outputs of Robo_Maden 
waitfor(msgbox('Please enter your desired speed (m/s) as a number (50=<Speed<=200)'))
speed=inputdlg('How fast do you want to run the route?','Robot Speed',[1 100])
speed=str2double(speed)
myspeed=speed/100
    if str2double(myspeed)>2 % if speed is too high
        disp('Your speed is greater than 20. Please enter a speed less than 20.')
        return
    elseif str2double(myspeed)<.50 % if speed is too low
        disp('Your speed is too slow. Please enter a speed greater than 1.')
        return
    elseif isnumeric(myspeed)~=1 % if speed is not a number
        disp('You did not enter a number. Please enter a number.')
        return
    end
Distance_meters=Distance_yrds.*0.9144 % conversion from yards to meters
time_travel=Distance_meters./myspeed
for i=1:length(time_travel) % for the length of the Turn_Angles
    setDriveSpeed(s,speed) % set the drive speed of the robot
    pause(time_travel(i))
    stop(s) % stop robot's movement at end of the i distance vector
    pause(0.5) % pause for 0.5 seconds
    if i<=length(Turn_Angles) % if i is less than or equal to the 
        ...length of Turn_Angles. I did this because the length of Distance vectors
            ...is 1 greater than the length of turn_angles
       turnAngle(s,-1*Turn_Angles(i)) % turn robot to face in the direction
       ...of the (i+1) distance vector
       pause(2)
    else 
       if Sound(1)>Sound(2) && Sound(3)=<128
          [y, Fs] = audioread('Wrong Clakson Sound Effect.mp3');
          sound(y,Fs)                  
       elseif Sound(1)<Sound(2) && Sound(3)>=1076                     
          [y, Fs] = audioread('Wrong Clakson Sound Effect.mp3');
          sound(y,Fs)                   
       elseif Sound(1)>Sound(2) && Sound(3)>=1076                   
          [y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
          sound(y,Fs)                  
       elseif Sound(1)<Sound(2) && Sound(3)=<128   
          [y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
          sound(y,Fs)                  
       end % end of safety or touchdown music conditional 
       waitfor(msgbox('You have completed your route!'))      
   end % end of turn angle length conditional    
end % end of for loop
end % end of Robo_Route function
  