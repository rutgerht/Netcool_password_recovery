#!/usr/bin/perl
#################################################################################
# recover_netcool_passwd.pl
# Date: 20120109
# Author: Rutger Thomschutz
# Objective: Perl application to recover Netcool ObjectServer password via
# 	 systematic brute force.
# Usage: When prompted, enter the encrypted Netcool user password to be
#        recovered.
# Logic: 1. Create array of all letters in alphabet and numbers 0-9 
#	 2. Parse the password into blocks of two characters and store in array 
# 	 3. Traverse the array, encrypting one character at a time
# 	 4. Compare encrypted character to encrypted password
# 	 5. If the encrypted character matches the encrypted password, then store
# 	 and move on to next character unless then end of the encrypted password
# 	 has been met.
# Dependencies: IBM Tivoli Netcool installed on local system where script is run.
#
#################################################################################

use strict;
use warnings;

my $nco_sql_crypt = '/opt/IBM/tivoli/netcool/omnibus/bin/nco_sql_crypt'; # Default full path to Netcool 7.2+ encryption tool
my @letters = ("a" .. "z");
my @nums = (0 .. 9);
my @chars = (@letters, @nums); # Step 1: Create Array of all letters in alphabet and numbers 0-9 

# Prompt user to input encrypted password
print "Enter Netcool password: ";
my $passwd = <STDIN>; 
print "Recovering password ...\n";
#my $passwd = 'EIEDBIBHFLBKCK'; # For testing. Encrypted form of password 'test123'.
my @en_passwd = $passwd =~ m/(\w{2})/g; # Step 2: Parse the password into blocks of two characters and store in array

# Initialize variables
my $un_passwd_maybe='';
my $crkd_passwd='';
my $i=0;
my $en_passwd=$en_passwd[$i];
my $passwd_len = 0;

#################################################################################
# Main body of application 
#################################################################################
# The while loop calls subroutine recover_passwd a number 
# equal to the length of the encrypted user password
while ($passwd_len < @en_passwd) {
	&recover_passwd;
	$passwd_len++;
}

#################################################################################
# SUBROUTINES
#################################################################################
# recover_passwd - tests if an encrypted alphanumeric string matches part of the 
# encrypted password. If a match is found, it breaks out of the loop and proceeds
# by recovering the next encrypted character.   
#################################################################################
sub recover_passwd {
	chomp $en_passwd;
	foreach my $char (@chars) {
		$un_passwd_maybe = $crkd_passwd eq '' ? $char : $crkd_passwd . $char;
		my $en_passwd_maybe = `$nco_sql_crypt $un_passwd_maybe`; # Step 3: Traverse the array, encrypting one character at a time
		chomp $en_passwd_maybe;
		if ($en_passwd_maybe eq $en_passwd) { # Step 4: Compare encrypted character to encrypted password
			$i++;
			$en_passwd = $en_passwd . $en_passwd[$i];
			# Step 5: Encrypted character matched part of the encrypted password. 
			# Store the unencrypted portion into variable $crkd_passwd
			$crkd_passwd = $crkd_passwd . $char; 
			print "un_passwd_maybe=$un_passwd_maybe\n";
			last;
		}	       
	}
}

# Print recovered password to screen
print "\n\n";
print "Password recovered: $un_passwd_maybe\n";
# eof
