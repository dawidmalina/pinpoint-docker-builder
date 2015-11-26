FROM debian:8.2

MAINTAINER Dawid Malinowski <dawidmalina@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

ENV JAVA_HOME /usr/lib/jvm/j2sdk1.7-oracle
ENV MAVEN_HOME /usr/share/maven

ENV JAVA_6_HOME /usr/lib/jvm/j2sdk1.6-oracle
ENV JAVA_7_HOME /usr/lib/jvm/j2sdk1.7-oracle
ENV JAVA_8_HOME /usr/lib/jvm/j2sdk1.8-oracle

# install needed packages
RUN useradd pinpoint -m \
  && echo 'deb http://http.debian.net/debian/ jessie contrib' >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y git wget curl procps net-tools java-package fakeroot libgl1-mesa-glx libxslt1.1 libxtst6 libgtk2.0-0

# get maven
RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-3.3.3 /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# get jdk6
RUN cd /home/pinpoint \
  && wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/6u45-b06/jdk-6u45-linux-x64.bin \
  && chown pinpoint jdk-6u45-linux-x64.bin \
  && su pinpoint -c 'yes | fakeroot make-jpkg jdk-6u45-linux-x64.bin' \
  && rm jdk-6u45-linux-x64.bin \
  && dpkg -i oracle-j2sdk1.6_1.6.0+update45_amd64.deb \
  && rm oracle-j2sdk1.6_1.6.0+update45_amd64.deb

# get jdk7
RUN cd /home/pinpoint \
  && wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz \
  && chown pinpoint jdk-7u79-linux-x64.tar.gz \
  && su pinpoint -c 'yes | fakeroot make-jpkg jdk-7u79-linux-x64.tar.gz' \
  && rm jdk-7u79-linux-x64.tar.gz \
  && dpkg -i oracle-j2sdk1.7_1.7.0+update79_amd64.deb \
  && rm oracle-j2sdk1.7_1.7.0+update79_amd64.deb

# get jdk8
RUN cd /home/pinpoint \
  && wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
  http://download.oracle.com/otn-pub/java/jdk/8u65-b17/jdk-8u65-linux-x64.tar.gz \
  && chown pinpoint jdk-8u65-linux-x64.tar.gz \
  && su pinpoint -c 'yes | fakeroot make-jpkg jdk-8u65-linux-x64.tar.gz' \
  && rm jdk-8u66-linux-x64.tar.gz \
  && dpkg -i oracle-j2sdk1.8_1.8.0+update65_amd64.deb \
  && rm oracle-j2sdk1.8_1.8.0+update65_amd64.deb

RUN git clone https://github.com/naver/pinpoint.git /pinpoint

WORKDIR /pinpoint
VOLUME [/pinpoint]
