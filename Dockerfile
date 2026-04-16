FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN APT_FLAGS="-o Acquire::By-Hash=force -o Acquire::Retries=3 -o Acquire::http::Timeout=20" \
  && max_attempts=5 \
  && i=0 \
  && until [ "$i" -ge "$max_attempts" ]; do \
    if apt-get $APT_FLAGS update; then \
      break; \
    fi; \
    i=$((i+1)); \
    rm -rf /var/lib/apt/lists/*; \
    sleep 5; \
  done \
  && if [ "$i" -ge "$max_attempts" ]; then echo "Failed to update apt package indexes after ${max_attempts} attempts"; exit 1; fi \
  && apt-get $APT_FLAGS install -y --no-install-recommends fonts-ipafont graphviz openjdk-17-jre git curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl --fail --silent --show-error --location --retry 5 --retry-connrefused --max-time 120 https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar > /plantuml.jar \
  || { echo "Failed to download plantuml.jar after retries"; exit 1; }

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
