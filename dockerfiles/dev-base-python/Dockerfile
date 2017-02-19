FROM exo1/dev-base-haskell:latest
MAINTAINER Max Kaye <max@exo1.tech>

WORKDIR /src

RUN sudo apt-get install -y python3-pip python3-dev \
    && git clone https://gitlab.com/exo-one/svst-python.git --depth=1 \
    && cd svst-python && pip3 install -r requirements.txt
