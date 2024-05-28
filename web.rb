require 'sinatra'
require 'json'

set :port, 4444
set :bind, '127.0.0.1'

get '/api' do
    content_type :json
    { name: 'Hello',
        description: 'World',
        Url: request.url }.to_json
end