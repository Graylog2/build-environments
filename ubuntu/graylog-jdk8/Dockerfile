FROM ubuntu:trusty
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/bin/java
ENV MAVEN_VERSION 3.5.4

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils wget git openssh-server sudo liberror-perl git build-essential autoconf libssl-dev python software-properties-common apt-transport-https rpm && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server && \
    groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins && \
    apt-get install -y --reinstall ca-certificates && \
    add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EEA14886 && \
    add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-trusty main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2C52609D && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes oracle-java8-installer docker-engine && \
    update-java-alternatives -s java-8-oracle && \
    wget -qO /tmp/maven.tar.gz http://artfiles.org/apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn && \
    rm -f /tmp/maven.tar.gz && \
    mkdir /home/jenkins/{.ivy2,.m2,.sbt,workspace} && \
    chown -R jenkins.jenkins /home/jenkins/{.ivy2,.m2,.sbt,workspace}

RUN apt-get install -y libfontconfig1
COPY phantomjs /usr/local/bin/
RUN chmod +x /usr/local/bin/phantomjs

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /home/jenkins/.ivy2
VOLUME /var/run/docker.sock

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
