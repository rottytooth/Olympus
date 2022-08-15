# Olympus

A programming language whose virtual machine is Olympus. Instead of registers, we have a set of gods, each of which will do specific things for us if we ask them in the right way. Here is a Hello, World program:

## CONCEPT

We command machines as if they were are servants, and yet they often do not do what we want. Olympus is a new programming language which better reflects the actual power dynamic of programmer and machine.

When we bark orders at digital assistants (our Alexas and Siris), it does not bring out the best in us. We become masters to insolent machines that continually misunderstand us; they are personified, usually as female service workers, which makes our position as masters all the more uncomfortable. Were we to write code in this way, it would make things even worse, given the "complete and unambiguous explanation" required in code; the micro-managing necessary enhances the sense of condescension.

But what if we reversed that power dynamic? When we pray, we also make requests-- often equally petty -- only we do so with great solemnity and respect. The language Hellenic adopts this approach. To avoid any sense of micromanaging the gods, we make requests in small pieces, each accompnied with appropriate praise.

Zeus and Athena are great strategists, useful for command flow; Mnemosyne is the mistress of memory; we leave garbage collection to Hades. Zeus needs more praise than Athena, who is less likely to hold a grudge. Piss off one of the gods by asking for the unreasonable, and they might not follow any of our commands from that point on.

## BUILDING A PROGRAM

Each line of code is written as an invocation: a request to a god. The request is not to immediately carry out a task, but rather to create or append to a named function. The invocations need be ordered to not offend the gods, which may mean a single function might be described in non-contiguous invocations. It is best to keep functions very small; every loop or branching condition must be its own function so we can describe it in pieces.

An invocation has three parts: the god's name and adoration (praising of that god), supplication to show the humbleness of the asker, followed by a request to add one or several of what we ordinarily call "commands" to the program.

An invocation can ask for more than one command, but the right amount of adoration is required. A heavier ask requires more adoration, and some gods need more than others. Adoration comes in the form of epithets, phrases that celebrate that god such as "goddess who grants the gift of abundance" for Demeter or "well-honored in Thrace and in Scythia" for Ares. 

Do not ask the same god for two things in a row. Do not use the same epithets in a rote, repetitive way, and do not let any one god carry too much of the burden, else they may lose patience with you.

Anything with a name and no description is assumed to be a procedure (a function).

A check is a branching instruction. Its condition can be described separately and is always another function with a true/false return type. 

## GODS

* *Mnemosyne* is the mistress of memory. Anything dealing with assignment or declaring new variables goes to her.
* *Hades* collects the souls of abandoned variables. All variables in Olympus that have mutability (the non-eternals) and primitives must be freed at the end. It is customary (and a good safeguard) to call on Hades to free all variables at the end of a program.
* *Zeus* and *Athena* are the strategists. They deal with the structure of code. Since they are called on quite a lot, the programmer has two to call on. Athena needs less praise than Zeus, she is less egotistical. They are equally powerful.
* *Artemis* and *Demeter*, who rule over the cycles of nature, are the masters of looping structures and repetition. Loops—for or while—are theirs. Functional calls that are loop over a list (e.g. map and reduce) also go to them.
* *Ariadne*, mistress of the labyrinth and the serpent, deals with branching structures. That is “if,” “case,” “break,” and the calling of a function.
* *Hermes*, the bringer of dreams, is responsible for all random numbers. He is also the messenger of the gods, and deals with input and output. Like Ariadne, Hermes can make calls to functions. 
* *Aphrodite*, the goddess of desire and love, deals with currying. She helps a function spawn a child function (through currying). She also helps transform from the ideal plane into the physical world: any text can itself become code through her (eval).


## DESIGN CONSIDERATIONS

Hellenic looks at thematic languages of the ArnoldC sort and asks if we can go one step further and take the logic of that text into the 

Each piece is a lambda function. They need to be small. It is a LISP-like language, carried out in JS.

Hellenic multicodes between prayers and commands. But it is not an arbitrary multicoding, such as Piet . Instead, it is more like a thematic language, with 



INTERCAL gave us the compiler that responds to PLEASE. It was fickle, and would not carry out commands if we over-did it; the PLEASE had to be meaningful.

It is implemented using PEGJS and JavaScript. Some syntactic rules (such as excessive repetition of epithets) are beyond what can be checked in PEGJS and so are caught at runtime.


## SOURCES

* https://www.hellenicgods.org/prayer-in-hellenismos

* http://www.perseus.tufts.edu/hopper/

* https://www.theoi.com/Text/HomericHymns1.html

* Half-remembered episodes of *Xena: Warrior Princess*
