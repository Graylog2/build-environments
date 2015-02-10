FROM debian:7.8
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y curl git build-essential && \
    apt-get install -y ruby1.9.1-full
RUN gem install --no-rdoc --no-ri bundler
RUN mkdir /workspace

VOLUME /workspace

CMD ["/bin/bash"]
