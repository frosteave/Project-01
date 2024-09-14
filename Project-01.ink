/*
    Project 01
    
    Requirements (for 15 base points)
    - Create an interactive fiction story with at least 8 knots 
    - Create at least one major choice that the player can make
    - Reflect that choice back to the player
    - Include at least one loop
    
    To get a full 20 points, expand upon the game in the following ways
    [+2] Include more than eight passages
    [+1] Allow the player to pick up items and change the state of the game if certain items are in the inventory. Acknowledge if a player does or does not have a certain item
    [+1] Give the player statistics, and allow them to upgrade once or twice. Gate certain options based on statistics (high or low. Maybe a weak person can only do things a strong person can't, and vice versa)
    [+1] Keep track of visited passages and only display the description when visiting for the first time (or requested)
    
    Make sure to list the items you changed for points in the Readme.md. I cannot guess your intentions!

*/



VAR beginning = 0
VAR time=-1
VAR sabatoge = 0
VAR scratched_door = 0
VAR keys = 0


-> lobby

== lobby ==

{beginning < 1 : You are a cat. Your current human companion is eating breakfast at the hotel you are staying at. You have just finished a grand adventure with him and helped slain the dragon that was terrorizing the land, and now you are tired.}
{beginning < 1 : You lie under his feet, resting from a long month of travels.} {beginning >= 1: You return to your companion.} {not knockedover: His glass of water sits on the table.}


The lobby is loud around you.
A man is talking to your companion, asking for his help on a new adventure. He wants him to leave immedietly. You do not want to go on another adventure.

*[Grab room key] ->key_pickup
+[Go behind front desk]  ->front_desk
+ [Go to your room] ->leave_lobby
+ [Run outside] ->outside_interlude
*[Knock over glass of water] -> knockedover


== leave_lobby ==
~ beginning = beginning + 1
You leave the busy dining area to head to your room.->hallway

==front_desk==
~ beginning = beginning + 1

You dart behind the front desk of the hotel. 
It is { advance_time() }. 
{time == 0 : You will draw too much attention if you try to get behind the counter. Perhaps you can come back later. }
{time == 1: {scratched_door==0: ->nice_staff } {scratched_door>0: ->angry_staff }}
{time == 2: ->gone_staff}
+ {time == 0} [Return to lobby] ->lobby

->END

==angry_staff==
The staff working sees you.
"You must be who scratched up that door!! Shoo!!" They wave you away from the front desk.
+[Go back] ->lobby

->END

==nice_staff==
The staff member working at the desk sees you, and pets you on the head. {not masterkey: "Aw, do you need to get into your room? Here's the key, make sure to bring it back!"}
{not masterkey: That has to be against policy. ->masterkey}
+[Go back] -> lobby

->END

==gone_staff==
The staff has gone, but the drawers seem to have been left open. How careless. {not masterkey: You notice the masterkey in the drawer. You could easily grab it.}
*{not masterkey } [Grab key] -> masterkey
+[Go back] -> lobby

->END

==masterkey==
~ keys = keys + 1
This key will open anything! Hopefully. You now have {keys} key{keys>1:s}.
->lobby

->END

==hallway==
This hallway outside your room is long and dark. Good thing you are a cat and can see in the dark. {keys==0: Unfortunantly you cannot pick locks.}
There are two rooms that you take most interest in: your own room and the one of the man inquiring about a quest.
*[Try to scratch door open] -> damaged_door
*{key_pickup} {not room} [Use room key to open own door] ->room
*{masterkey} {not room} [Use masterkey to open own door] ->room
*{masterkey} [Open the other man's door with the masterkey] -> other_room
+{other_room} [Go in empty room] -> other_room
+{room} [Go in your room] ->room
+[Go back]->lobby
-> END

==other_room==
There is nothing here. Perhaps you have the wrong room. The man seemed like he was in a hurry to leave anyway, perhaps his things are packed.
+[Return to hallway]->hallway

==roomfromoutside
You narrowly squeeze through the window. Good thing you're a cat.->room

==room==
{not clawed_clothes: You enter your room.  It is small; a window is left cracked open where the curtains flutter in the breeze, and the ceiling above creaks with heavy footsteps. There is a small attatched bathroom with the door slightly ajar.} 
Your companion's {clawed_clothes: shredded} things are strewn about the room in a haphazard fashion. You think of ways to "convince" him not to go on another adventure so soon.
+[Go in bathroom] ->bathroom
*[Claw up clothes] -> clawed_clothes
*[Pick up boots] ->picked_up_boots
+[Exit room] ->hallway
+[Go out window] ->backoutthewindow
->END

==bathroom==
The bathroom smells funky {boots_in_tub: and distinctly like wet leather}, and there is a small tub in the corner. {not boots_in_tub: You might have an idea.}
*[Turn water on] ->water_turned_on
*{picked_up_boots}{water_turned_on} [Put boots in tub] ->boots_in_tub
+[Go back to room] ->room
->END

==boots_in_tub==
Oh he won't like this. But at least he wouldnt be going anywhere for a while.
~ sabatoge = sabatoge + 1
*[Continue]->bathroom

== water_turned_on ==
You turn the water on. The water starts flowing into the tub. Your companion won't want to travel in wet clothes, right?
->bathroom

==picked_up_boots==
You pick up his boots. They're a bit large and hard to carry, but made of a nice leather.
*[Continue] -> room

==clawed_clothes ==
You shred his clothes. This should keep him from leaving on this adventure. At least, until he can get new ones.
He's gonna be so mad.
~ sabatoge = sabatoge + 1
*[Continue] ->room

== damaged_door ==
You scratch at the door. It does not open. Hopefully the hotel staff isn't too mad at the damage.
~ sabatoge = sabatoge + 1
~ scratched_door = scratched_door + 1
+[Go Back]->hallway
->END

==key_pickup ==
You now have a key to your human conpanion's room. It's your room too. What's his is yours.
~ keys = keys + 1
~ beginning = beginning + 1
You now have {keys} key{keys>1:s}.
*[Continue] -> lobby
->END

==knockedover==
You leap up onto the table, scattering food everywhere and knocking your companion's full glass of water onto the other man. Your companion yells, but it is not as loud as the inquiring man's shout. 
He screams that he is allergic to cats, and no longer wants your companion's help. He storms away.
Well that was easy.
*[Continue]->aftermath

==aftermath==
Your companion glares at you, but continues eating his breakfast. He didn't want to work with a man allergic to cats anyway.
{clawed_clothes: You hope he doesn't find out about his clothes.{boots_in_tub: Or his boots.}}
{boots_in_tub: {not clawed_clothes: You hope he doesn't blame you for the boots}}
{damaged_door: He shouldn't get too mad at you about the door. After all, you are a cat.}
You curl back up under his feet.
->END

== outside_interlude ==
~ beginning = beginning + 1
You dart out from under your companion's feet and run outside, narrowly avoiding the hotel staff. You hear the staff shut the door behind you. You cannot get back in that way. ->outside
->END

==outside==
It is bright outside in the early morning. The front door to the hotel is locked.
*[Wait for your companion.] -> waited
+[Walk around hotel] -> hotelback
->END

==hotelback==
You walk around to the back of the hotel. You can see your room's window left cracked on the second floor. You should be able to get in, if you want.
+[Climb up window] ->roomfromoutside
+[Go back] ->outside
->END

==backoutthewindow==
You jump out the window. You land on your feet, because there is no world in which you do not. 
+[Climb back up window] ->roomfromoutside
+[Go around hotel] ->outside
->END

==waited==

You find a spot of sun to lie in and slowly fall asleep.
Soon you wake to your companion and the other man walking out with their things, talking loudly.
{boots_in_tub: Your companion makes a loud sloshing noise as he walks up.}{clawed_clothes: Your human's clothes hang in tatters.} 
{sabatoge > 2: He sees you. He frowns a little bit, and then stops walking. He stares right at you, and then down at his attire. He looks back up. "This man here is allergic to cats," he says. "You can stay here for this adventure." He then leaves with the man. }
{sabatoge == 0: He sees you. He grins a little bit, and then stops walking. "Hey, there you are," he says. }
{sabatoge == 0: The other man glares at you, and you glare back. He turns to your companion and loudly declares "I am allergic to cats!" Your companion is schocked by this declaration, and then informs the man that he will not be be helping him without you. The man huffs and storms away. }
*{sabatoge > 2} [Continue]->alone
*{sabatoge == 0} [Get up]->happyending
*{0 < sabatoge} {sabatoge < 3} [Get up]->neutralending


=neutralending
Your companion spots you. 
"So that's where you got off too. Come back inside. {boots_in_tub: He glares at you. I'll need to wait a bit for my shoes to dry before I go anywhere.}{boots_in_tub:{clawed_clothes: And,}} {clawed_clothes: I'll need to pick up some new clothes before heading off on a new adventure.} We won't be leaving the hotel for a little while yet. This man even said he was allergic to cats! I can't have him come with us!"
The man looks at you both, and then stalks off, grumbling.

You both go inside to rest.
->END

==happyending==
Your companion takes you back inside the hotel room. You find a patch of sunlight on the ground and lie down once more. 
There should be no more adventures for a while.
->END

==alone==
You have been left alone. You are not going on an adventure. This is what you wanted, right?
->END

== function advance_time ==

    ~ time = time + 1
    
    {
        - time > 2:
            ~ time = 0
    }    
    
    {    
        - time == 0:
            ~ return "closed"
        
        - time == 1:
            ~ return "later"
        
        - time == 2:
            ~ return "much later"
    
    }

    
        
    ~ return time
    
    
    
