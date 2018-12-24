FROM alpine:3.8

MAINTAINER Daniel Siepmann
LABEL Description="This image should provide environment to render daniel-siepmann.de" Vendor="DanielSiepmann" Version="1.0"

# Define ruby dependencies
ENV RUBY_BUILD_PACKAGES curl-dev libffi-dev ruby-dev build-base
ENV RUBY_PACKAGES ruby ruby-io-console ruby-bundler
ENV TZ=Europe/Berlin

# Install dependencies
RUN apk update && apk upgrade \
    && apk add bash \
    && apk add pngquant optipng \
    && apk add --update tzdata \
    && apk add python py-pip \
    && apk add $RUBY_BUILD_PACKAGES \
    && apk add $RUBY_PACKAGES \
    && rm -rf /var/cache/apk/*

COPY . /docker
RUN cd /docker \
    && pip install --upgrade -r requirements.txt \
    && gem install bundler --no-document \
    && bundle install \
    && rm -rf /docker
