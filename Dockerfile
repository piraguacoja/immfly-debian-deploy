FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible python3-pip openssh-client docker.io && \
    apt-get clean

WORKDIR /ansible

# Ensure the entire content of the directory is copied.
COPY . /ansible/

ENTRYPOINT ["ansible-playbook"]
