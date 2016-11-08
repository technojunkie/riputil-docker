FROM ubuntu:16.04
MAINTAINER technojunkie

ENV VERSION 1.10.2

RUN apt-get -y update && apt-get install -y \
    build-essential \
    handbrake-cli \
    libdvdnav4 \
    libdvdread4 \
    libudev-dev \
    openssh-server \
    software-properties-common
RUN mkdir /home/makemkv; \
    mkdir /var/run/sshd; \
    echo 'root:screencast' | chpasswd; \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    cd /home/makemkv

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD http://www.makemkv.com/download/makemkv-bin-$VERSION.tar.gz /tmp/makemkv
ADD http://www.makemkv.com/download/makemkv-oss-$VERSION.tar.gz /tmp/makemkv

RUN tar xzf /tmp/makemkv/makemkv-oss-$VERSION.tar.gz; \
    cd /tmp/makemkv/makemkv-oss-$VERSION; \
    ./configure; \
    make; \
    make install; \
    tar xzf /tmp/makemkv/makemkv-bin-$VERSION.tar.gz; \
    cd /tmp/makemkv/makemkv-bin-$VERSION; \
    yes yes | make; \
    make install; \
    cd ~; \
    rm -rf /tmp/makemkv

RUN groupadd -r ripbot && useradd -r -g ripbot ripbot; \
    apt-get -y remove build-essential && apt-get -y autoremove

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
