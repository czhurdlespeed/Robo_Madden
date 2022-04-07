% Project: EF230 Spring 2022 Group Project D3
% Names: Calvin Wetzel, Harlee Petretta, Dusty Waters, Mindy Le
% Created: 04/07/2022
% Class: EF230 Spring 2022
% Group D3

% Problem Description: Develop functions that command a sphero robot to
%                      complete a task.
% Solution Method: Bring Madden Football to Robots ;-)

function [Turn_Angles,Distance_yrds,VectorMatrix,Sound] = Robo_Madden()
% Purpose: Run Robo_Madden to graphically run route and get Turn_Angles, 
%          distance_yrds, and the Vector_Matrix for the robot
% Inputs: None
% Output: Turn_Angles (degrees), Distances_yrds (yards), VectorMatrix
%         (position units), Sound (position data for music in Robo_Route)
% Usage: [Turn_Angles, Distance_yrds, VectorMatrix, Sound] = Robo_Madden()
% Note: This function allows you to graphically/digitally run a route. The
%       information is then translated into Angles and Distances which the
%       robot function can use to command the robot to replicate route.
close all
clear all
clc
 while true % opens an indefinite while loop
    close all % clears any graphic/plots
    waitfor(msgbox(['Input distance as yards from left goal line the Down Number as an integer'])); % instructions for use of input dialog box
    Starting_Matrix=(inputdlg({'Line of Scrimmage','1st Down Location','Down Number'}, ...
        'Starting Values',[1 100; 1 100; 1 25],{'25'; '35'; '1'})); % inputs for start point on the field and the preferred down number
            Line_of_Scrimmage=str2double(Starting_Matrix(1)); 
            First_Down_Marker=str2double(Starting_Matrix(2));
            Down_Number=str2double(Starting_Matrix(3));
    if Line_of_Scrimmage>=0 && Line_of_Scrimmage<=100 && First_Down_Marker<=110 && First_Down_Marker>=-10 && Down_Number>0 && Down_Number<=4 % if the inputted dialog commands are in the field of play and the down number selected is valid
        imshow('Football Field.png') % load the football field imgae
        football_image=imread('Football Field.png'); % read the football field image
        [rows,columns]=size(football_image); % share size of football field as rows and columns
        hold on 
        fdmxlocation=((First_Down_Marker+10)/(120/1138))+32; %pixel location of firstdown marker
        if fdmxlocation>1076 || fdmxlocation<128
            set(xline(fdmxlocation,'y','LineWidth',3),'Visible','off')
        else
            xline(fdmxlocation,'y','LineWidth',3)
        end
        hold on
        lineofscrimmage=((Line_of_Scrimmage+10)/(120/1138))+32; %pixel location of line of scrimmage
        xline(lineofscrimmage, 'blue','LineWidth',3)
        hold on
        if lineofscrimmage>980 || lineofscrimmage<223 && (fdmxlocation>980 || fdmxlocation<223) % if first down marker is past the goalline or line of scrimmage is inside the goal line
            deltalinescrimfirstdownntext=sprintf('%s down & Goal',num2str(Down_Number));
            deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
            text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
            thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
        else % normal down and distance                                  
           deltalinescrimfirstdownpixels=abs(fdmxlocation-lineofscrimmage);
           deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
           deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
           deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
           text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
           thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
        end % end of goal line conditional
        % Ask User if they want to run a play
        list={'Yes','No'};
        [indx,tf]=(listdlg('PromptString',{'Do you want to run a play?'},'SelectionMode','single','ListString',list));
        if indx==1 && tf==1 % if the answer is yes
            %run play 
            waitfor(msgbox('Click along the path you run; when finished, press enter','Instructions for Path Selection')) % instructions for how to run the route         
            [x,y]=ginput(); % allows user to click on football field to run route and records the click locations as x & y values
             x=[lineofscrimmage
                x]; 
            y=[y(1)
                 y]; % matrices of x and y values  
            hold on  
            for i=1:length(x) 
                      if 32<=x(i) && x(i)<=1170 && 34<=y(i) && y(i)<=547 % if clicked points are inbounds
                        plot(x,y,'r-','LineWidth',3) % route in red
                        hold on
                        plot(x(end),y(end),'yo','Markersize',6,'MarkerFaceColor','yellow') % plot solid circle where the play ends
                        ypostionyards=(513-(y-34)).*((160/3)/513);% y position in yards relative to bottom end line
                        ypostionyards=round(ypostionyards,0);     
                      end % end of click points condidtional 
            end % end of for loop
            %Distance traveled
             % First turn points into coordinates
              A=[];
              for i=1:length(x)
                   A=[A;
                   x(i), y(i)]; % turns ginput points into matrix of coordinates
              end % end of for loop
             % Use Sum of Norms between points (Sum of Vectors) to find pixel disstance
              Distance=[];
              Vector_Yards=[];
              for i=1:(length(x)-1)
                   length_btw_points=norm(A(i+1,:)-A(i,:)); % calculated the length between the points 
                   length_btw_points_yards=length_btw_points.*(120/1138); % converts to yards
                   Distance=[Distance,length_btw_points]; % distance matrix in pixels
                   Vector_Yards=[Vector_Yards,length_btw_points_yards]; % distance matrix in yard                           
              end % end of for loop
              Distance_yrds=Vector_Yards; % FIRST OUTPUT OF FUNCTION: the individual vector distances 
              TotalDistance_pixels=sum(Distance); % total distance traveled in pixels
              TotalDistance_yards=sum(Vector_Yards); % same as above but in yards
              TotalDistance_yards=round(TotalDistance_yards); % round total distance in yards
              % Find the angle between vectors
                Vectors=[];                               
                for i=1:(length(x)-1)
                    myvectors=A(i+1,:)-A(i,:); % finds the vectors created between the clicked points
                    Vectors=[Vectors,
                    myvectors];                                     
                end % end of for loop
                VectorMatrix=Vectors.*(120/1138); % SECOND OUTPUT OF FUNCTION: the yard vectors vectors; helps user understand what the direction of travel should be; up is negative; right is positive   
                Direction=[];
                Angles=[];
                Angles2=[];
                for i=1:length(Vectors)-1
                    mytheta=round(acosd(dot(Vectors(i+1,:),Vectors(i,:))/(norm(Vectors(i+1,:))*norm(Vectors(i,:)))),0); % calculates the dot product between the vectors;...
                    ...however all anlges are positive, which doesn't help delineate between a left and right turn 
                    mytheta2=round(atan2d(Vectors(i+1,2).*Vectors(i,1)-Vectors(i+1,1).*Vectors(i,2),Vectors(i+1,1)*Vectors(i,1)+Vectors(i+1,2)*Vectors(i,2)),0); % atan2d assigns a negative theta value for left turns 
                    ...and a positive theta value for right turns
                    Angles2=[Angles2,mytheta2]; % theta matrix
                    Angles=[Angles,mytheta]; % theta matrix
                end
                Turn_Angles=Angles2; % THIRD OUTPUT OF FUNCTION: angles between vectors in degrees (turn angles of robot), sign denotes left or right hand turns
                Sound=[fdmxlocation,lineofscrimmage,x(end)]; % FOURTH OUTPUT OF FUNCTION; USED FOR SOUND DATA IN ROBO_ROUTE
       else
          waitfor(msgbox("I'm sorry to hear that. We won't run a play"))
          close all
          return
      
       end % end of yes you want to run a play conditional
else % if values put in input dialog box are not valid
    waitfor(msgbox("Your inputted values are not inside the field of play or your down number was invalid"));
    close all
    break % exits while loop       
end % end of input dialog box conditional 
                 if Down_Number==3
                      pause(15)
                      thingSpeakWrite(1696058,'Fields',[4],'Values',"It's Thirrrrrrrrrrrrddddd Down!",'WriteKey','RP1GXVY55GGZU1PN')
                 end
                 if fdmxlocation<x(end) && fdmxlocation>x(1) && x(end)<1076 % moving to right & get first down, send tweet
                    pause(15) 
                    thingSpeakWrite(1696058,'Fields',[4],'Values',{'First Down Tennessee!'},'WriteKey','RP1GXVY55GGZU1PN')
                 end % end of 1st down tweet conditional 
                 if fdmxlocation<x(1) && fdmxlocation>x(end) && x(end)>128 % moving to the left & get first down, send tweet
                    pause(15)
                    thingSpeakWrite(1696058,'Fields',[4],'Values','First Down Tennessee!','WriteKey','RP1GXVY55GGZU1PN')
                 end % end of 1st down tweet conditional                        
                     if fdmxlocation>lineofscrimmage && x(end)<128 % starting on left side  of field and run into back endzone conditional 
                        hold on 
                        text(x(end),5,'Safety!','Fontsize',20,'FontWeight','bold','Color','red') % Plot a "Safety!" in red text
                %       [y, Fs] = audioread('Wrong Clakson Sound Effect.mp3'); 
                %       player = audioplayer(y, Fs);
                %       play(player) % play the 'X'/incorrect sound
                %       pause(5)
                        return % quit function                                
                     elseif fdmxlocation<lineofscrimmage && x(end)>1076 % starting on right side of field and run into back endzone conditional
                        hold on
                        text(x(end),5,'Safety','Fontsize',20,'FontWeight','bold','Color','red') % Plot "Safety!" in red text
                %       [y, Fs] = audioread('Wrong Clakson Sound Effect.mp3');
                %       player = audioplayer(y, Fs);
                %       play(player) % play the 'X'/incorrect sound
                %       pause(5)
                        return % quit function
                     elseif fdmxlocation>lineofscrimmage && x(end)>1076 % starting on the left side of the field and score a touchdown
                        hold on
                        text(x(end)-50,5,'Touchdown!','Fontsize',20,'FontWeight','bold','Color',[255/255 130/255 0]) % display 'Touchdown!' in UTK orange
                %       [y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
                %       player = audioplayer(y, Fs);
                %       play(player) % play UTK fight song
                %       pause(25)
                        pause(15)
                        thingSpeakWrite(1696058,'Fields',[4],'Values',{'Touchdown Tennessee! Go Vols!!! #vol4life'},'WriteKey','RP1GXVY55GGZU1PN')
                        return % quit function
                     elseif fdmxlocation<lineofscrimmage && x(end)<128 % starting on the right side of the field and score a touchdown
                        hold on
                        text(x(end)+50,5,'Touchdown!','Fontsize',20,'FontWeight','bold','Color',[255/255 130/255 0]) % display 'Touchdown' in UTK orange
                %       [y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
                %       player = audioplayer(y, Fs);
                %       play(player) % Play UTK fight song
                %       pause(25)
                        pause(15)
                        thingSpeakWrite(1696058,'Fields',[4],'Values',{'Touchdown Tennessee! Go Vols!!! #vol4life'},'WriteKey','RP1GXVY55GGZU1PN')
                        return % quit function
                     end % end of Safety or Touchdown conditional
   while true % opens infinite while loop 
      % AT THIS POINT THE CODE CONTINUES TO REPEAT ITSELF AS LONG AS THE USER
      % WANTS TO RUN A PLAY. WHEN THEY DECIDE THEY ARE FINISHED RUNNING PLAY,
      % THE LAST ROUTE'S DISTANCES, TURN ANGLES, AND VECTOR MATRIX IS OUTPUTTED
      % SINCE THE REMAINING LINES OF CODE JUST REPEAT, I DECIDED NOT TO COMMENT
      % ON EVERY SINGLE LINE. IF REFERENCE IS NEEDED, RETURN TO THE SAME CODE
      % AT THE BEGINNING OF THE FUNCTION.
     if x(end)>=fdmxlocation && x(1)<fdmxlocation && x(end)>x(1) % starting on left side of field
        list={'Yes','No'};
        [indx,tf]=(listdlg('PromptString',{'Do you want to run aother play?'},'SelectionMode','single','ListString',list));
          if indx==1 && tf==1
             close all
             imshow('Football Field.png')
             football_image=imread('Football Field.png');
             [rows,columns]=size(football_image);
             hold on 
             fdmxlocation=x(end)+(10/(120/1138));%pixel location of firstdown marker
             if fdmxlocation>1076 || fdmxlocation<128
                set(xline(fdmxlocation,'y','LineWidth',3),'Visible','off')
             else
                xline(fdmxlocation,'y','LineWidth',3)
             end            
             hold on
             lineofscrimmage=x(end); %pixel location of line of scrimmage
             xline(lineofscrimmage, 'blue','LineWidth',3)
             Down_Number=1;
             hold on
             if lineofscrimmage>980 || lineofscrimmage<223
                deltalinescrimfirstdownntext=sprintf('%s down & Goal',num2str(Down_Number));
                deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')                    
                thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')                   
             else
                 if fdmxlocation>1076 || fdmxlocation<127
                    if fdmxlocation>1076
                       deltalinescrimfirstdownpixels=abs(1076-lineofscrimmage);
                       deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                       deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                       deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                       text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')                    
                       thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                    elseif fdmxlocation<127
                       deltalinescrimfirstdownpixels=abs(127-lineofscrimmage);
                       deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                       deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                       deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                       text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                       thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                    end
                 else
                    deltalinescrimfirstdownpixels=abs(fdmxlocation-lineofscrimmage);
                    deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                    deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                    deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                    text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                    thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                 end
            end
        %run play 
         waitfor(msgbox('Click along the path you run; when finished, press enter','Instructions for Path Selection'))                    
         [x,y]=ginput();
         x=[lineofscrimmage
            x];  
         y=[y(1)
            y];
         hold on                                 
         for i=1:length(x)
             if 32<=x(i) && x(i)<=1170 && 34<=y(i) && y(i)<=547 % if points are in bounds
                plot(x,y,'r-','LineWidth',3)
                hold on
                plot(x(end),y(end),'yo','Markersize',6,'MarkerFaceColor','yellow')
                ypostionyards=(513-(y-34)).*((160/3)/513);% y position in yards relative to bottom line
                ypostionyards=round(ypostionyards,0);     
             end
         end
        %Distance traveled
          % First turn points into coordinates
             A=[];
             for i=1:length(x)
                 A=[A;
                    x(i), y(i)];
             end                      
          % Use Sum of Norms between points (Sum of Vectors) to find pixel disstance
             Distance=[];
             Vector_Yards=[];
             for i=1:(length(x)-1)
                 length_btw_points=norm(A(i+1,:)-A(i,:));
                 length_btw_points_yards=length_btw_points.*(120/1138);
                 Distance=[Distance,length_btw_points];
                 Vector_Yards=[Vector_Yards,length_btw_points_yards];          
             end
             Distance_yrds=Vector_Yards;
             TotalDistance_pixels=sum(Distance); % total distance in pixels
             TotalDistance_yards=sum(Vector_Yards);
             TotalDistance_yards=round(TotalDistance_yards);
        % Find the angle between vectors
           Vectors=[];                                 
           for i=1:(length(x)-1)
               myvectors=A(i+1,:)-A(i,:);
               Vectors=[Vectors,
                        myvectors];                                 
           end  
           VectorMatrix=Vectors.*(120/1138);
           Direction=[];
           Angles=[];
           Angles2=[];
           for i=1:length(Vectors)-1
               mytheta=round(acosd(dot(Vectors(i+1,:),Vectors(i,:))/(norm(Vectors(i+1,:))*norm(Vectors(i,:)))),0);
               mytheta2=round(atan2d(Vectors(i+1,2).*Vectors(i,1)-Vectors(i+1,1).*Vectors(i,2),Vectors(i+1,1)*Vectors(i,1)+Vectors(i+1,2)*Vectors(i,2)),0);
               Angles2=[Angles2,mytheta2];
               Angles=[Angles,mytheta];
           end
           Turn_Angles=Angles2;                                
         else
            waitfor(msgbox("I'm sorry to hear that. We won't run a play"))
            return
          end          
  elseif x(end)<fdmxlocation && Down_Number<=4 && (x(end)<lineofscrimmage || x(end)<fdmxlocation) && (x(end)>x(1)||x(end)<x(1)) && lineofscrimmage<fdmxlocation % starting on left side of field
         list={'Yes','No'};
         [indx,tf]=(listdlg('PromptString',{'Do you want to run aother play?'},'SelectionMode','single','ListString',list));
         if indx==1 && tf==1
            close all
            imshow('Football Field.png')
            football_image=imread('Football Field.png');
            [rows,columns]=size(football_image);
            if Down_Number==1 && x(end)>=fdmxlocation
               Down_Number=Down_Number;
            elseif Down_Number>=1 && (x(end)<fdmxlocation)
               Down_Number=Down_Number+1;
            end
            hold on
            fdmxlocation=fdmxlocation; %pixel location of firstdown marker
            if fdmxlocation>1076 || fdmxlocation<128
               set(xline(fdmxlocation,'y','LineWidth',3),'Visible','off')
            else
            xline(fdmxlocation,'y','LineWidth',3)
            end                           
            hold on
            lineofscrimmage=x(end); %pixel location of line of scrimmage
            xline(lineofscrimmage, 'blue','LineWidth',3)                 
            hold on
            if lineofscrimmage>980 || lineofscrimmage<223
               deltalinescrimfirstdownntext=sprintf('%s down & Goal',num2str(Down_Number));
               deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
               text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
               thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')                    
            else
               if fdmxlocation>1076 || fdmxlocation<127
                  if fdmxlocation>1076
                     deltalinescrimfirstdownpixels=abs(1076-lineofscrimmage);
                     deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                     deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                     deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                     text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                     thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                  elseif fdmxlocation<127
                     deltalinescrimfirstdownpixels=abs(127-lineofscrimmage);
                     deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                     deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                     deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                     text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                     thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                  end
               else
                     deltalinescrimfirstdownpixels=abs(fdmxlocation-lineofscrimmage);
                     deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                     deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                     deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                     text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                     thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
               end
            end
        waitfor(msgbox('Click along the path you run; when finished, press enter','Instructions for Path Selection'))                
        [x,y]=ginput();
        x=[lineofscrimmage
           x];  
        y=[y(1)
           y];
        hold on                       
        for i=1:length(x)
            if 32<=x(i) && x(i)<=1170 && 34<=y(i) && y(i)<=547 % if points are in bounds
               plot(x,y,'r-','LineWidth',3)
               hold on
               plot(x(end),y(end),'yo','Markersize',6,'MarkerFaceColor','yellow')
               ypostionyards=(513-(y-34)).*((160/3)/513);% y position in yards relative to bottom line
               ypostionyards=round(ypostionyards,0);     
           end
        end
        %Distance traveled
          % First turn points into coordinates
            A=[];
            for i=1:length(x)
                A=[A;
                   x(i), y(i)];
            end                       
          % Use Sum of Norms between points (Sum of Vectors) to find pixel distance
            Distance=[];
            Vector_Yards=[];
            for i=1:(length(x)-1)
                length_btw_points=norm(A(i+1,:)-A(i,:));
                length_btw_points_yards=length_btw_points.*(120/1138);
                Distance=[Distance,length_btw_points];
                Vector_Yards=[Vector_Yards,length_btw_points_yards];                        
            end
            Distance_yrds=Vector_Yards;
            TotalDistance_pixels=sum(Distance); % total distance in pixels
            TotalDistance_yards=sum(Vector_Yards);
            TotalDistance_yards=round(TotalDistance_yards);
        % Find the angle between vectors
            Vectors=[];                        
            for i=1:(length(x)-1)
                myvectors=A(i+1,:)-A(i,:);
                Vectors=[Vectors,
                         myvectors];                               
            end
            VectorMatrix=Vectors.*(120/1138);
            Direction=[];
            Angles=[];
            Angles2=[];
            for i=1:length(Vectors)-1
                mytheta=round(acosd(dot(Vectors(i+1,:),Vectors(i,:))/(norm(Vectors(i+1,:))*norm(Vectors(i,:)))),0);
                mytheta2=round(atan2d(Vectors(i+1,2).*Vectors(i,1)-Vectors(i+1,1).*Vectors(i,2),Vectors(i+1,1)*Vectors(i,1)+Vectors(i+1,2)*Vectors(i,2)),0);
                Angles2=[Angles2,mytheta2];
                Angles=[Angles,mytheta];
            end
            Turn_Angles=Angles2;           
      else
         waitfor(msgbox("I'm sorry to hear that. We won't run a play"))
         return
      end                  
  elseif x(end)<=fdmxlocation && x(1)>fdmxlocation && x(end)<x(1) %  starting on right side of field & get a first down
      list={'Yes','No'};
      [indx,tf]=(listdlg('PromptString',{'Do you want to run aother play?'},'SelectionMode','single','ListString',list));
      if indx==1 && tf==1
         close all
         imshow('Football Field.png')
         football_image=imread('Football Field.png');
         [rows,columns]=size(football_image);
         hold on 
         fdmxlocation=x(end)-(10/(120/1138)); %pixel location of firstdown marker
         if fdmxlocation>1076 || fdmxlocation<128
            set(xline(fdmxlocation,'y','LineWidth',3),'Visible','off')
         else
            xline(fdmxlocation,'y','LineWidth',3)
         end
         Down_Number=1;
         hold on
         lineofscrimmage=x(end); %pixel location of line of scrimmage
         xline(lineofscrimmage, 'blue','LineWidth',3)                  
         if lineofscrimmage>980 || lineofscrimmage<223
            deltalinescrimfirstdownntext=sprintf('%s down & Goal',num2str(Down_Number));
            deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
            text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
            thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')                        
         else
             if fdmxlocation>1076 || fdmxlocation<127
                if fdmxlocation>1076
                   deltalinescrimfirstdownpixels=abs(1076-lineofscrimmage);
                   deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                   deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                   deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                   text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                   thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                elseif fdmxlocation<127
                   deltalinescrimfirstdownpixels=abs(127-lineofscrimmage);
                   deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                   deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                   deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                   text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                   thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                end
             else
                deltalinescrimfirstdownpixels=abs(fdmxlocation-lineofscrimmage);
                deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
             end
         end
         %run play 
         waitfor(msgbox('Click along the path you run; when finished, press enter','Instructions for Path Selection'))                      
         [x,y]=ginput();
         x=[lineofscrimmage
            x];  
         y=[y(1)
            y];
         hold on                     
         for i=1:length(x)
             if 32<=x(i) && x(i)<=1170 && 34<=y(i) && y(i)<=547 % if points are in bounds
                plot(x,y,'r-','LineWidth',3)
                hold on
                plot(x(end),y(end),'yo','Markersize',6,'MarkerFaceColor','yellow')
                ypostionyards=(513-(y-34)).*((160/3)/513);% y position in yards relative to bottom line
                ypostionyards=round(ypostionyards,0);     
             end
         end
         %Distance traveled
           % First turn points into coordinates
              A=[];
              for i=1:length(x)
                  A=[A;
                     x(i), y(i)];
              end                     
           % Use Sum of Norms between points (Sum of Vectors) to find pixel disstance
              Distance=[];
              Vector_Yards=[];
              for i=1:(length(x)-1)
                  length_btw_points=norm(A(i+1,:)-A(i,:));
                  length_btw_points_yards=length_btw_points.*(120/1138);
                  Distance=[Distance,length_btw_points];
                  Vector_Yards=[Vector_Yards,length_btw_points_yards];                          
              end
              Distance_yrds=Vector_Yards;
              TotalDistance_pixels=sum(Distance); % total distance in pixels
              TotalDistance_yards=sum(Vector_Yards);
              TotalDistance_yards=round(TotalDistance_yards);
           % Find the angle between vectors
              Vectors=[];                             
              for i=1:(length(x)-1)
                  myvectors=A(i+1,:)-A(i,:);
                  Vectors=[Vectors,
                           myvectors];                          
              end
              VectorMatrix=Vectors.*(120/1138);
              Direction=[];
              Angles=[];
              Angles2=[];
              for i=1:length(Vectors)-1
                  mytheta=round(acosd(dot(Vectors(i+1,:),Vectors(i,:))/(norm(Vectors(i+1,:))*norm(Vectors(i,:)))),0);
                  mytheta2=round(atan2d(Vectors(i+1,2).*Vectors(i,1)-Vectors(i+1,1).*Vectors(i,2),Vectors(i+1,1)*Vectors(i,1)+Vectors(i+1,2)*Vectors(i,2)),0);
                  Angles2=[Angles2,mytheta2];
                  Angles=[Angles,mytheta];
              end
              Turn_Angles=Angles2;
       else
         waitfor(msgbox("I'm sorry to hear that. We won't run a play"))
         return
       end
   elseif x(end)>fdmxlocation && Down_Number<=4 && x(end)>fdmxlocation && x(1)>fdmxlocation  % starting on right side of field & fall short of first down
       list={'Yes','No'};
       [indx,tf]=(listdlg('PromptString',{'Do you want to run aother play?'},'SelectionMode','single','ListString',list));
       if indx==1 && tf==1
          close all
          imshow('Football Field.png')
          football_image=imread('Football Field.png');
          [rows,columns]=size(football_image);
          if Down_Number==1 && x(end)<=fdmxlocation
             Down_Number=Down_Number;
          elseif Down_Number>=1 && (x(end)>fdmxlocation)
             Down_Number=Down_Number+1
          end
          hold on
          fdmxlocation=fdmxlocation; %pixel location of firstdown marker
          if fdmxlocation>1076 || fdmxlocation<128
             set(xline(fdmxlocation,'y','LineWidth',3),'Visible','off')
          else
             xline(fdmxlocation,'y','LineWidth',3)
          end                              
          hold on
          lineofscrimmage=x(end); %pixel location of line of scrimmage
          xline(lineofscrimmage, 'blue','LineWidth',3)                 
          hold on
          if lineofscrimmage>980 || lineofscrimmage<223
             deltalinescrimfirstdownntext=sprintf('%s down & Goal',num2str(Down_Number));
             deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
             text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
             thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')                      
          else
             if fdmxlocation>1076 || fdmxlocation<127
                if fdmxlocation>1076
                   deltalinescrimfirstdownpixels=abs(1076-lineofscrimmage);
                   deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                   deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                   deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                   text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                   thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                elseif fdmxlocation<127
                   deltalinescrimfirstdownpixels=abs(127-lineofscrimmage);
                   deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                   deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                   deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                   text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                   thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
                end
             else
                 deltalinescrimfirstdownpixels=abs(fdmxlocation-lineofscrimmage);
                 deltalinescrimfirstdownyrds=deltalinescrimfirstdownpixels*(120/1138);
                 deltalinescrimfirstdownntext=sprintf('%s down & %2.0f\n',num2str(Down_Number),deltalinescrimfirstdownyrds);
                 deltalinescrimfirstdownntext=char(deltalinescrimfirstdownntext);
                 text(lineofscrimmage-70,5,deltalinescrimfirstdownntext,"FontSize",15,'FontWeight','bold')
                 thingSpeakWrite(1696058,'Fields',[1],'Values',{deltalinescrimfirstdownntext},'WriteKey','RP1GXVY55GGZU1PN')
             end
         end
         waitfor(msgbox('Click along the path you run; when finished, press enter','Instructions for Path Selection'))                  
         [x,y]=ginput();
         x=[lineofscrimmage
            x];  
         y=[y(1)
            y];
         hold on             
         for i=1:length(x)
             if 32<=x(i) && x(i)<=1170 && 34<=y(i) && y(i)<=547 % if points are in bounds
                plot(x,y,'r-','LineWidth',3)
                hold on
                plot(x(end),y(end),'yo','Markersize',6,'MarkerFaceColor','yellow')
                ypostionyards=(513-(y-34)).*((160/3)/513);% y position in yards relative to bottom line
                ypostionyards=round(ypostionyards,0);     
             end
         end
         %Distance traveled
           % First turn points into coordinates
             A=[];
             for i=1:length(x)
                 A=[A;
                    x(i), y(i)];
             end                       
           % Use Sum of Norms between points (Sum of Vectors) to find pixel disstance
             Distance=[];
             Vector_Yards=[];
             for i=1:(length(x)-1)
                 length_btw_points=norm(A(i+1,:)-A(i,:));
                 length_btw_points_yards=length_btw_points.*(120/1138);
                 Distance=[Distance,length_btw_points];
                 Vector_Yards=[Vector_Yards,length_btw_points_yards];                           
             end
             Distance_yrds=Vector_Yards;
             TotalDistance_pixels=sum(Distance); % total distance in pixels
             TotalDistance_yards=sum(Vector_Yards);
             TotalDistance_yards=round(TotalDistance_yards);
          % Find the angle between vectors
             Vectors=[];                              
             for i=1:(length(x)-1)
                 myvectors=A(i+1,:)-A(i,:);
                 Vectors=[Vectors,
                 myvectors];                                               
             end 
             VectorMatrix=Vectors.*(120/1138);
             Direction=[];
             Angles=[];
             Angles2=[];
             for i=1:length(Vectors)-1
                 mytheta=round(acosd(dot(Vectors(i+1,:),Vectors(i,:))/(norm(Vectors(i+1,:))*norm(Vectors(i,:)))),0);
                 mytheta2=round(atan2d(Vectors(i+1,2).*Vectors(i,1)-Vectors(i+1,1).*Vectors(i,2),Vectors(i+1,1)*Vectors(i,1)+Vectors(i+1,2)*Vectors(i,2)),0);
                 Angles2=[Angles2,mytheta2];
                 Angles=[Angles,mytheta];
             end
             Turn_Angles=Angles2;
             Sound=[fdmxlocation,lineofscrimmage,x(end)]; % FOURTH OUTPUT OF FUNCTION; USED FOR SOUND DATA IN ROBO_ROUTE
         else
             waitfor(msgbox("I'm sorry to hear that. We won't run a play"))
             return
         end
     end
         if Down_Number==3
            pause(15)
            thingSpeakWrite(1696058,'Fields',[4],'Values',"It's Thirrrrrrrrrrrrddddd Down!",'WriteKey','RP1GXVY55GGZU1PN')
         end
         if fdmxlocation<x(end) && fdmxlocation>x(1) && x(end)<1076 % moving to right & get first down, send tweet
            pause(15)
            thingSpeakWrite(1696058,'Fields',[4],'Values','First Down Tennessee!','WriteKey','RP1GXVY55GGZU1PN')
         end % end of 1st down tweet conditional 
         if fdmxlocation<x(1) && fdmxlocation>x(end) && x(end)>128 % moving to the left & get first down, send tweet
            pause(15)
            thingSpeakWrite(1696058,'Fields',[4],'Values','First Down Tennessee!','WriteKey','RP1GXVY55GGZU1PN')
         end % end of 1st down tweet conditional 
         if fdmxlocation>lineofscrimmage && x(end)<128
            hold on 
            text(x(end),5,'Safety!','Fontsize',20,'FontWeight','bold','Color','red')
            %[y, Fs] = audioread('Wrong Clakson Sound Effect.mp3');
            % sound(y,Fs)
%           player = audioplayer(y, Fs);
%           play(player)
%           pause(5)
            return               
         elseif fdmxlocation<lineofscrimmage && x(end)>1076
            hold on
            text(x(end),5,'Safety','Fontsize',20,'FontWeight','bold','Color','red')
            %[y, Fs] = audioread('Wrong Clakson Sound Effect.mp3');
            %sound(y,Fs)
%           player = audioplayer(y, Fs);
%           play(player)
%           pause(5)
            return
         elseif fdmxlocation>lineofscrimmage && x(end)>1076
            hold on
            text(x(end)-50,5,'Touchdown!','Fontsize',20,'FontWeight','bold','Color',[255/255 130/255 0])
            %[y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
            %sound(y,Fs)
            %player = audioplayer(y, Fs);
            %play(player)
            %pause(25)
            pause(15)
            thingSpeakWrite(1696058,'Fields',[4],'Values',{'Touchdown Tennessee! Go Vols!!! #vol4life'},'WriteKey','RP1GXVY55GGZU1PN')
            return
          elseif fdmxlocation<lineofscrimmage && x(end)<128
            hold on
            text(x(end),5,'Touchdown!','Fontsize',20,'FontWeight','bold','Color',[255/255 130/255 0])
            %[y, Fs] = audioread('university-of-tennessee-unofficial-fight-song--rocky-top.mp3');
            %sound(y,Fs)
%           player = audioplayer(y, Fs);
%           play(player)
%           pause(25)
            pause(15)
            thingSpeakWrite(1696058,'Fields',[4],'Values',{'Touchdown Tennessee! Go Vols!!! #vol4life'},'WriteKey','RP1GXVY55GGZU1PN')
            return
          end % end of safety or touchdown conditional
         end % end of second nested infinite while loop
  end % end of first infinite while loop 
end % END OF Robo_Madden() Function 
   
    







