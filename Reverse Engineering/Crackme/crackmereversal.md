Reversing the crackme using radare2 tool.
The crackme was got from crackme.one [Link](https://crackmes.one/crackme/6ab4ce5195b976f8f1300b54)
The crackme is a program that asks for a password.
Run it with :
```bash 
	./wheredakey
```
When the wrong password is entered it prints : "Nuh uh, Study more bruh"
When the password is right it prints: "Nice bruh you got it"
There are two possible ways that the password is validated
(i) The password is stored in the binary file
(ii) The password is derived or transformed at runtime
To determine which of the two price does I will look  for:
a. The strings in radare2 with `izz`

Since the strings output do not the password there I will now look at the assembly to see the logic at which price does the comparison between the entered value and the  correct password.
```
	pdf
```
![](../imaes/image4.png)
From the output above It is evident that the binary has strings stored in it and at each runtime the strings are combined to form the password.
For the password to be constant at each runtime then the combination of the strings shoulld be a constant chain and determining the chain in which the strings are combined then  it would be easier to get the password.
The actual strings we are looking for are : 
- Bash
- Qc3f
- fZ1
- 6AjD701x
- x00
From the disassembly the x00 is not used anywhere thus the string combination is the 3 strings.

## Step 1: Initial Recon
```bash
	file ./wheredakey
```
![](../images/image1.png)

```bash
	checksum file=wheredakey
```
![](../images/image2.png)

``` bash 
	r2  wheredakey
```
Inside R2 run:
```
	aaa
	il
	afl		#inspect functions
```
When analyzing the function I am supposed to be looking for functions such as main, validation routines or suspiciously named/unnamed functions.
A validation routine is a piece of code whose job is to check whether some input satisfies expected conditions before the program uses it
![](../images/image3.png)
From the output there is a main function and the entry pont .That is what am looking for next.

## Step 2: Inspecting main
![](../imags/image4.png)
From the output the focus goes to the scanf part and to get to know the actual content of the s1 s2 and var_6b - the h in var_6bh is r2 ways of indicating the hexadecimal offset.
```
	px/s @ s1
	px/s @ s2
	px/s @ var_6b
```
