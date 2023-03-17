FROM alpine:edge
LABEL maintainer="edenceHealth NV <info@edence.health>"

RUN set -eux; \
  apk add --no-cache \
    # importing gettext for envsubst
    gettext \
    postgresql-client \
  ;

WORKDIR /app
COPY src /app

ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
RUN set -eux; \
  addgroup \
    -g "${NONROOT_GID}" \
    nonroot \
  ; \
  adduser \
    -h /work \
    -u "${NONROOT_UID}" \
    -G nonroot \
    -D \
    nonroot \
  ;
USER nonroot
WORKDIR /work

ARG GIT_TAG="dev"
ARG GIT_SHA="dev"
ENV GIT_TAG="${GIT_TAG}" GIT_SHA="${GIT_SHA}"

ENTRYPOINT [ "/app/vocabulon.sh" ]