#    scratch
#    alpine:3.7
FROM ruby:2.5.1-alpine

RUN apk upgrade \
 && apk add --update --no-cache build-base less

WORKDIR /src

COPY Gemfile* ./

RUN bundle install --jobs 4

COPY . .

CMD ["ruby", "main.rb"]
