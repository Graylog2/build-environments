FROM debian:7.8
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y apt-utils

RUN apt-get install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

RUN apt-get install -y openjdk-7-jdk
RUN groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins
RUN echo "jenkins:jenkins" | chpasswd

RUN apt-get install -y sudo && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins

RUN apt-get install -y curl git build-essential && \
    apt-get install -y ruby1.9.1-full
RUN gem install --no-rdoc --no-ri bundler
RUN mkdir /workspace

VOLUME /workspace
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
