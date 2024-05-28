FROM ubuntu

COPY web.rb /app/web.rb

RUN apt-get update
RUN apt-get install ruby
RUN gem install sinatra

CMD ["ruby", "/app/web.rb"]
