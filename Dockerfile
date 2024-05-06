FROM ubuntu:22.04


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y fonts-ipafont graphviz openjdk-8-jre git curl
RUN curl -L https://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar > /plantuml.jar

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
