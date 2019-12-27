FROM ruby:2.6.4
RUN apt-get update -qq \
  && apt-get install -y build-essential libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# For webpacker
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
  && apt-get update && apt-get install -y nodejs && rm -rf /var/lib/apt/lists/* \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y yarn && rm -rf /var/lib/apt/lists/*

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

# # Set Rails to run in production
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production
ENV SECRET_KEY_BASE super_secret_key

COPY . ./

RUN bundle exec rake assets:precompile
CMD ["rails", "server", "-b", "0.0.0.0"]
