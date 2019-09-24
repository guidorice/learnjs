# Docker dev environment for _Serverless Single Page Apps_ by Ben Rady

# TODO: consolidate all RUN commands

# this warning seens safe to ignore:
#   debconf: delaying package configuration, since apt-utils is not installed
#   https://stackoverflow.com/questions/51023312/docker-having-issues-installing-apt-utils

FROM ubuntu:latest

# install nodejs, python (needed only for awscli), git and utils
RUN apt-get update && \
    apt-get upgrade --yes

RUN apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    git \
    groff \
    less \
    python3 \
    python3-distutils \
    unzip

RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash - 
RUN apt-get install --yes nodejs

# install AWS cli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" \
    --output "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN python3 ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN rm --recursive --force awscli-bundle

# cleanup apt-get stuff
RUN rm --recursive --force /var/lib/apt/lists/*

# create user for development
RUN useradd --create-home --shell /bin/bash dev

# copy github repo into image, taking care of permissions
COPY --chown=dev:dev . /home/dev/learnjs

# this user for any run, cmd, or entrypoint instructions added later...
WORKDIR /home/dev
USER dev

# ./sspa server runs on 9292 so expose that port
EXPOSE 9292/tcp
