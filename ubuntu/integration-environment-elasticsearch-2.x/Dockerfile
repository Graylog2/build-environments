FROM phusion/baseimage:latest
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive
ENV MAVEN_VERSION 3.3.9
ENV MONGODB_VERSION 3.0.8
ENV ELASTICSEARCH_VERSION 2.2.0

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils wget git openssh-server sudo software-properties-common apt-transport-https && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server && \
    groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins && \
    echo "jenkins:jenkins" | chpasswd && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins && \
    apt-get install -y python-pip && \
    pip install supervise && \
    pip install Flask && \
    rm -rf /etc/service/sshd /etc/service/syslog-ng /etc/service/syslog-forwarder /etc/service/cron && \
    add-apt-repository -y ppa:webupd8team/java && \
    add-apt-repository "deb https://dl.bintray.com/sbt/debian /" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \
    add-apt-repository "deb https://apt.dockerproject.org/repo ubuntu-trusty main" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2C52609D && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    mkdir -p /data/db && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y mongodb-org=${MONGODB_VERSION} mongodb-org-server=${MONGODB_VERSION} mongodb-org-shell=${MONGODB_VERSION} mongodb-org-mongos=${MONGODB_VERSION} mongodb-org-tools=${MONGODB_VERSION} && \
    wget -qO /tmp/elasticsearch.deb https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb && \
    dpkg -i /tmp/elasticsearch.deb && \
    rm -f /tmp/elasticsearch.deb && \
    apt-get install -y --force-yes oracle-java8-installer sbt docker-engine && \
    update-java-alternatives -s java-8-oracle && \
    wget -qO /tmp/maven.tar.gz http://artfiles.org/apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf /tmp/maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn && \
    rm -f /tmp/maven.tar.gz && \
    mkdir /home/jenkins/.m2 /home/jenkins/workspace && \
    chown -R jenkins.jenkins /home/jenkins/.m2 /home/jenkins/workspace && \
    mkdir -p /etc/service/elasticsearch /etc/service/graylog-server /etc/service/mongodb && \
    mkdir -p /opt/graylog/data/journal /opt/graylog/assembly

ADD mongodb.run /etc/service/mongodb/run
ADD elasticsearch.run /etc/service/elasticsearch/run
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
ADD graylog-server.run /etc/service/graylog-server/run
ADD graylog.conf /opt/graylog/graylog.conf
ADD run.sh /opt/graylog/run.sh
ADD stop.sh /opt/graylog/stop.sh

RUN chmod +x /etc/service/mongodb/run /etc/service/elasticsearch/run /etc/service/graylog-server/run /opt/graylog/run.sh /opt/graylog/stop.sh

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /var/run/docker.sock

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
