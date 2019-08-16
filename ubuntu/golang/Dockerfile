FROM ubuntu:bionic
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV GO_VERSION 1.11.13

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/bin/java
ENV GOROOT /opt/go
ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y openssh-server sudo apt-utils software-properties-common apt-transport-https openjdk-8-jre-headless && \
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

RUN apt-get install -y wget curl unzip git mercurial build-essential autoconf libssl-dev jq && \
    wget -qO /tmp/go.tar.gz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -zxf /tmp/go.tar.gz -C /opt && \
    ln -s /opt/go/bin/* /usr/local/bin/ && \
    mkdir -p /go/src/github.com/Graylog2 && \
    chown -R jenkins:jenkins /opt/go/pkg && \
    chown -R jenkins:jenkins /go

RUN apt-get install -y golang-glide

RUN apt-get install -y binutils-mingw-w64 gcc-mingw-w64 rpm nsis

RUN apt-get -y install ruby libruby libffi-dev ruby-dev build-essential

RUN ruby -S gem install --no-rdoc --no-ri fpm-cookery

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
