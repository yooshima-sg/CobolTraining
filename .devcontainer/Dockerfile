FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends postgresql-client language-pack-ja
     
WORKDIR /tmp
COPY envbuilder ./envbuilder
RUN bash envbuilder/builder/build.sh
RUN rm -rf envbuilder
