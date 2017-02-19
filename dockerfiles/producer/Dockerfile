FROM exo1/dev-base-haskell:latest

# Add stuff after this so we have a common image

WORKDIR /src/svst-haskell

RUN git pull
RUN stack build
RUN stack install && mv ~/.local/bin/* /usr/bin/

WORKDIR /src

RUN git clone https://gitlab.com/exo-one/svst-python.git --depth=1

WORKDIR /src/svst-python

RUN pip3 install -r requirements.txt
