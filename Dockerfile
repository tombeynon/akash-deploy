FROM faddat/archlinux
RUN pacman -Syyu --noconfirm ruby yarn npm curl

ENV PATH $PATH:/root/.local/share/gem/ruby/3.0.0/bin 


RUN gem update && gem install bundler 

# Install Akash, `stable` version is also available
ENV AKASH_CLI_VERSION=v0.12.1
WORKDIR /usr
RUN curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_CLI_VERSION"

# Install app
ENV AKASH_NET=mainnet
ENV AKASH_HOME=/root/akash
ENV KEY_NAME=deploy
ENV FEE_RATE=5000uakt

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
