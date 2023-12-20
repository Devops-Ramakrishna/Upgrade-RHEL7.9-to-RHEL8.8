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

############# pre-checks of BMHOST ##################################################

# use absolute, because resolv.conf exists there

# Define the string to be searched
search_string="nameserver 8.8.8.8
nameserver 8.8.4.4"

# Define the file path
file_path="/etc/resolv.conf"

# Check if the string is present in the file
if ! grep -qF "$search_string" "$file_path"; then
    # If the string is not present, add it to the file
    echo -e "$search_string" >> "$file_path"
    echo "String added to the file"
else
    echo "String already present in the file"
fi

# Check if the string is present in the file
if ! grep -q "hosts: files myhostname" /etc/nsswitch.conf; then
    # If the string is not present, add it to the file
    echo "hosts: files myhostname" >> /etc/nsswitch.conf
else
    sed -i '/hosts:      files myhostname/s/$/ dns/'
    echo " Added the word in configuration file "
fi