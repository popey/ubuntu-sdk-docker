FROM ubuntu:15.04

MAINTAINER popey@ubuntu.com

RUN locale-gen en_US en_US.UTF-8 en_GB en_GB.UTF-8 && \
	dpkg-reconfigure locales

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ubuntu-sdk-team/ppa -y
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ci-train-ppa-service/stable-phone-overlay  -y

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install --no-install-recommends -y \
    ubuntu-sdk \
    bzr \
	&& \
	apt-get clean

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
	ls /etc/ && \
	mkdir /etc/sudoers.d/ && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
CMD /usr/bin/ubuntu-sdk-ide
