FROM ubuntu:22.04


ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
RUN apt-get install -y fonts-ipafont graphviz openjdk-17-jre git curl
RUN curl -L https://github.com/plantuml/plantuml/releases/download/v1.2025.5/plantuml-1.2025.7.jar > /plantuml.jar

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
