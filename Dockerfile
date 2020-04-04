FROM ruby:2.7.1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
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
ENV SECRET_KEY_BASE super-secret-key

COPY . ./

RUN bundle exec rake assets:precompile

CMD bundle exec bin/delayed_job start \
  & bundle exec clockwork clock.rb \
  & bundle exec puma -C config/puma.rb
