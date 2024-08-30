#Overview#
Herein lies a selection of Ansible playbooks to manage Windows systems

##Notes##
- The example inventory uses the ansible_host variable to target the machine. If the host is in DNS you can use the FQDN as the entry name and bypass that variable.
- The used to login is set in the vars for the server, can also be set in the config file.
- A password needs to be specified when logging into the host. This can be added to a config or an environment variable if not wanting to be asked for creds on each run. 
  It can be specified on the command line however this risks the password being entered into the user history, depending on whether you have ignore leading spaces configured.
- Uses a variable "required_hosts" to limit the scope of the actions taken, can set to "all" to target all hosts in the inventory
- Any example with text inside "<>" is user input, replace this with your required text, ie "required_hosts=<required selection>" => "required_hosts=all"



#misc scripts#
##windows_ansible_setup##
A powershell script to be run on the Windows instance you want to control. **Requires an administrative powershell prompt to run.**
- Enables WinRM which Ansible will use to interact with the Windows OS
- Creates a local user, default is "ftlc" ( An Ansible . The variable is near the top of the file
- Sets a default password for the user. The variable for this is near the top of the file
- Adds the new user to the local administrators group so that it's able to do the do 

###Notes###
In order to run you'll need to bypass the execution policy. The command is available at the top of the script:
powershell.exe -ExecutionPolicy ByPass -File windows_ansible_setup.ps1


##windows_connectivity_check##
Similar to a standard Ansible "ping". Checks to see if Ansible can connect to the remote host using the supplied credentials

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> windows_connectivity_check.yml


*User management*
##check_users##
Uses an ad-hoc powershell command to list users
###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/check_users.yml


##create_user##
Creates a user
- Asks for a username during run
- Asks for password during run

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/create_user.yml


##remove_user##
Removes the specified user
- Asks for the username during usage

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/remove_user.yml


##enable_user##
Enables a user
- Asks for a username during run

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/enable_user.yml


##disable_user##
Disables a user
- Asks for a username during run

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/disable_user.yml


##change_user_password##
Allows you to change a users password
- Asks for a username during run
- Asks for password during run

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/change_user_password.yml


##remove_user_password_expiry##
Removes the password expiry for the user

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> user_accounts/remove_user_password_expiry.yml


#Windows update#
##check_for_updates##
Checks to see what updates are available

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> windows_update/check_for_updates.yml

##windows_update_download_only##
Downloads available updates ready for installation

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> windows_update/windows_update_download_only.yml

##windows_update_all##
updates windows. Can reboot the system if desired but by default the variable is set to false

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> windows_update/windows_update_all.yml

##windows_update_pick_your_own##
Only install patches of the specific type selected / left uncommented. Useful if only wanting to install security related patches etc.

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> windows_update/windows_update_pick_your_own.yml

##windows_update_specific_kb##
Only install the specific KB update
- specify the KB with -e required_update=<KBxxxxxxxx>

###Usage###
ansible-playbook -i example_inventory.yml --ask-pass -e required_hosts=<required selection> -e required_update=<KBxxxxxxxx> windows_update/windows_update_specific_kb.yml

