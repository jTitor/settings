#!/bin/sh

#Builds and revalidates the local repo in preparation
#for a mbusd submit.
#Syntax is "buildAndValidate.sh -b [projects to build without testing] -t [projects to build and test]". Both flags are required and no duplicates are allowed.

#Setup colors.
kRed=`tput setaf 1`
kGreen=`tput setaf 2`
kBold=`tput bold`
kReset=`tput sgr0`

buildFlagPosition = -1
testFlagPosition = -1
buildProjects = ""
testProjects = ""

currFlagPosition = 0
buildFlagSet = false
testFlagSet = false
#Check that both flags are there.
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b|--build)
    buildFlagPosition = $currFlagPosition
    buildFlagSet = true
    ;;
    -t|--test)
    testFlagPosition = $currFlagPosition
    testFlagSet = true
    ;;
    *)
            #Unknown option; probably a value.
            aheadOfBuildFlag = ("$currFlagPosition" -gt "$buildFlagPosition") && ("$currFlagPosition" -ne "$buildFlagPosition")
            aheadOfTestFlag = ("$currFlagPosition" -gt "$testFlagPosition") && ("$currFlagPosition" -ne "$testFlagPosition")
            behindBuildFlag = ("$currFlagPosition" -lt "$buildFlagPosition") && ("$currFlagPosition" -ne "$buildFlagPosition")
            behindTestFlag = ("$currFlagPosition" -lt "$testFlagPosition") && ("$currFlagPosition" -ne "$testFlagPosition")
            buildFlagAheadOfTestFlag = ("$buildFlagPosition" -gt "$testFlagPosition") && ("$buildFlagPosition" -ne "$testFlagPosition")
            testFlagAheadOfBuildFlag = ("$buildFlagPosition" -lt "$testFlagPosition") && ("$buildFlagPosition" -ne "$testFlagPosition")
            #If this is ahead of the build flag but behind the test flag,
            #or this is ahead of the build flag and
            #the build flag is ahead of the test flag,
            #add this to the build list.
            if ($aheadOfBuildFlag && $behindTestFlag) || ($aheadOfBuildFlag && $buildFlagAheadOfTestFlag)
            then
				#Make sure the build flag actually is set.
				if ! $buildFlagSet
				then
					echo "${kRed}Can't add project ${key} to list of build projects! Build flag is in the wrong position!${kReset}"
				else
					#TODO: add to build projects array
					echo "${kRed}${kBold}Implement TODO: add to build projects array.${kReset}"
					exit
				fi
            fi
            #Else if this is ahead of the test flag but behind the build flag
            #or this is ahead of the test flag and
            #the test flag is ahead of the build flag, add it to the test list.
            #Make sure the test flag is actually set.
            if ($aheadOfTestFlag && $behindBuildFlag) || ($aheadOfTestFlag && $testFlagAheadOfBuildFlag)
            then
				if ! $testFlagSet
				then
					echo "${kRed}Can't add project ${key} to list of test projects! Test flag is in the wrong position!${kReset}"
				else
					#TODO: add to test projects array 
					echo "${kRed}${kBold}Implement TODO: add to test projects array.${kReset}"
					exit
				fi
            fi
    ;;
esac
shift #Go to next argument.
currFlagPosition = $currFlagPosition + 1
done

syntaxGood = $buildFlagSet && $testFlagSet
#If either flag is missing, print syntax and exit.
if ! $syntaxGood
then
	echo "Syntax: buildAndValidate.sh -b [projects to build without testing] -t [projects to build and test]"
	echo "Both flags are required and no duplicates are allowed."
	exit
fi

hasDuplicates = false
duplicates = ""

echo "${kRed}${kBold}Implement TODO: Check that -b and -t don't have any projects in common.${kReset}"
exit
#TODO: Check that -b and -t don't have any projects in common.
for b in $buildProjects; do
	for t in $testProjects; do
		if b == t
		then
			hasDuplicates = true
			#TODO: Add this duplicate to the duplicates list.
			echo "${kRed}${kBold}Implement TODO: add this duplicate to the duplicates list.${kReset}"
			exit
		fi
	done
done

#If they do, note the duplicates and exit.
if $hasDuplicates
then
	echo "Duplicate projects specified: ${duplicates}, aborting."
	exit
fi

#Build the projects.
echo "${kBold}Building projects...${kReset}"
if ! mbu build -d -m $buildProjects -c debug ship
then
	echo "${kRed}Build failed.${kReset}"
	exit
fi

#Test the projects.
echo "${kBold}Testing projects...${kReset}"
if ! mbu test -m $testProjects -c debug ship
then
	echo "${kRed}A test failed.${kReset}"
	exit
fi

#Now validate changes.
echo "${kBold}Build and test complete, validating changes...${kReset}"
if ! mbu validatechanges
then
	exit
fi

echo "${kGreen}Changes validated, ready to submit!${kReset}"