FROM ubuntu:trusty
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV GO_VERSION 1.6.2

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/bin/java
ENV GOROOT /opt/go
ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1

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
    add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EEA14886 && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle

RUN apt-get install -y wget curl unzip git mercurial build-essential autoconf libssl-dev && \
    wget -qO /tmp/go.tar.gz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -zxf /tmp/go.tar.gz -C /opt && \
    ln -s /opt/go/bin/* /usr/local/bin/ && \
    mkdir -p /go/src/github.com/Graylog2 && \
    chown -R jenkins:jenkins /opt/go/pkg && \
    chown -R jenkins:jenkins /go

RUN add-apt-repository -y ppa:masterminds/glide && \
    apt-get update -y && \
    apt-get install -y glide

RUN apt-get install -y ruby-dev rpm nsis && \
    gem install --no-rdoc --no-ri fpm-cookery

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
