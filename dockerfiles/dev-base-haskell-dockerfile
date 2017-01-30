FROM exo-one:dev-base-1
MAINTAINER Max Kaye <max@exo1.tech>

WORKDIR ~/

RUN mkdir -p src && cd src \
	&& git clone https://gitlab.com/exo-one/svst-haskell \
	&& cd svst-haskell

RUN stack upgrade
