FROM phusion/baseimage:latest
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive
ENV MAVEN_VERSION 3.3.9
ENV MONGODB_VERSION 3.2.10
ENV PHANTOMJS_VERSION 2.1.1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils wget git openssh-server sudo software-properties-common apt-transport-https && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    rm -rf /etc/service/sshd /etc/service/syslog-ng /etc/service/syslog-forwarder /etc/service/cron && \
    apt-get install -y --reinstall ca-certificates && \
    apt-get install -y python-pip && \
    pip install supervise && \
    pip install Flask && \
    dpkg-reconfigure openssh-server && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
RUN groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins && \
    mkdir /home/jenkins/.m2 /home/jenkins/workspace && \
    chown -R jenkins:jenkins /home/jenkins/.m2 /home/jenkins/workspace && \
    mkdir -p /etc/service/graylog-server /etc/service/mongodb && \
    mkdir -p /opt/graylog/data/journal /opt/graylog/assembly && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
RUN add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EEA14886 && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y --force-yes oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle && \
    rm -f /var/cache/oracle-jdk8-installer/jdk*.tar.gz && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
RUN add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-xenial main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2C52609D && \
    apt-get update && \
    apt-get install -y --force-yes docker-engine && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv D68FA50FEA312927 && \
    mkdir -p /data/db && \
    apt-get update && \
    apt-get install -y mongodb-org=${MONGODB_VERSION} mongodb-org-server=${MONGODB_VERSION} mongodb-org-shell=${MONGODB_VERSION} mongodb-org-mongos=${MONGODB_VERSION} mongodb-org-tools=${MONGODB_VERSION} && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
RUN wget -qO /tmp/maven.tar.gz http://artfiles.org/apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn && \
    rm -f /tmp/maven.tar.gz
RUN apt-get update && \
    apt-get install -y libfontconfig1 && \
    wget -qO /tmp/phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 && \
    mkdir -p /tmp/phantomjs && \
    tar -xf /tmp/phantomjs.tar.bz2 -C /tmp/phantomjs --strip-components=1 && \
    cp /tmp/phantomjs/bin/phantomjs /usr/local/bin/phantomjs && \
    chmod +x /usr/local/bin/phantomjs && \
    rm -rf /tmp/phantomjs /tmp/phantomjs.tar.bz2 && \
    apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ADD mongodb.run /etc/service/mongodb/run
ADD graylog-server.run /etc/service/graylog-server/run
ADD graylog.conf /opt/graylog/graylog.conf
ADD run.sh /opt/graylog/run.sh
ADD stop.sh /opt/graylog/stop.sh

RUN chmod +x /etc/service/mongodb/run /etc/service/graylog-server/run /opt/graylog/run.sh /opt/graylog/stop.sh

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /var/run/docker.sock

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
