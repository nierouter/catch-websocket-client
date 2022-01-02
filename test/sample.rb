lib = 'lib'
lib = File.expand_path((File.exist?(lib) ? '' : '../').concat(lib), __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'catch-websocket-client'

cws = CatchWebSocket::Client.new 'wss://websocket.nierouter.com/'

response = cws.request({
  method: :auth,
  params: {
    user: 'nierouter',
    pass: 'nierouter'
  }
})

result = JSON.parse(response)

puts JSON.pretty_generate(result)
