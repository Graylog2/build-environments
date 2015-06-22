FROM phusion/baseimage:latest
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget git

RUN apt-get install -y openssh-server && \
    sed -i 's|session required pam_loginuid.so|session optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

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
    wget http://artfiles.org/apache.org/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz && \
    mkdir /usr/local/maven && \
    tar -zxf apache-maven-3.2.5-bin.tar.gz -C /usr/local/maven --strip-components=1 && \
    ln -s /usr/local/maven/bin/mvn /usr/bin/mvn

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    mkdir -p /data/db && \
    apt-get update && \
    apt-get install -y mongodb-org=3.0.2 mongodb-org-server=3.0.2 mongodb-org-shell=3.0.2 mongodb-org-mongos=3.0.2 mongodb-org-tools=3.0.2

RUN wget -O /tmp/elasticsearch.deb https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.deb && \
    dpkg -i /tmp/elasticsearch.deb && \
    rm /tmp/elasticsearch.deb
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

RUN mkdir /etc/service/ssh && \
    mkdir /etc/service/nsv && \
    mkdir /etc/service/mongodb && \
    mkdir /etc/service/elasticsearch && \
    mkdir /etc/service/graylog-server && \
    mkdir -p /opt/graylog/data/journal

ADD sshd.run /etc/service/ssh/run
ADD nsv.py /etc/service/nsv/run
ADD mongodb.run /etc/service/mongodb/run
ADD elasticsearch.run /etc/service/elasticsearch/run
ADD graylog-server.run /etc/service/graylog-server/run
ADD graylog.conf /opt/graylog/graylog.conf
ADD run.sh /opt/graylog/run.sh
RUN chmod +x /etc/service/nsv/run /etc/service/mongodb/run /etc/service/elasticsearch/run /etc/service/graylog-server/run /opt/graylog/run.sh

RUN mkdir /workspace
RUN mkdir /root/.m2
VOLUME /workspace
VOLUME /root/.m2
EXPOSE 22

CMD ["/opt/graylog/run.sh"]
