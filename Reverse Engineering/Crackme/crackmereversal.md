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
Concatenating the above gives the correct password in order of arrangement 
Password: BashQc3fZ16AjD701x0O
