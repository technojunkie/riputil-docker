FROM ubuntu:16.04
MAINTAINER technojunkie

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

ADD http://www.makemkv.com/download/makemkv-bin-1.10.2.tar.gz /home/makemkv
ADD http://www.makemkv.com/download/makemkv-oss-1.10.2.tar.gz /home/makemkv

RUN cd /home/makemkv/makemkv-oss-1.10.2 && make install; \
    cd /home/makemkv/makemkv-bin-1.10.2 && make install; \
    rm -r /home/makemkv
RUN groupadd -r ripbot && useradd -r -g ripbot ripbot; \
    apt-get -y remove build-essential && apt-get -y autoremove

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
