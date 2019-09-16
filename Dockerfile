# Docker dev environment for _Serverless Single Page Apps_ by Ben Rady

# TODO: consolidate all RUN commands

# this warning seens safe to ignore:
#   debconf: delaying package configuration, since apt-utils is not installed
#   https://stackoverflow.com/questions/51023312/docker-having-issues-installing-apt-utils

FROM ubuntu:latest

# install nodejs, python (needed only for awscli), git and utils
RUN apt-get update && \
    apt-get upgrade -y 

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    groff \
    less \
    python3 \
    python3-distutils \
    unzip

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - 
RUN apt-get install -y nodejs

# install AWS cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN python3 ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN rm -rf awscli-bundle

RUN rm -rf /var/lib/apt/lists/*

# create user for development and copy github repo into image
RUN useradd -ms /bin/bash dev
USER dev
WORKDIR /home/dev/learnjs
COPY --chown=dev:dev . .

# ./sspa server runs on 9292
EXPOSE 9292/tcp
