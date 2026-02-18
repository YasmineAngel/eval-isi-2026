## part I :
### Q1:
Yes because because in the initialization we need to enter the passwords for the legal and technical officers , and it also verifies the password when booting . in addition to the 2 usb keys we generated in init.sh we verify them when booting 
### Q2:
AES encryption algrithm in cbc mode
### Q3:
 No because in add.sh we encypt the data with cbc mode with the initialization vector we generated which makes it that the same info will have different encyption each time so we can't tell if 2 encypted card numbers are the same until we decrypt them .
## part II :
### Q4:
- we just have to add 1 or substract 1 to the $IVHEX of the entries ( we take advantage of the XOR): 
- Before : koki§1**2**5003319D454585557C8CD18BF7EEBA§TTS0AjAJ+zIYSwQ2510Hhg==./add.sh koki **5**23456789
- After : koki§1**1**5003319D454585557C8CD18BF7EEBA§TTS0AjAJ+zIYSwQ2510Hhg====./find.sh koki **6**23456789

- example 2 : 
- before : kiko§8**E**2195313851DD2D1A7CDE0A6CA9D80C§UmJ8zSnNKpIRfuo0ODycrA== ./add.sh kiko **5**23456789
- After : kiko§8**D**2195313851DD2D1A7CDE0A6CA9D80C§UmJ8zSnNKpIRfuo0ODycrA== ./find.sh kiko **6**23456789

### Q5 :
Yes , we can do it for the others as well : 
example : 
- before : yasmino§EC2**4**D18FAE772A78EA2D098140E30175§8vlnTbOP+G2dT86snyRnn1m5WV9lVyW1Pb+E2lwObuw=
 ./find.sh yasmino
1**3**34567891234567
- after : yasmino§EC2**5**D18FAE772A78EA2D098140E30175§8vlnTbOP+G2dT86snyRnn1m5WV9lVyW1Pb+E2lwObuw=
 ./find.sh yasmino
1**2**34567891234567

### Q6 : 
No because the IV is always bs=16 even if the card number has 17 digits e.g: 12345678912345678
seventeen§**331506D1A017A80FCC0AD51DD7F77055**§7n7SauwNoaBxHeP6JFYSPB8D3MI7JiI0WkVhncxyZ5Y
so if we modify the last bits it will change the 16th digit not the 17th .

## PART III :
### Q7 :
since he has access to the data.txt he can change his card number to that of a different user .
so whenever he purchases something from the merchnats website it wouldn't be his actual card that gets charged but the card of his victim .
### Q8 :
 the element that allows this to happen are the find.sh where we retrieve first card number based off the name and the add.sh that does not take into account if the card number already exists . and the data.txt not being encrypted ,easily accessible.
### Q9 :
the admin can determine this by finding 2 entries with same card number and 2 different names . 
## PART IV

### Q10 :
Reading the code can give help the attacker know how things work and it helps him find vulnerabilites in cour code that he might exploit but if we take the necessary security measures where we encrypt the data file , check if the card already exists before appending or not allowing the same number with different names , reboot the system or ask for passwords and keys each time we try to add an entry ,  or use salting and peppering with different information that only admins and officers can provide ,  it should be okay .

### Q11 :
if we repeat the name before the cyphered text like such name§ivhex§namebase64
The attacker can still use a different bank card since he only changes the ivhex part that allows him to obtain a new card number when decrypting , and this allows him to change his own card number and keep his same name .

### Q12 : 
If the attacker can see the code add.sh and access data.txt where he can see both the ivhex and its SHA-256 , there is no point in adding the SHA-256 . he can modify the ivhex , hash the new IV and put the new sha-256 in the entry accordingly .