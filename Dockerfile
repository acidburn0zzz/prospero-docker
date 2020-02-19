FROM ruby:2.6.5-alpine

ENV RAILS_ENV production
ARG PROSPERO_VERSION

COPY bootstrap /usr/local/bin/

RUN apk add g++ make postgresql-dev yarn nodejs git

# Install Prospero
RUN git clone https://framagit.org/prospero/prospero.git /srv/prospero
WORKDIR /srv/prospero
RUN git checkout v$PROSPERO_VERSION
RUN gem install bundler --version '~> 2.0'
RUN gem install foreman
RUN gem install tzinfo-data
RUN bundle config --global with 'alpine'
RUN bundle config --global without 'development test'
RUN bundle install
RUN yarn install

ENTRYPOINT ["bootstrap"]

EXPOSE 5000
