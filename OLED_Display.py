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