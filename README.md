catch-websocket-client
======================
This client sends a request and waits for a response, just like HTTP communication.


Usage
-----
### Case. 1
```ruby
require 'catch-websocket-client'

cws = CatchWebSocket::Client.new 'wss://example.com'

response = cws.request({
  command: :auth,
  params: {
    user: 'username',
    pass: 'password'
  }
})

result = JSON.parse(response)

puts JSON.pretty_generate(result)
```


### Case. 2
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

Copyright c 2022 neirouter.com
LICENSE: MIT License

