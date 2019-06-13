FROM node:10-stretch-slim

MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV YARN_VERSION 1.12.3

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y openssh-server sudo apt-utils software-properties-common apt-transport-https && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server && \
    groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins && \
    mkdir /home/jenkins/workspace && \
    chown -R jenkins:jenkins /home/jenkins/workspace

RUN apt-get install -y wget git

RUN npm install -g yarn@$YARN_VERSION

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
