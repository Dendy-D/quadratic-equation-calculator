FROM ubuntu:latest

RUN apt-get update && apt-get install -y bc

ENV TERM=xterm-256color

WORKDIR /src

COPY solveQuadraticEquation.sh .

CMD ["bash", "./solveQuadraticEquation.sh"]
