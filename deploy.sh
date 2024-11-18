#!/bin/bash

# Start ssh-agent and add the key
echo "Starting ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add assets/rsa

# Define the VM using virsh
sudo virsh define assets/vm.xml

# Start the VM
sudo virsh start immfly-debian10

# Wait for the VM to boot and get an IP address
echo "Waiting for VM to get an IP address..."
sleep 30  # Ensure the VM has time to get IP address

# Ansible Docker run
echo "Deploying services using Ansible..."
docker build -t ansible-docker .
docker run --network host --rm \
  -v $(pwd):/ansible \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  -e BACKEND_PORT -e LOG_LEVEL \
  ansible-docker /ansible/playbooks/deploy.yml

echo "Stopping ssh-agent..."
eval "$(ssh-agent -k)"
