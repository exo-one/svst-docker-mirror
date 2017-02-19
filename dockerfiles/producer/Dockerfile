FROM exo1/dev-base-python:latest

# Add stuff after this so we have a common image

WORKDIR /src/svst-haskell

RUN git pull
RUN stack build
RUN stack install && mv ~/.local/bin/* /usr/bin/

WORKDIR /src/svst-python

RUN git pull && pip3 install -r requirements.txt
