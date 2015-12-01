FROM ubuntu:trusty
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/bin/java

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils wget git openssh-server sudo liberror-perl git build-essential autoconf libssl-dev python software-properties-common apt-transport-https && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server && \
    groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins && \
    add-apt-repository -y ppa:webupd8team/java && \
    add-apt-repository "deb https://dl.bintray.com/sbt/debian /" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \
    add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-trusty main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2C52609D && \
    echo 'deb https://deb.nodesource.com/node_0.10 trusty main' > /etc/apt/sources.list.d/nodesource.list && \
    echo 'deb-src https://deb.nodesource.com/node_0.10 trusty main' >> /etc/apt/sources.list.d/nodesource.list && \
    wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes oracle-java8-installer sbt docker-engine nodejs phantomjs && \
    update-java-alternatives -s java-8-oracle && \
    npm install -g npm@latest && \
    wget -qO /tmp/phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2 && \
    tar -xjvf /tmp/phantomjs.tar.bz2 --overwrite --strip-components=2 -C /usr/bin phantomjs-1.9.8-linux-x86_64/bin/phantomjs && \
    rm -f /tmp/phantomjs.tar.bz2 && \
    wget -qO /tmp/maven.tar.gz http://artfiles.org/apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn && \
    rm -f /tmp/maven.tar.gz && \
    mkdir /home/jenkins/{.ivy2,.m2,.sbt,workspace} && \
    chown -R jenkins.jenkins /home/jenkins/{.ivy2,.m2,.sbt,workspace}

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /home/jenkins/.ivy2
VOLUME /var/run/docker.sock

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
