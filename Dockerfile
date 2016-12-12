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

RUN mkdir /home/makemkv; \
    mkdir /var/run/sshd; \
    echo 'root:screencast' | chpasswd; \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd; \
    cd /home/makemkv

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ADD http://www.makemkv.com/download/makemkv-bin-$VERSION.tar.gz /tmp/makemkv/makemkv-bin-$VERSION.tar.gz
ADD http://www.makemkv.com/download/makemkv-oss-$VERSION.tar.gz /tmp/makemkv/makemkv-oss-$VERSION.tar.gz

RUN tar xzf /tmp/makemkv/makemkv-oss-$VERSION.tar.gz
# rm /tmp/makemkv/makemkv-oss-$VERSION.tar.gz
RUN ./makemkv-oss-$VERSION/configure --disable-gui
RUN ./makemkv-oss-$VERSION/make
RUN ./makemkv-oss-$VERSION/make install
# RUN cd makemkv-oss-$VERSION
# RUN ./configure --disable-gui
# rm -rf /makemkv-oss-$VERSION

RUN tar xzf /tmp/makemkv/makemkv-bin-$VERSION.tar.gz
RUN cd /tmp/makemkv/makemkv-bin-$VERSION
RUN echo "accepted" > ./makemkv-bin-$VERSION/tmp/eula_accepted
RUN ./makemkv-bin-$VERSION/make install
#    cd ~; \
#    rm -rf /tmp/makemkv

RUN groupadd -r ripbot && useradd -r -g ripbot ripbot
#    apt-get -y remove build-essential && apt-get -y autoremove

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
