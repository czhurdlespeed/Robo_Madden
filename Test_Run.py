# Calvin Wetzel & Mindy Le
# EF230 Python Project
# Date: May 6, 2022
# Function: Display questions and answers on robot's OLED Display


# Code template from OLEDclear example
import qwiic_micro_oled
import sys
import qwiic
import qwiic_vl53l1x
import time

# Function def line
def runExample():

    # Initialize display
    myOLED = qwiic_micro_oled.QwiicMicroOled()
    myOLED.begin()

    # Clear anything that might be displayed
    myOLED.clear(myOLED.PAGE)
    myOLED.clear(myOLED.ALL)

    # Set default font and screen position
    myOLED.set_font_type(0)
    myOLED.set_cursor(0,0)

    # Print text to buffer
    myOLED.print("")

    # Change screen position for multiple lines of text
    myOLED.set_cursor(0,0)
    myOLED.print("Hello")
    myOLED.display()
    myOLED.set_cursor(0,15)
    myOLED.print("Favorite Color? ")
    myOLED.display()
    ques1_ans = input("Favorite Color? ")
   
    myOLED.set_cursor(0,30)
    myOLED.print(ques1_ans)
    myOLED.display()
    time.sleep(3)
    

    # Actually push data to OLED display
   

    # Set a while true loop for continuous display update
    i = 0
    while True:
        try:
            # Incremental variable
            i = i + 1

            # Reset cursor to 30 or it will print to next line of the OLED
            
            myOLED.set_cursor(0,30)
            # More complex printing (like sprintf in matlab)
            # (use %f for floating point, %i for intergers, %s for text)
            myOLED.print("Count to: %3i" % (i))
            myOLED.display()

            if (i == 50):
                myOLED.clear(myOLED.PAGE)
                myOLED.set_cursor(0,15)
                myOLED.print('Favorite Sport?')
                myOLED.display()
                myans2= input("What's your favorite sport? ")
                myOLED.set_cursor(0,30)
                myOLED.print(myans2)
                myOLED.display()
                time.sleep(5)
                myOLED.clear(myOLED.PAGE)
                myOLED.clear(myOLED.ALL)
            elif (i==100):
                quit()

        except Exception as e:
            print("Ctrl-C terminated process") # will terminate if you use ctrl-c

        # Use this so that robot comunication isn't too fast
        time.sleep(0.005)


