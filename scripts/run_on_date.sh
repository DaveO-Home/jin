#!/usr/bin/sh
#
# Script will compile the main TestIt script first before executing,
# if the entered date(mm/dd/yyyy) is greater than the current date and hour.
#
checkDate=0
if [ -z $1 ] ; then
   checkDate=$(date -d "01/01/2018" '+%s');
   else
   	checkDate=$(date -d $1 '+%s')
fi

now=$(date +%s)

if [ $checkDate -gt $now ] ; then
    #Compile the script only
    $(./TestIt cp=true);
fi
#Load and run the class
../bin/jlin my.jsc.scripts.TestIt lr=true;

