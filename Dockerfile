FROM matticala/docker-scala:2.12

ENV LANG C.UTF-8

RUN apk update && apk add --no-cache git
RUN apk add --no-cache --virtual=build-dependencies curl ca-certificates

ARG SBT_VERSION=0.13.13

ENV SBT_VERSION ${SBT_VERSION}

# Using https with bintray gives me certificate issues, no matter what.
ARG SBT_URI="http://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"

ENV SBT_HOME "/usr/share/sbt-${SBT_VERSION}"

RUN curl -sL -# $SBT_URI | tar -xzf- -C /usr/share && \
    mv "/usr/share/sbt-launcher-packaging-${SBT_VERSION}" "$SBT_HOME" && \
    rm -rf "$SBT_HOME/bin/*.bat"

RUN chmod -R 755 "$SBT_HOME" && \
    chown -R root:root "$SBT_HOME"

RUN apk del build-dependencies

ENV PATH $PATH:$SBT_HOME/bin
