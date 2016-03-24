FROM phusion/baseimage:latest
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget curl git

RUN apt-get install -y openssh-server && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    dpkg-reconfigure openssh-server

RUN groupadd -r jenkins && \
    useradd -m -r -g jenkins jenkins

RUN echo "jenkins:jenkins" | chpasswd

RUN apt-get install -y sudo && \
    echo "%jenkins ALL=NOPASSWD:ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins && \
    usermod -a -G sudo jenkins

RUN apt-get install -y python-pip && \
    pip install supervise && \
    pip install Flask

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle && \
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/bin/java && \
    wget http://artfiles.org/apache.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    mkdir -p /data/db && \
    apt-get update && \
    apt-get install -y mongodb-org=3.0.7 mongodb-org-server=3.0.7 mongodb-org-shell=3.0.7 mongodb-org-mongos=3.0.7 mongodb-org-tools=3.0.7

RUN wget -O /tmp/elasticsearch.deb https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.3.deb && \
    dpkg -i /tmp/elasticsearch.deb && \
    rm /tmp/elasticsearch.deb
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

COPY phantomjs /usr/local/bin/
RUN chmod +x /usr/local/bin/phantomjs

RUN mkdir /etc/service/mongodb && \
    mkdir /etc/service/elasticsearch && \
    mkdir /etc/service/graylog-server && \
    mkdir -p /opt/graylog/data/journal && \
    mkdir /opt/graylog/assembly

ADD mongodb.run /etc/service/mongodb/run
ADD elasticsearch.run /etc/service/elasticsearch/run
ADD graylog-server.run /etc/service/graylog-server/run
ADD graylog.conf /opt/graylog/graylog.conf
ADD run.sh /opt/graylog/run.sh
ADD stop.sh /opt/graylog/stop.sh
RUN chmod +x /etc/service/mongodb/run /etc/service/elasticsearch/run /etc/service/graylog-server/run /opt/graylog/run.sh /opt/graylog/stop.sh

RUN rm -rf /etc/service/sshd
RUN rm -rf /etc/service/syslog-ng
RUN rm -rf /etc/service/syslog-forwarder
RUN rm -rf /etc/service/cron

RUN mkdir /home/jenkins/workspace
RUN mkdir /home/jenkins/.m2
RUN chown -R jenkins.jenkins /home/jenkins/workspace /home/jenkins/.m2

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
