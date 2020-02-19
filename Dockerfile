FROM ruby:2.6.5

ENV RAILS_ENV production
ARG PROSPERO_VERSION

COPY bootstrap /usr/local/bin/

RUN apt update

# Add Yarn package repository
RUN apt install --yes curl
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install system requirements
RUN apt update
RUN apt install --yes g++ make libpq-dev yarn nodejs git ca-certificates

# Install Prospero
RUN git clone https://framagit.org/prospero/prospero.git /srv/prospero
WORKDIR /srv/prospero
RUN git checkout v$PROSPERO_VERSION
RUN gem install bundler --version '~> 2.0'
RUN gem install foreman
RUN bundle install --without development test
RUN yarn install
RUN rails assets:precompile

# Clean up system
RUN apt purge --yes yarn git
RUN apt autoremove --yes

EDITOR="echo" rails credentials:edit

ENTRYPOINT ["bootstrap"]

EXPOSE 5000
