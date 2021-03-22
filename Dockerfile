FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs

RUN \
  gem update --system --quiet && \
  gem install bundler -v '2.2.15'
ENV BUNDLER_VERSION 2.2.15


# Install app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
