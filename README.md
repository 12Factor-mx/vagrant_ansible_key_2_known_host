# Quick Description

## Use case

After creating and provisioning some boxes with Vagrant and Ansible the user test the guest machines using ansible or ansible-playbook (e.g., using ansible ping module) and gets a "fingerprint" error message.

![Alt text](img/fingerprint_error.png?raw=true "Title")

This mainly happens becasue the Vagrat boxes public ssh key does not exists in the user home know_hosts file.

## Tries to solve

Avoids the ansible or ansible-playbook "fingerprint" error message when the Vagrant boxes public ssh key does nor exists in the user home know_hosts file

## Description

This shell gives the user the ability to add and/or overwrite the Vagrants boxes public ssh key to the user home know_hosts file based on the autoganerated file vagrant_ansible_inventory.

For mor information the  please refer to the official documentation at <https://www.vagrantup.com/docs/provisioning/ansible_intro.html#the-inventory-file> 

## Prerequisites

 1. Bash shell (tested only with bash)
 2. A Vagrant project folder (VAGRANT_HOME) already initialized with:

    ```bash
    vagrant init
    ```
 3. A Vagrant project with a valid Vagrant file
 4. A Vagrant project folder (VAGRANT_HOME) already up and provisioned with:

    ```bash
    vagrant up
    ```

For more details take a look at <https://www.vagrantup.com/docs/index.html> on how to put up & running a Vagrant environment

## Install

Copy or download or clone this shell into your VAGRANT_HOME proyect

## Run

Start a Bash shell and cd into your VAGRANT_HOME project
Once there execute the shell as

```bash
./va_fp_2_kh.sh
```

## Enjoy '!'

Any comment, issue, or requirment are welcome at the github public repo <https://github.com/12Factor-mx/lazy-vagrant-ssh>

