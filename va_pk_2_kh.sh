#!/bin/bash

# Defines terminal color escape sequence for 
# catching better atention of the user
BLACK='\033[30;30m'    
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'     
LIGHT_RED='\033[1;31m'
GREEN='\033[0;32m'     
LIGHT_GREEN='\033[1;32m'
BROWN_ORANGE='\033[0;33m'     
YELLOW='\033[1;33m'
BLUE='\033[0;34m'     
LIGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'     
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'     
LIGHT_CYAN='\033[1;36m'
LIGHT_GRAY='\033[0;37m'     
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function for printing the welcome message to the user
say_hello()
{
  echo -e "${LIGHT_GREEN}"
  echo -e "----------------------------------------------"
  echo -e "-     Vagrant/Ansible key to known_host      -"
  echo -e "-                                            -"
  echo -e "-Adds the Vagrant/Ansible machines public key-" 
  echo -e "- ssh key to your ~/.ssh/known_host from the -"
  echo -e "-    vagrant_ansible_inventory info          -"
  echo -e "-                                            -"
  echo -e "-        Miguel Jesús Díaz Macedo            -"
  echo -e "-         webmaster@12factor.mx              -"
  echo -e "-                                            -"
  echo -e "-    The source code of this tool is at      -"
  echo -e "-${YELLOW}      https://github.com/12Factor-mx${LIGHT_GREEN}        -"
  echo -e "-                                            -"
  echo -e "-          Enjoy as much as I did!           -"
  echo -e "----------------------------------------------${NC}"
}

# Function for printing the farewell message to the user
say_bye()
{
  echo -e "${LIGHT_GREEN}"
  echo -e "Thanks for using this tool." 
  echo -e "Comments welcome at ${LIGHT_BLUE}webmaster@12factor.mx ${LIGHT_GREEN}and"
  echo -e "don't forget to visit ${YELLOW}www.12factor.mx"
  echo -e "${LIGHT_GREEN}The source code of this tool is at ${LIGHT_PURPLE}https://github.com/12Factor-mx"
  echo -e "${NC}"
}

# Function for printing a sort of error message to the user
# in case the .vagarant folder is empty or does not exists
say_no_ansible_inventory()
{
  echo -e "${NC}"
  echo -e "${RED}Sorry but no ansible inventory found."
  echo -e "Have you tried Vagrant init or Vagrant up?${NC}"
}

# Caugth temination signal <ctrl-c> and prints the
# shell cancelation intend message
trap 'echo -e "${NC}"; 
      echo -e "\n${BLUE}Ok, you are the Boss! quiting because a ^C was been issued...${NC}"; 
      say_bye; 
      exit'  SIGINT SIGTERM

say_hello

# Assumes this shell runs in the VAGRANT_HOME directory
if [[ -z "${VAGRANT_HOME}" ]]; then
  VAGRANT_HOME="." 
fi

# Register the inventory existance
vagrant_ansible_inventory=$(ls ${VAGRANT_HOME}/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory)

# If Vagrant Ansible Inventory file does exits 
# say goodbye and quit 
if [[ -z $vagrant_ansible_inventory ]]; then
  say_no_ansible_inventory
  say_bye
  exit
fi

# hosts counter
let "i=1"

# If Ansible inventory exists for each host parses the ssh host ip and port
while read -r line ; do
    # Gets the hostname
    hostname=$(echo $line | cut -d' ' -f1)
    # Gets the ip
    ip=$(echo $line | grep -Pom 1 '[0-9.]{7,15}')
    # Gets the port
    port=$(echo $line | grep -Pom 1 '[0-9]{4,4}')
    # Informs user
    echo -e " "
    echo -e  "${GREEN}$i) SSH connection information found as ${YELLOW}[$ip]:$port${GREEN} for host ${BLUE}$hostname${NC}"
    # In case a public ssh key exists erase it to avoid duplicates
    ssh-keygen -R "[$ip]:$port"  
    # Add the correspondig public ssh key to the ~/.ssh/known_hosts file
    ssh-keyscan -p $port $ip >> ~/.ssh/known_hosts 

    ((i++))
done < <(grep ansible_host= ${VAGRANT_HOME}/.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory)

echo -e " "
echo -e "${GREEN}If all is ok the following Ansible Ping Moudule execution must succeed. Assumes ansible is installed ${NC}"
echo -e " "

ansible all -o -i ${VAGRANT_HOME}/.vagrant/provisioners/ansible/ -m ping

# We are done, thanks!
say_bye