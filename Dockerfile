FROM ubuntu:16.04
MAINTAINER technojunkie

RUN apt-get -y update && apt-get install -y \
    build-essential \
    handbrake-cli \
    libdvdnav4 \
    libdvdread4 \
    libudev-dev \
    openssh-server \
    python-software-properties \
    software-properties-common && \
    /usr/bin/add-apt-repository -y ppa:stebbins/handbrake-releases && \
    mkdir /home/makemkv && \
    cd /home/makemkv && \
    wget http://www.makemkv.com/download/makemkv-oss-1.9.10.tar.gz && \
    wget http://www.makemkv.com/download/makemkv-bin-1.9.10.tar.gz && \
    cd /home/makemkv/makemkv-oss-1.9.10 && make install && \
    cd /home/makemkv/makemkv-bin-1.9.10 && make install && \
    rm -r /home/makemkv && \
    groupadd -r ripbot && useradd -r -g ripbot ripbot && \
    apt-get -y remove build-essential && apt-get -y autoremove

EXPOSE 22
