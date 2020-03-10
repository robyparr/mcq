FROM ruby:2.6.4

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    cron \
    nodejs \
    yarn \
  && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
RUN gem install bundler \
  && bundle config set without 'development test' \
  && bundle install --jobs 10 --retry 5

# # Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production
ENV RAILS_LOG_TO_STDOUT true

COPY . ./

RUN bundle exec whenever --update-crontab
RUN bundle exec rake assets:precompile

CMD cron -f & bin/delayed_job start & bundle exec puma -C config/puma.rb
