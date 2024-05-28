require 'sinatra'
require 'json'

set :port, 4444
set :bind, '0.0.0.0'

get '/api' do
    content_type :json
    { name: 'Hello',
        description: 'World',
        Url: request.url }.to_json
end