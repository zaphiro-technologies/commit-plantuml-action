FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN APT_OPTIONS="-o Acquire::By-Hash=force -o Acquire::Retries=3 -o Acquire::http::Timeout=20" \
  && max_attempts=5 \
  && retry_delay=5 \
  && attempt=0 \
  && until [ "$attempt" -ge "$max_attempts" ]; do \
    if apt-get $APT_OPTIONS update; then \
      break; \
    fi; \
    attempt=$((attempt+1)); \
    rm -rf /var/lib/apt/lists/*; \
    sleep "$retry_delay"; \
  done \
  && if [ "$attempt" -ge "$max_attempts" ]; then echo "Failed to update apt package indexes after ${max_attempts} attempts (check network/mirror availability)"; exit 1; fi \
  && apt-get $APT_OPTIONS install -y --no-install-recommends fonts-ipafont graphviz openjdk-17-jre git curl \
  && rm -rf /var/lib/apt/lists/*
RUN curl --fail --silent --show-error --location --retry 5 --retry-connrefused --max-time 120 https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar > /plantuml.jar \
  || { echo "Failed to download plantuml.jar after 5 retries from https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar"; exit 1; }

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
