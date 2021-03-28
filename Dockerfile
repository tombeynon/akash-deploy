FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs

RUN gem update --system --quiet && gem install bundler -v '2.2.15'
ENV BUNDLER_VERSION 2.2.15

ENV AKASH_NET=mainnet
ENV AKASH_CLI_VERSION=latest
ENV AKASH_HOME=/root/akash
ENV KEY_NAME=deploy
ENV FEE_RATE=5000uakt

# Install Akash
WORKDIR /usr
RUN curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_CLI_VERSION"

# Install app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

VOLUME /root/akash
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
