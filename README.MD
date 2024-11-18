## 1. Deploy the IMG + vm.xml
# Modifying vm.xml file 

<source file='/var/lib/libvirt/images/debian10-ssh.img'/>

# Enable Boot

<bootmenu enable='yes'/>

# Enable Console 

<serial type='pty'>
    <target port='0'/>
  </serial>
  <console type='pty'>
    <target type='serial' port='0'/>
  </console>


# Define the VM 

virsh define vm.xml

# Start the VM 

sudo virsh start immfly-debian10

# Check Networks 

sudo virsh net-list --all
sudo virsh net-start default

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

# IPTABLES rule for VM internet access
sudo iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -o wlo01 -j MASQUERADE

# Forwarding rules
sudo iptables -A FORWARD -s 192.168.122.0/24 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.122.0/24 -j ACCEPT

# Restart libvirt and networking services
sudo systemctl restart networking
sudo systemctl restart libvirtd

# Deploy VM

./deploy.sh 


## 2. How to run PlayBooks 

docker run --network host --rm \
  -v $(pwd):/ansible \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e BACKEND_PORT -e LOG_LEVEL \
  ansible-docker /ansible/playbooks/deploy.yml
