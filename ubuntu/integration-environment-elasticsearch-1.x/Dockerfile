FROM ubuntu/integration-environment-base:latest
MAINTAINER Graylog, Inc. <hello@graylog.com>

ENV DEBIAN_FRONTEND noninteractive
ENV ELASTICSEARCH_VERSION 1.7.5

RUN wget -qO /tmp/elasticsearch.deb https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.deb && \
    dpkg -i /tmp/elasticsearch.deb && \
    rm -f /tmp/elasticsearch.deb && \
    mkdir -p /etc/service/elasticsearch

ADD elasticsearch.run /etc/service/elasticsearch/run
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

RUN chmod +x /etc/service/elasticsearch/run

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2
VOLUME /var/run/docker.sock

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
