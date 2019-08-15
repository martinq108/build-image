FROM docker:18.05

MAINTAINER Martin Kvapil <martin@qapil.cz>

ARG user=jenkins-slave
ARG group=jenkins-slave
ARG uid=997
ARG gid=994
ARG docker_group=docker
ARG docker_gid=997

# alpine's wget does not work correctly with https, so we use curl instead
# install iputils to have correct ping behavior
# install java and jenkins swarm client
RUN apk add --no-cache \
	git bash iputils curl rsync subversion \
	&& mkdir -p /usr/share/jenkins \
	&& chmod 755 /usr/share/jenkins

ENV JAVA_VERSION 8u222
ENV JAVA_ALPINE_VERSION 8.222.10-r1

RUN apk add --no-cache openjdk8="$JAVA_ALPINE_VERSION"

ENV HOME /home/${user}

# create jenkins group and user
RUN addgroup -S -g ${gid} ${group}
RUN adduser -S -u ${uid} -h $HOME -G ${group} ${user}

# create docker group and assign jenkins user to that group to be able to execute docker
RUN addgroup -S -g ${docker_gid} ${docker_group}
RUN adduser ${user} ${docker_group}

RUN mkdir ${HOME}/gradle-volume && \
	chown ${uid}:${gid} ${HOME}/gradle-volume

#VOLUME ${HOME}
#VOLUME ${HOME}/.gradle
VOLUME ${HOME}/gradle-volume
WORKDIR ${HOME}

# run container as jenkins user
USER ${user}

#CMD ["/bin/bash"]
