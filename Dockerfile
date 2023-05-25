FROM debian:bullseye
LABEL maintainer="Tim Chaubet"
VOLUME ["/mnt/vrising/server", "/mnt/vrising/persistentdata"]

ARG DEBIAN_FRONTEND="noninteractive"
COPY sources.list /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y

RUN useradd -m steam \
    && cd /home/steam \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && apt-get install -y lib32gcc-s1 steamcmd \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd

RUN apt install -y wine wine32 wine64 xvfb
RUN rm -rf /var/lib/apt/lists/* && \
    apt clean && \
    apt autoremove -y

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
