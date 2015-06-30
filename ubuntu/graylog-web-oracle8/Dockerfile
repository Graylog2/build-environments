FROM ubuntu:trusty
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils curl wget unzip git liberror-perl git build-essential autoconf libssl-dev python

RUN apt-get install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server

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
    npm install -g npm@latest && \
    apt-get install -y phantomjs && \
    wget -O /tmp/phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
    tar -xjvf /tmp/phantomjs.tar.bz2 --overwrite --strip-components=2 -C /usr/bin phantomjs-1.9.8-linux-x86_64/bin/phantomjs && \
    rm -f /tmp/phantomjs.tar.bz2 && \
    add-apt-repository "deb http://dl.bintray.com/sbt/debian /" && \
    apt-get update && \
    apt-get install -y --force-yes sbt

RUN mkdir /home/jenkins/workspace
RUN mkdir /home/jenkins/.m2
RUN mkdir /home/jenkins/.ivy2
RUN chown -R jenkins.jenkins /home/jenkins/workspace /home/jenkins/.m2 /home/jenkins/.ivy2

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /home/jenkins/.ivy2

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
