FROM ubuntu:17.04
MAINTAINER Nadir Izrael nadir.izr@gmail.com

# Update system and install prerequisites
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y apt-transport-https && \
    apt-get clean

ENV BAZEL_VERSION 0.4.5

RUN echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/99_norecommends \
 && echo 'APT::AutoRemove::RecommendsImportant "false";' >> /etc/apt/apt.conf.d/99_norecommends \
 && echo 'APT::AutoRemove::SuggestsImportant "false";' >> /etc/apt/apt.conf.d/99_norecommends

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git \
 && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > \
         /etc/apt/sources.list.d/bazel.list \
 && curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -y bazel=${BAZEL_VERSION} \
 && apt-get purge --auto-remove -y curl \
 && rm -rf /etc/apt/sources.list.d/bazel.list \
 && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates -f



ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_SHA256 97892375e756fd29a304bd8cd9ffb256c2e7c8fd759e12a55a6336e15100ad75


RUN apt-get update -y && \
    apt-get install -y python python-dev python-pip python-virtualenv git curl wget && \
    apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://get.docker.com/ | sh

RUN echo 'DOCKER_OPTS="-H :2375 unix:///var/run/docker.sock"' >> /etc/default/docker

