FROM ubuntu:trusty
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive

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

RUN apt-get install -y --reinstall ca-certificates && \
    apt-get install -y wget curl unzip git mercurial build-essential autoconf libssl-dev && \
    apt-get install -y ruby2.0 ruby2.0-dev && \
    gem2.0 install --no-rdoc --no-ri bundler && \
    gem2.0 install --no-rdoc --no-ri omnibus && \
    gem2.0 install --no-rdoc --no-ri docker-api

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
