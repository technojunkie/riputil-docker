FROM ubuntu:16.04
MAINTAINER technojunkie

ENV VERSION 1.10.3

RUN apt-get -y update && apt-get install -y \
    build-essential \
    handbrake-cli \
    less \
    libavcodec-dev \
    libc6-dev \
    libdvdnav4 \
    libdvdread4 \
    libexpat1-dev \
    libssl-dev \
    libudev-dev \
    openssh-server \
    pkg-config \
    software-properties-common

RUN mkdir /var/run/sshd; \
    echo 'root:screencast' | chpasswd; \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

WORKDIR /tmp
ADD http://www.makemkv.com/download/makemkv-bin-$VERSION.tar.gz makemkv-bin-$VERSION.tar.gz
ADD http://www.makemkv.com/download/makemkv-oss-$VERSION.tar.gz makemkv-oss-$VERSION.tar.gz

RUN tar xzf makemkv-oss-$VERSION.tar.gz && \
    cd makemkv-oss-$VERSION && \
    ./configure --disable-gui && \
    make && \
    make install

RUN tar xzf /tmp/makemkv/makemkv-bin-$VERSION.tar.gz && \
    cd /tmp/makemkv/makemkv-bin-$VERSION && \
    echo "accepted" > ./makemkv-bin-$VERSION/tmp/eula_accepted && \
    ./makemkv-bin-$VERSION/make install && \

# rm -rf /makemkv-oss-$VERSION
#    cd ~; \
#    rm -rf /tmp/makemkv

RUN groupadd -r ripbot && useradd -r -g ripbot ripbot
#    apt-get -y remove build-essential && apt-get -y autoremove

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
