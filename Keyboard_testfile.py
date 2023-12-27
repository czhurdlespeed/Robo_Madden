# Calvin Wetzel & Mindy Le
# EF230 Python Project
# Date: May 6, 2022
# Function: Controls Robot using keyboard arrow keys. On 'esc' Test_Run file's run_example() runs \
    #to display question and answers on robot's OLED display

# Minimum drive example (Lines 1-25 Taken from DriveExample File)
import sys
sys.path.append('/home/pi/sphero-sdk-raspberrypi-python/')
import os

from sshkeyboard import listen_keyboard
import time   
# from pynput import keyboard as kb 

# allow pull files from two layers above and append path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../')))

    
import asyncio # allow concurrent code using async/await
from sphero_sdk import SerialAsyncDal
from sphero_sdk import SpheroRvrAsync
from sphero_sdk import RawMotorModesEnum
from sphero_sdk import SpheroRvrObserver
import Test_Run
    
speed = 0
heading = 0
flags = 0

rvr = SpheroRvrObserver()    

# Code Template gained from Stack Overflow : https://stackoverflow.com/questions/65594459/listen-to-keystrokes-on-an-ssh-terminal
            # from sshkeyboard import listen_keyboard

            # def press(key):
            #     if key == "up":
            #         print("up pressed")
            #     elif key == "down":
            #         print("down pressed")
            #     elif key == "left":
            #         print("left pressed")
            #     elif key == "right":
            #         print("right pressed")

            # listen_keyboard(on_press=press)

# Python function for when key is pressed; Conditionals for each arrow key are within the function
def press(key):
    rvr.wake()
    rvr.reset_yaw()
    if key == "up":
        print("up pressed")
        print('Initiate forward movement')
        rvr.drive_with_heading(speed=90,heading=0,flags=0)
        
    elif key == "down":
        print("down pressed")
        rvr.drive_control.turn_left_degrees(heading=0,amount=180)
        time.sleep(2)
           
    elif key == "left":
        print("left pressed")
        rvr.drive_control.turn_left_degrees(heading=0,amount=90)
   
    elif key == "right":
        print("right pressed")
        rvr.drive_control.turn_right_degrees(heading=0,amount=90)
  
# While loop establishes a listener for the key strokes. On the 'esc' command, the listener ends\
    # and Test_Run.runExample() runs
while True:
    print("I'm Ready!") # Identifies that the robot is ready for commands 
    listen_keyboard(on_press=press) # listens for keystrokes and calls function on each keystroke 
    Test_Run.runExample() # OLED function from Test_Run file
    break # stops while loop once all of the functions have ran 

