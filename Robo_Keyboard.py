# Minimum drive example
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
    
    

 
# def on_press(key):
#     if key == keyboard.Key.left or  key == keyboard.Key.right:
#         if key == keyboard.Key.left:
            
#             print('Turning {direction} by 1 degree'.format(direction='Left'))
           
#         if key == keyboard.Key.right:
           
#             print('Turning {direction} by 1 degree'.format(direction='Right'))                     
#     if key == kb.Key.up or  key == kb.Key.down:
#         if key == kb.Key.up:
#             print("Moving {fwdorbwd}".format(fwdorbwd="Forwards"))
                  
#         if key == kb.Key.down:
#             print("Moving {fwdorbwd}".format(fwdorbwd="Backwards"))
              
#     if key == kb.Key.esc:
#         Stop listener
#         return False
    
# def on_release(key):
#     if key == kb.Key.esc:
#         Stop listener
#         return False
#     if  key ==kb.Key.up or key ==kb.Key.down:
#         time.sleep(2)
#         print("Resetting Count")
#         rvr.stop()
#         return False
#     if key ==kb.Key.left or key ==kb.Key.right:
#         time.sleep(2)
#         print('Resetting Count')
        
#         return False
 
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
  

while True:
    print("I'm Ready!")
    listen_keyboard(on_press=press)
    Test_Run.runExample()

# while True:
  
#     time.sleep(1)
    
#     keyboard.read_key()
#     while keyboard.is_pressed('up') or keyboard.is_pressed('down') or keyboard.is_pressed('left')\
#         or keyboard.is_pressed('right') or keyboard.is_pressed('esc'):  # making a loop
        
#         if keyboard.is_pressed('up'):  # if key 'up' is pressed 
#             print('Initiate forward movement')
#             rvr.drive_with_heading(speed=90,heading=0,flags=0)
#             break
#             # finishing the loop
#         if keyboard.is_pressed('down'):
#             print('Initiate backward movement')
#             rvr.drive_control.turn_left_degrees(heading=0,amount=180)
#             time.sleep(3)
#             rvr.reset_yaw()
#             time.sleep(1)
#             rvr.drive_with_heading(speed=90,heading=0,flags=0)
#             break
#         if keyboard.is_pressed('right'):
#             print('Turning {direction} by 10 degrees'.format(direction='Right'))
#             rvr.drive_control.turn_right_degrees(heading=0,amount=10)
#             time.sleep(3)
#             rvr.reset_yaw()
#             break
#         if keyboard.is_pressed('left'):
#             print('Turning {direction} by 10 degrees'.format(direction='Left'))
#             rvr.drive_control.turn_left_degrees(heading=0,amount=10)
#             time.sleep(3)
#             rvr.reset_yaw()
#             break
#         if keyboard.is_pressed('esc'):
#             quit()
    
    # # Collect events until released
    # with kb.Listener(
    #         on_press=on_press,
    #         on_release=on_release) as listener:
        
    #     listener.join()