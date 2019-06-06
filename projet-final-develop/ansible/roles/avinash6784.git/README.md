# Ansible Role: Git [Ansible Playbook Role To Install Git]

Install Git, a distributed version control system, on any RHEL/CentOS Linux system.

## Requirements

None.

## Role Variables
None

## Dependencies

None.

## Usage and Example Playbook

Install from Ansible Galaxy

$ ansible-galaxy install avinash6784.git
Or download manually

$ git clone https://github.com/avinash6784/ansible-git.git 
The code should reside in the roles directory of ansible ( See ansible documentation for more information on roles ), in a folder git.

## Run the playbook

First create a playbook including the git role, naming it git.yml.
```yml
- name: Git
  hosts: git
  become: true
  roles:
    - ansible-git
    
$ ansible-playbook -i hosts git.yml
```

## Author Informations

This role was created by [Avinash Pawar](https://github.com/avinash6784/ansible-git).
