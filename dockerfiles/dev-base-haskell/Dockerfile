FROM exo1/dev-base-1:latest
MAINTAINER Max Kaye <max@exo1.tech>

WORKDIR ~/

RUN mkdir -p src && cd src \
	&& git clone https://gitlab.com/exo-one/svst-haskell \
	&& cd svst-haskell

RUN stack upgrade
