# The Game Scene Chart
#### Written in 2012 for Windows.

[Original package](https://defacto2.net/f/b62aabf)

---

> WidowMaker [retired] on: February 06, 2011 ([dbfinteractive topic](http://www.dbfinteractive.com/forum/index.php?topic=4911.msg65954))

I have got a lot out of this forum.

I think that I have writen over 20 cracktros in my career under different names and I know that this place is legal but the intros are not illegal so I feel ok about this post.

The biggest project that I ever worked on were three projects..

A friend was writing a chart for the game scene, the groups that actively crack games.

The scene is goverened by a set of ISO rules and each compliant release is included in the scores.

The friend was working on it because a group called TNT had been producing a text based chart that was very biased towards TNT.

My friend wanted to do something fairer and more in line with the old Eurochart on the Amiga, and not just a text file like the DOX report which TNT produced.

Alpha One coded a menu for the Game Scene Chart but it was just an adapted keygen menu, it had compatibility problems and it crashed quite a lot.  A1 was going to improve the engine but it never happened and I coded a chart engine.  It was a simple one because the chart was just a single page text file but the reception was good.

Jizzy did the graphics and it had smooth scrolling, it was still basic but had come a long way.  In the end TNT stopped releasing the DOX report and the game scene chart remained as the only real chart for the ISO scene.

Over time I have  re-wrote the engine twice so it is now in its third incarnation and the engine includes;

An intro with selectable SID songs.
Space for 20 huge articles.
4 Selectable Modules in the main chart
A suite of tools to build and compile the chart so that someone with no coding knowledge can compile it... One can lieterally drop the music files in there, edit a text file and compile it all with a couple of batch files!

Many of the things that I used in building this chart came from this forum, such as ;

tinyptcext
bmp2raw
bin2bas
tinysid

And many other things that had me stumped but then I found the answer here.

The last issue of the charts (issue 50) was released on 31st of January.  This is the final issue.

So there is no need for the source to this suite to be kept away from the public and it's fitting that it should end it's life here at the place which allowed it's creation.

If you want to read the game scene charts you can find most of them on defacto2.net, they seem to end up there eventually somehow... Though the subject matter probably won't interest most of you.  The games scene is not the demo scene and there's much less of an overlap these days...
It is rare to find a cracker who has demo coding skills and vice cersa.

I have not put this source here for people to compile a spoof version of the chart, that would be totally lame and I will ask that you get my permission before you use and part of this code that could be identified as coming from my chart engine.

There are a lot of snippets in there that you are welcome to take and use freely if you like mind you.

You'll want to read the three instruction files, they are the ones I left for the editor of the chart.

Configuration.txt allows you to change the intro and a few other things like the menu titles.

Double click the batch file "format pages" to have some fun in the text formatter.
Quit that then double click "compile-chart"

The output file is charts.exe.

Writing this application was a blast and I hope that someone finds something useful in the source.

Fuck it feels wierd to let this go after all this time.. 4 years and 4 months!

![image](https://user-images.githubusercontent.com/513842/171065610-8a16fc30-5e78-4df0-9c29-d70c8687876e.png)

---

#### Instructions 1
```
Hi bro.

First thing that you will want to do is to create your articles.
You have 20 pages, all these pages need to exist, even if some are
empty (such as articles).

To create the pages you should use notepad and save them as pure text.

Block ascii art still works fine.
Please do not have TABS, they will crash the mag.
Also you should not have double quotes " as these will also crash it.
You should search and replace those characters with something else.

Pages are a maximum of 80 characters wide and 2,000 lines tall.

You must end each page with the following;

<END>

It must be on the left of the screen and in capital letters.
This is very important as the mag will look for this code.

Colour codes like;

<RED> <GREEN> etc

and Page breaks like;

<H1> <H2> etc

Do not work any more. All text formatting is done within the text formatter.
Please see !_INSTRUCTIONS_2.TXT To learn how to use it.

Here are the pages and what they need to contain.

 p1.txt - Monthly Chart
 p2.txt - Monthly Overview
 p3.txt - Group Of The Month
 p4.txt - Group Release Stats
 p5.txt - Yearly Stats
 p6.txt - Yearly Overview
 p7.txt - Group Of The Year
 p8.txt - Alltime Stats
 p9.txt - Alltime Overview
p10.txt - Help                 (Chart usage instructions)
p11.txt - Editorial            (Your introduction)  
p12.txt - Rules                (The Chart Rules)
p13.txt - Credits              (Credits)
p14.txt - Feedback             (Letters to the editor if you will ;-) )
p15.txt - Music                (Your comments on this issues tunes)
p16.txt - Article 1            (General article / interview)
p17.txt - Article 2            (General article / interview)
p18.txt - Article 3            (General article / interview)
p19.txt - Article 4            (General article / interview)
p20.txt - Article 5            (General article / interview)

These are broken down into the correct categories in the mag so don't worry
about the order.

Even if you don't have an article, the page should exist. You can switch it
off in the configuration. See !_INSTRUCTIONS_3.TXT


Once you have written the 20 pages, just click on the file:

convert_pages.bat

This will overwrite any old pages you might have formatted!!
If you wish to preserve any of your old pages (like help for example)
copy the corresponding i file, so for help it is;

p10.txt == i10.txt

copy that somewhere safe, run the batch file and then replace the new with the
old one. This will preserve any text formatting you did to it and is a way
of saving your pages.

If some pages get corrupted, use the 

kill_converted_pages.bat

Batch file to remove all the iXX.txt files.

Pretty straight forward really.
So please write the pages and I'll see you in the next help file!
```

#### Instructions 2
```
So you made it to step 2 of the process.

Good!

This is where most of my work has been put in and I believe that you will find
it a lot easier to colour your articles now bro.

You should have already made your articles in notepad, the p1.txt , p2.txt etc.
The formatter needs something called "i files" to work.

You will have already generated them by clicking on :

convert_pages.bat

after this you will see 20 files that look like;

i1.txt
i2.txt

etc..

These are basically your pages which have been converted into a format that the
new chart engine can understand.

Remember the old codes?

<RED> <GREEN> <H1> <H2> Etc...

Well they don't exist any more. All text formatting is done by mouse from now on.
The formatter creates several layers that contain a map of each page.
One contains dividers, one contains colours, one contains font types and one contains
the actual text.

So you have the converted files, just double click on:

format_pages.bat

And be patient, this code to some extent is actually self-generating so you need to
wait while it builds and compiles its-self. Yeah I know it's a head fuck, this is one
reason why it has taken me so long, it was really difficult code. Maybe the most complex
thing I have ever written.

When it has built it's self you will see a nice mouse controlled menu.

Everything is controlled by mouse and is fairly self-explanitory. I will explain the
menu anyway as it has some really cool things!

-------------------------
**     THE TOP PART    **
-------------------------

Left click to select things.

QUIT + SAVE!  - Does what it says.

On the left is a box showing you some status information like;

The current Colour
The current Page divider
The current Font
The current Mode
The current Page.

This is for quick info so you can see what you have selected atm.

On the right of this you will see;

-LTTR-  -  Letter mode (Allows individual formatting of characters).
-WORD-  -  Word mode (Allows continuous words to be formatted at once).
-LINE-  -  Line mode (Allows whole lines to be formatted at once).
-LEFT-  -  Left mode (Everything to the left of the mouse is formatted at once.
-RIGT-  -  Right mode (As above but to the right of the mouse).

FONT 1  -  Select font 1
FONT 2  -  Select Font 2

------  - Page dividers (8 of them)

Colour bands, click on the colour to choose it.

<- PREV PAGE  - Go back a page.
NEXT PAGE ->  - Go forward a page.


Pretty simple eh?

One thing to note, if you change pages it will mean that you accept the word layout
this applies if you used the justify function. You wont be able to undo when you
go back so only change pages when you are happy with the layout.

----------------------------
**     THE BOTTOM PART    **
----------------------------


BK>
BK>
...

Left Click on any of these to insert the current page divider at that point.
Right click to remove the divider.

<JY
<JY
...

Left click to auto justify
Right click to revert back to how the page looked when you entered it.

When you move the mouse into the text area the border will light up.
Also you'll see a flashing hollow box, the size of the box depends on the
text mode, by left clicking, all characters in the box are formatted
with the current selections.

If you right click anywhere in the text window, those attributes are grabbed
to allow fast selection of colours / page dividers.

-----------------------------------------------------------------------------------

Saving your changes.
--------------------

When you leave the formatter, your changes will be saved so you dont have to
do the whole mag in one go.

If you convert the files again though, be careful because everything will be overwritten.
If you want to preserve formatted pages for future issues, after you have coloured them
you should copy them and store them somewhere safe.

you can just replace the i file with the preserved one just before you compile the
final version of the mag.

In all this is a lot more complicated than the last one but I feel it's easier to use
and will make a huge difference to the presentation of the mag.

```
  
#### Instructions 3
```
And now you are ready to make the final executable version of the charts, this is simple too.


You have your chosen music, please rename them to;

music1.xm
music2.xm
music3.xm
music4.xm

and put them inside this directory, they will be automatically included.

The mag only plays tracker songs, I will not be changing this to play sids right now to save you
hassle. The other format I am considering is Farbrausch v2, they will come in a future
version.

You MUST have 20 valid include files so if you have not edited and converted your pages yet then
don't try and compile it, it won't work ;-)

You will want to open "configuration.txt" now.

Change the issue number, type some scroll about the songs and select which pages are active
inside the mag and the title of the pages in the menu with this file.

When you are done, save the file and double click "COMPILE-CHART.bat"

And that will be it, job done. After some time the mag will compile its self into a single exe :)
Please be aware that it may take several minutes to compile!


I look forward to seeing it used bro.
I worked like crazy to get it all finished and simple for you to use.
```
