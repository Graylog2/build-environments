FROM phusion/baseimage:latest
MAINTAINER Marius Sturm <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget git

RUN apt-get install -y python-pip && \
    pip install supervise && \
    pip install Flask

RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    update-java-alternatives -s java-8-oracle && \
    export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/bin/java

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list && \
    mkdir -p /data/db && \
    apt-get update && \
    apt-get install -y mongodb-org=3.0.2 mongodb-org-server=3.0.2 mongodb-org-shell=3.0.2 mongodb-org-mongos=3.0.2 mongodb-org-tools=3.0.2

RUN wget -O /tmp/elasticsearch.deb https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.6.0.deb && \
    dpkg -i /tmp/elasticsearch.deb && \
    rm /tmp/elasticsearch.deb
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

RUN mkdir /etc/service/nsv && \
    mkdir /etc/service/mongodb && \
    mkdir /etc/service/elasticsearch && \
    mkdir /etc/service/graylog-server && \
    mkdir -p /opt/graylog/data/journal

ADD nsv.py /etc/service/nsv/run
ADD mongodb.run /etc/service/mongodb/run
ADD elasticsearch.run /etc/service/elasticsearch/run
ADD graylog-server.run /etc/service/graylog-server/run
ADD graylog.conf /opt/graylog/graylog.conf
ADD run.sh /opt/graylog/run.sh
RUN chmod +x /etc/service/nsv/run /etc/service/mongodb/run /etc/service/elasticsearch/run /etc/service/graylog-server/run /opt/graylog/run.sh

VOLUME /opt/graylog/assembly

EXPOSE 12900
EXPOSE 27017
EXPOSE 5000

CMD ["/bin/bash"]
ENTRYPOINT ["/opt/graylog/run.sh"]
