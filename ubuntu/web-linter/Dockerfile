FROM node:10-stretch-slim

MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV YARN_VERSION 1.12.3

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y openssh-server sudo apt-utils software-properties-common apt-transport-https wget git && \
    apt-get clean && \
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

# Fix issue with openjdk-8-jre-headless installation post scripts. Needs to
# run before the JRE is installed.
RUN mkdir -p /usr/share/man/man1

# We need a JDK for the Jenkins agent. Otherwise Jenkins would upload a
# complete JDK every time the container runs.
RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless && \
    apt-get clean

RUN npm install -g yarn@$YARN_VERSION

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
