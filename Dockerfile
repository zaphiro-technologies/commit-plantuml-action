FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt_flags="-o Acquire::By-Hash=force -o Acquire::Retries=3 -o Acquire::http::Timeout=20" \
  && max_attempts=5 \
  && i=0 \
  && until [ "$i" -ge "$max_attempts" ]; do apt-get $apt_flags update && break; i=$((i+1)); rm -rf /var/lib/apt/lists/*; sleep 5; done \
  && [ "$i" -lt "$max_attempts" ] \
  && apt-get $apt_flags install -y --no-install-recommends fonts-ipafont graphviz openjdk-17-jre git curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl --fail --silent --show-error --location --retry 5 --retry-connrefused --max-time 120 https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar > /plantuml.jar

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
