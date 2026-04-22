FROM alpine:3.20

RUN max_attempts=5 \
  && retry_delay=5 \
  && attempt=0 \
  && until [ "$attempt" -ge "$max_attempts" ]; do \
    if apk add --no-cache bash git curl grep graphviz openjdk17-jre fontconfig font-ipa ca-certificates; then \
      break; \
    fi; \
    attempt=$((attempt+1)); \
    sleep "$retry_delay"; \
  done \
  && if [ "$attempt" -ge "$max_attempts" ]; then echo "Failed to install Alpine packages after ${max_attempts} attempts (check network/mirror availability)"; exit 1; fi \
  && update-ca-certificates
RUN curl --fail --silent --show-error --location --retry 5 --retry-connrefused --max-time 120 https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar > /plantuml.jar \
  || { echo "Failed to download plantuml.jar after 5 retries from https://github.com/plantuml/plantuml/releases/download/v1.2025.7/plantuml-1.2025.7.jar"; exit 1; }

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
