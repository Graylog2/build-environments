FROM ubuntu:trusty
MAINTAINER Marius Sturm <hello@torch.sh>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y apt-utils wget git

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

RUN mkdir /home/jenkins/workspace
RUN mkdir /home/jenkins/.m2
RUN CHOWN -R jenkins.jenkins /home/jenkins/workspace /home/jenkins/.m2

VOLUME /home/jenkins/workspace
VOLUME /home/jenkins/.m2

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
