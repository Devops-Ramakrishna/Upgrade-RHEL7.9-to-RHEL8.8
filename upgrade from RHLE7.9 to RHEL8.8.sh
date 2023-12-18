#! /bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo " script is started executing at $TIMESTAMP " &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 .... $R FAILED $N "
    else
        echo -e " $2 .... $G SUCCESS $N "
    fi
}

if [ $ID -ne 0 ]
then
    echo " $R ERROR : run this script with root user $N "
    exit 1 # you can give other than 0
else
    echo " you are root user "
fi # fi means reverse of fi, it indicating condition end

# pre-checks of BMHOST

UPDATE=$(yum update)

if [ $VERSION -ne 0 ]
then
    echo " $R ERROR : run this script with RHEL 7.9 VERSION upto date $N "
    exit 1 # you can give other than 0
else
    echo " you are RHEL 7.9 version up to date "
fi # fi means reverse of fi, it indicating condition end

ping www.google.com

VALIDATE $? " Googel is pingable "

if [ $? -ne 0 ]
then
    ping www.google.com
    VALIDATE $? " Google is pinging "
else
    echo -e " Google is already pingable $Y SKIPPING $N"
fi


VERSION=$(cat /etc/redhat-release)

VALIDAT $? " Red Hat Enterprise Linux Server release 7.9 (Maipo) "

if [ $VERSION -ne 0 ]
then
    echo " $R ERROR : run this script with RHEL 7.9 VERSION $N "
    exit 1 # you can give other than 0
else
    echo " you are RHEL 7.9 version "
fi # fi means reverse of fi, it indicating condition end


subscription-manager list --installed

VALIDATE $? " Status should be Subscribed "

# Set the Red Hat Subscription Manager to use the latest RHEL 7 content:

subscription-manager release --unset

VALIDATE $? " Use Latest RHEL7.9 "

# If you use the yum-plugin-versionlock plug-in to lock packages to a specific version, clear the lock by running:

yum versionlock clear

VALIDATE $? " To lock specific version RHEL7.9 "

# Update all packages to the latest RHEL 7 version:

UPDATE=$(yum update)

if [ $VERSION -ne 0 ]
then
    echo " $R ERROR : run this script with RHEL 7.9 VERSION upto date $N "
    exit 1 # you can give other than 0
else
    echo " you are RHEL 7.9 version up to date "
fi # fi means reverse of fi, it indicating condition end

# Install the Leapp utility:

yum install leapp-upgrade -y

if [ $? -ne 0 ]
then
    echo " ERROR : leapp-upgrade is not installed "
    exit 1
else
    echo " leapp-upgrade is installed successfully "
fi

# Procedure

# On your RHEL 7.9 system, perform the pre-upgrade phase:

leapp preupgrade --target 8.8

if [ $? -ne 0 ]
then
    echo " ERROR : Still Target version is RHRL 7.9 "
    exit 1
else
    echo " Target Version is RHEL 8.8 "
fi