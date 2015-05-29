FROM ubuntu:trusty
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils curl wget unzip git liberror-perl git build-essential autoconf libssl-dev python

RUN apt-get install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

RUN groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins
RUN echo "jenkins:jenkins" | chpasswd

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle && \
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/bin/java && \
    curl -sL https://deb.nodesource.com/setup | sudo bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    npm install -g npm@2.1.18 && \
    wget http://downloads.typesafe.com/typesafe-activator/1.2.10/typesafe-activator-1.2.10-minimal.zip && \
    unzip typesafe-activator-1.2.10-minimal.zip && \
    mv activator-1.2.10-minimal /usr/local/activator && \
    chmod a+x /usr/local/activator/activator && \
    ln -s /usr/local/activator/activator /usr/local/bin/ && \
    apt-get install -y phantomjs && \
    add-apt-repository "deb http://dl.bintray.com/sbt/debian /" && \
    apt-get update && \
    apt-get install -y --force-yes sbt

RUN mkdir /workspace
VOLUME /workspace
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
