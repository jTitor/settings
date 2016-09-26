#!/bin/bash
#Setup colors.
kRed=`tput setaf 1`
kGreen=`tput setaf 2`
kBold=`tput bold`
kReset=`tput sgr0`

if ! kinit mileun@NORTHAMERICA.CORP.MICROSOFT.COM
then
	echo "${kRed}Kerberos login failed, aborting.${kReset}"
	exit
fi

echo "${kBold}Updating local sources...${kReset}"
if ! mbusd update
then
	#mbusd update doesn't report success
	#if any files had to be merged; run it again in that case.
	if ! mbusd update
	then
		echo "${kRed}Update failed, aborting.${kReset}"
		exit
	fi
fi

echo "${kBold}Resolving conflicts...${kReset}"
if ! sd resolve
then
	echo "${kRed}Resolve failed.${kReset}"
	exit
fi

echo "${kGreen}Morning startup complete!${kReset}"