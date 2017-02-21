FROM exo1/dev-base-python:latest

# Add stuff after this so we have a common image

WORKDIR /src/svst-python
RUN git pull
# ADD ./svst-python /src/svst-python

RUN pip3 install -r requirements.txt
