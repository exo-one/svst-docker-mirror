FROM ubuntu:xenial
MAINTAINER Max Kaye <max@exo1.tech>

ARG USER_ID
ARG GROUP_ID

ENV SVST_USER svst
ENV TERM xterm
ENV HOME /bitcoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} bitcoin \
	&& useradd -u ${USER_ID} -g bitcoin -s /bin/bash -m -d /bitcoin bitcoin

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8842ce5e && \
    echo "deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu xenial main" > /etc/apt/sources.list.d/bitcoin.list


RUN apt-get update
RUN apt-get install -y \
      wget git  \
      build-essential libtool autotools-dev autoconf pkg-config libssl-dev \
      libboost-all-dev libprotobuf-dev protobuf-compiler libevent-dev sudo nano bsdmainutils software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update \
      && apt-get install -y libdb4.8-dev libdb4.8++-dev \
      && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install Bitcoind
WORKDIR /root

RUN git clone https://gitlab.com/exo-one/bitcoin-nulldata

ADD files/configure-bitcoin-nulldata.sh /root
ADD files/build-bitcoin-nulldata.sh /root

RUN /root/configure-bitcoin-nulldata.sh
RUN /root/build-bitcoin-nulldata.sh


# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		wget
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y \
		ca-certificates \
		wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ADD ./bin /usr/local/bin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

ARG whichnet=-testnet
ENV WHICHNET ${whichnet}

CMD ["sh", "-c", "btc_oneshot $WHICHNET"]
