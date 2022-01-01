catch-websocket-client
======================
This is a library for interactive WebSocket communication like HTTP.
Once you send a request, it will keep waiting for a response.


Usage
-----
## Case. 1
```ruby
require 'catch-websocket-client'

cws = CatchWebSocket::Client.new 'wss://example.com'

response = cws.request({
  command: :auth,
  params: {
    id: 'username',
    pw: 'password'
  }
})

result = JSON.parse(response)

puts JSON.pretty_generate(result)
```


## Case. 2
```ruby
require 'catch-websocket-client'

result = nil
CatchWebSocket::Client.open('wss://example.com') { |socket|
  socket.request({
  }) { |result|
    result = JSON.parse(result)
    if result['chunk']
      results = []
      while true
        results[result['seq']] = result['chunk']
        break if result['last']
        result = JSON.parse(socket.receive)
      end
      result = JSON.parse(results.join)
    end
  }
}

puts JSON.pretty_generate(result)
```

## Copyright

Copyright c 2022 @neirouter
LICENSE: MIT License

