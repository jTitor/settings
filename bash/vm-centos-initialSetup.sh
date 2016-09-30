#!/bin/bash
#Setup colors.
kRed=`tput setaf 1`
kGreen=`tput setaf 2`
kBold=`tput bold`
kReset=`tput sgr0`

echo "${kBold}Updating repositories...${kReset}"
if ! [[yum -y update]]; then
	echo "${kRed}Update failed, aborting.${kReset}"
	exit
fi

#Install Docker.
echo "${kBold}Installing Docker...${kReset}"
if ! [[yum -y install docker]]; then
	echo "${kRed}Docker install failed.${kReset}"
	exit
fi

#Install xfce.
echo "${kBold}Installing xfce...${kReset}"
if ! [[yum -y install epel-release && yum -y groupinstall xfce]]; then
	echo "${kRed}xfce install failed.${kReset}"
	exit
fi

echo "${kGreen}Initial setup complete!${kReset}"