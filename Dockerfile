# Usage:
# docker volume create pgdata
# docker volume create gems
# docker-compose up
# docker-compose run web bundle exec rake db:create db:schema:load ffcrm:demo:load
# docker-compose exec web bundle exec rake db:create db:schema:load ffcrm:demo:load

ARG RAILS_ENV=development

FROM ruby:2.5
LABEL author="Steve Kenworthy"

ENV RAILS_ENV $RAILS_ENV
ENV HOME /home/app

RUN mkdir -p $HOME

RUN apt-get update \
    && apt-get install -y imagemagick tzdata \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $HOME

#COPY Gemfile* ./
ADD . $HOME

RUN gem install bundler
RUN cp config/database.postgres.docker.yml config/database.yml
RUN bundle install --path=vendor/bundle --deployment
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle","exec","rails","s"]

# # Usage:
# # docker volume create pgdata
# # docker volume create gems
# # docker-compose up
# # docker-compose run web bundle exec rake db:create db:migrate db:schema:load ffcrm:demo:load assets:precompile
# # docker-compose exec web bundle exec rake db:create db:migrate db:schema:load ffcrm:demo:load assets:precompile

# FROM phusion/passenger-ruby24
# MAINTAINER Steve Kenworthy

# ENV HOME /home/app

# ADD . /home/app
# WORKDIR /home/app

# RUN apt-get update \
#   && apt-get install -y imagemagick firefox tzdata \
#   && apt-get autoremove -y \
#   && cp config/database.postgres.docker.yml config/database.yml \
#   && chown -R app:app /home/app \
#   && rm -f /etc/service/nginx/down /etc/nginx/sites-enabled/default \
#   && cp .docker/nginx/sites-enabled/ffcrm.conf /etc/nginx/sites-enabled/ffcrm.conf \
#   && bundle install --deployment
