FROM ruby:2.5
RUN apt-get update -qq && \
  apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  mecab \
  libmecab-dev \
  mecab-ipadic-utf8 \
  postgresql-client \
  --no-install-recommends
ENV APP_ROOT /words
RUN mkdir $APP_ROOT
WORKDIR   $APP_ROOT
COPY Gemfile      $APP_ROOT/Gemfile
COPY Gemfile.lock $APP_ROOT/Gemfile.lock
RUN echo 'gem: --no-document' >> ~/.gemrc && \
    cp ~/.gemrc /etc/gemrc && \
    chmod uog+r /etc/gemrc && \
    bundle config --global build.nokogiri --use-system-libraries && \
    bundle config --global jobs 4 && \
    bundle install
COPY . $APP_ROOT
