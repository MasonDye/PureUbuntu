#!/bin/bash

sleep 2
export HOME=/home/container
cd /home/container
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`

# Set root&container user password to server uuid
echo "root:$(hostname)" | chpasswd
echo "container:$(hostname)" | chpasswd

# Provide the Docker internal IP address to the process for usage.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

echo -e "\e[32m[Server] ------------\e[0m"
# Print Docker container uuid
echo -e "\n\e[32m[Server] UUID: $(hostname)\e[0m"
echo -e "\e[32m[Server] ------------\e[0m"

# check start.sh exists
if [ -f "/home/container/start.sh" ]; then
  echo -e "\e[32m[Server] start.sh exist, skip.\e[0m"
else
  echo -e "\e[31m[Server] create & write start.sh\e[0m"
  # if not exist create & write start.sh
start_sh=$(cat <<'EOF'
#!/bin/bash

####################
### START SCRIPT ### 
####################

# !!!!!!!!!!!!!!!!!!!!
# Root,container User password is server uuid
# !!!!!!!!!!!!!!!!!!!!

bash

EOF
)
echo "$start_sh" > "/home/container/start.sh"
chmod +x /home/container/start.sh
fi

# check README.TXT exists
if [ -f "/home/container/README.TXT" ]; then
  echo -e "\e[32m[Server] README.TXT exist, skip.\e[0m"
else
  echo -e "\e[31m[Server] create & write README.TXT\e[0m"
  # if not exist create & write README.TXT
README_MD=$(cat <<'EOF'
####################
### README FILE ###
####################

!#!#!#!#!#!#!#!#!#!
Root,container User password is server uuid
!#!#!#!#!#!#!#!#!#!


####################
###### Notice ######
####################
1. After the prompt "[Server] Server has started," you can directly use the command.
2. Attention! After rebooting, all locations except for the user directory (/home/container) will be reset! This means programs installed via apt will also be reset. This is unavoidable, so don't expect to fix this issue.

####################
####### Safe #######
####################
Change root/container(safe user) password
（Enter on Root user）
passwd root & passwd container


####################
####### More #######
####################

############
# Install SSH-Server #
############
(This is bash script, run this script use root user and give permissions "chmod +x ssh.sh")
(!!! MAKE SURE TO REPLACE PORT !!!)
(REPLACE [PORT])
############

#!/bin/bash
# Install SSH-Server
echo -e "\e[32m[Server] Installing SSH-Server ....\e[0m"
apt-get update
apt-get install -y openssh-server
sed -i 's/#Port 22/Port [PORT]/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
service ssh restart
echo -e "\e[32m[Server] Done.\e[0m"


####################################
##### Replace Software Source #####
####################################
(Use AlmondCloud Source)
(run on Root user)
############

sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.almondcloud.cn/ubuntu/|' /etc/apt/sources.list
sed -i 's|http://security.ubuntu.com/ubuntu/|https://mirrors.almondcloud.cn/ubuntu-security|' /etc/apt/sources.list
apt-get update

####################


####################
© AlmondNetwork. All rights reserved
####################

EOF
)
echo "$README_MD" > "/home/container/README.TXT"
fi

# Start server prompt
echo -e "\n\e[32m[Server] Server has started\e[0m"
echo -e "\e[32m[Server] ------------\e[0m"
echo -e "\n\e[32m[Server] Enter command\e[0m"
echo -e "\e[32m[Server] ------------\e[0m"
bash ./start.sh
