# syntax=docker/dockerfile:1

FROM amazoncorretto:17-alpine-jdk

LABEL version="1"

RUN apk add curl unzip dos2unix && \
    addgroup minecraft && \
    adduser --home /data --ingroup minecraft --disabled-password minecraft

COPY launch.sh /launch.sh
RUN dos2unix /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME [/data]
WORKDIR /data

EXPOSE 25565/tcp

CMD ["/bin/sh","/launch.sh"]

ENV MOTD "Minecraft Server Hosted on Docker"
ENV JVM_OPTS "-Xms4G -Xmx8G"
ENV SERVER_FILES "Server-Files-0.2.6"
ENV SERVER_FILES_URL "https://mediafilez.forgecdn.net/files/4804/455/Server-Files-0.2.6.zip"
ENV FORGE_VERSION "1.20.1-47.1.3"
ENV EULA "true"