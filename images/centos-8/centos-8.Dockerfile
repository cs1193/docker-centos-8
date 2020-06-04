FROM centos:8

LABEL maintainer="Chandresh Rajkumar Manonmani <cs1193@gmail.com>"

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf update -y

RUN dnf groupinstall -y 'development tools'
RUN dnf install -y bash wget curl which git-core tar sudo
RUN dnf install -y bzip2-devel expat-devel gdbm-devel ncurses-devel openssl-devel readline-devel sqlite-devel tk-devel xz-devel zlib-devel
RUN dnf install -y python3 python3-devel python3-pip
RUN dnf install -y openssh openssh-server gcc gcc-c++ glibc.i686 sysstat htop iotop make autoconf automake bison collectd telnet bind-utils lsof
RUN dnf clean all

ENV GOSU_VERSION 1.12
RUN set -eux;
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64"
RUN wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu
RUN command -v gpgconf && gpgconf --kill all || :
RUN rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc
RUN chmod +x /usr/local/bin/gosu
RUN gosu --version
RUN gosu nobody true

ENV TINI_VERSION v0.19.0
RUN wget -O /usr/local/bin/tini "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-amd64"
RUN wget -O /usr/local/bin/tini.asc "https://github.com/krallin/tini/releases/download/$TINI_VERSION/tini-amd64.asc"
RUN export GNUPGHOME="$(mktemp -d)"
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
RUN gpg --batch --verify /usr/local/bin/tini.asc /usr/local/bin/tini
RUN command -v gpgconf && gpgconf --kill all || :
RUN rm -rf "$GNUPGHOME" /usr/local/bin/tini.asc
RUN chmod +x /usr/local/bin/tini
RUN tini --version

SHELL ["/bin/bash", "-l", "-c"]