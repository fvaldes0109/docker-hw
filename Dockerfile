FROM ubuntu

RUN apt-get update
RUN apt-get install ruby --assume-yes
RUN gem install sinatra
RUN gem install rackup

COPY web.rb /app/web.rb

CMD ["ruby", "/app/web.rb"]
