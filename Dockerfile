FROM ruby:2.3.1

ENV WORKDIR /var/www
WORKDIR $WORKDIR
ADD . $WORKDIR
RUN bundle install --without development test --deployment
RUN mkdir -p tmp/pids
CMD PIDFILE=tmp/pids/server.pid ruby yep_botfather_server.rb >> log/$RACK_ENV.log
