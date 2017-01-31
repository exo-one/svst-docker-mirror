FROM exo1/dev-base-1:latest
MAINTAINER Max Kaye <max@exo1.tech>

# NB: this repo should be git-pulled before compiling
RUN mkdir -p src && cd src \
	&& git clone https://gitlab.com/exo-one/svst-haskell \
	&& cd svst-haskell

RUN stack upgrade && mv ~/.local/bin/stack /usr/bin/stack
RUN stack --version

# build so we cache - lots of common elements so adding to dev base
# means we only need to compile once
RUN stack setup
RUN cd src/svst-haskell && stack build

