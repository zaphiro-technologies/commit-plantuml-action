FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN i=0 \
  && until [ "$i" -ge 5 ]; do apt-get -o Acquire::By-Hash=force -o Acquire::Retries=3 -o Acquire::http::Timeout=20 update && break; i=$((i+1)); rm -rf /var/lib/apt/lists/*; sleep 5; done \
  && [ "$i" -lt 5 ] \
  && apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=20 install -y --no-install-recommends fonts-ipafont graphviz openjdk-17-jre git curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl --fail --silent --show-error --location --retry 5 --retry-connrefused --max-time 120 https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar > /plantuml.jar

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
