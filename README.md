#RECOVER NETCOOL PASSWORD UTILITY
#recover_netcool_passwd.pl

##OBJECTIVE: Perl utility to recover IBM Tivoli Netcool ObjectServer password via systematic brute force.

##BACKGROUND
I was inspired to write *recover_netcool_passwd.pl* in response to there not being a process for recovering IBM Tivoli Netcool user passwords. Netcool is an enterprise level fault management tool used primarily by large companies to actively monitor and resolve network fault and performance issues. Finding that there was a pattern in the encrypted passwords used by the application, I quickly wrote a script that could recover any length alphanumeric password. Hopefully it will save network management systems (NMS) administrator’s potentially large amounts of time in recovering passwords that would otherwise require application reinstalls and/or significant reconfiguration.

##HIGH LEVEL LOGIC FLOW
1. Create array of all letters in alphabet and numbers 0-9 
2. Parse the password into blocks of two characters and store in array 
3. Traverse the array, encrypting one character at a time
4. Compare encrypted character to encrypted password
5. If the encrypted character matches the encrypted password, then store and move on to next character unless then end of the encrypted password has been met.

##PREREQUISITES
* Perl interpreter
* IBM Tivoli Netcool installed on local system where script is run

##INSTALLATION
There’s none. Just run the script!

##USAGE
When prompted, enter the encrypted Netcool user password to be recovered.

##AUTHOR: Rutger Thomschutz
