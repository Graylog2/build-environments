FROM ubuntu:trusty
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV GO_VERSION 1.6.2

ENV DEBIAN_FRONTEND noninteractive
ENV GOROOT /opt/go
ENV GOPATH /go
ENV GO15VENDOREXPERIMENT 1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils openssh-server sudo build-essential autoconf libssl-dev software-properties-common apt-transport-https && \
    apt-get install -y --reinstall ca-certificates && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server && \
    groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins

RUN apt-get install -y wget git mercurial && \
    wget -qO /tmp/go.tar.gz https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -zxf /tmp/go.tar.gz -C /opt && \
    ln -s /opt/go/bin/* /usr/local/bin/ && \
    mkdir -p /go/src/github.com/Graylog2

RUN add-apt-repository -y ppa:masterminds/glide && \
    apt-get update -y && \
    apt-get install -y glide

RUN apt-get install -y ruby-dev rpm nsis && \
    gem install --no-rdoc --no-ri fpm-cookery

VOLUME /home/jenkins/workspace

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
