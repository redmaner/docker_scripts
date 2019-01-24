#!/bin/bash

user=admin

# Colors
txtrst='\e[0m' # Color off
txtblu='\e[1;36m' # Blue

# Do some cleaning
echo -e "\n${txtblu}Cleaning up some stuff${txtrst}"
echo > /etc/motd
userdel debian

sudo su

# Password for root
echo -e "\n${txtblu}Please enter the password for the root user${txtrst}"
passwd

rm /etc/sudoers.d/90-cloud-init-users

# Creat user password
echo -e "\n${txtblu}Pleas enter password${txtrst}: $user"
passwd $user

# Installing required packages
echo -e "\n${txtblu}Installing packages${txtrst}"
apt-get update
apt-get upgrade -y
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     git \
     vim \
     zip \
     unzip \
     libcap2-bin

echo -e "\n${txtblu}Patching sshd config${txtrst}"
cat > /etc/ssh/sshd_config << EOF
Port 2100
Protocol 2

# Logging
LogLevel VERBOSE

# Authentication:

#LoginGraceTime 2m
PermitRootLogin no
#StrictModes yes
#MaxAuthTries 6
MaxSessions 3

PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
PermitEmptyPasswords no

# Change to no to disable s/key passwords
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
UsePAM yes

AllowAgentForwarding no
AllowTcpForwarding no
#GatewayPorts no
X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no # pam does that
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
Banner none

# override default of no subsystems
Subsystem	sftp	internal-sftp
EOF

systemctl restart sshd

echo -e "\n${txtblu}Please add $user to sudoers in 5 seconds${txtrst}"
sleep 5
export EDITOR=vim
visudo
