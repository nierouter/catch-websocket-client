module CatchWebSocket

  # 
  class Client
    FrameTimeoutSec = 600
    def self.open url, type=nil
      client = CatchSocket.new url, type
      if block_given?
        begin
          yield client
        rescue => e
          client.close
          raise e
        end
        client.close
        client = nil
      end
      return client
    end

    attr_reader :uri, :is_closed

    def initialize url, type=nil
      @uri = URI.parse url
      @type = type || :text
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.ssl_version = 'SSLv23'
      ctx.options = OpenSSL::SSL::OP_NO_SSLv2
      cert_store = OpenSSL::X509::Store.new
      cert_store.set_default_paths
      ctx.cert_store = cert_store
      @socket = ::OpenSSL::SSL::SSLSocket.new(TCPSocket.new(@uri.host, @uri.port), ctx)
      @socket.connect
      write_and_receive(@handshake = ::WebSocket::Handshake::Client.new(url: url))
      @frame = ::WebSocket::Frame::Incoming::Client.new
      @is_closed = false
    end
    def close
      return if @is_closed
      write_and_receive(nil, :close)
      begin
        @socket.close
      rescue => e
        raise e
      end
      @is_closed = true
    end
    def request message
      unless @is_closed
        message = JSON.generate(message) if message.is_a?(Hash) || message.is_a?(Array)
        result = write_and_receive(message, @type)
        if block_given?
          yield result
        else
          return result
        end
      end
    end
    def write_and_receive message, type=nil
      @last_message = message
      message = ::WebSocket::Frame::Outgoing::Client.new(data: message, type: type, version: @handshake.version) if type
      @socket.write message.to_s
      receive
    end
    def receive
      while true
        character = nil
        counter = 0
        while (character = @socket.getc).nil?
          sleep 0.1
          counter += 1
          raise Timeout::Error.new("FrameTimeout: #{@last_message}") if FrameTimeoutSec <= counter
        end
        if @frame.nil?
          @handshake << character
          return if @handshake.finished?
        else
          @frame << character
          incoming = @frame.next
          return incoming.data if incoming
        end
      end
    end
  end
end
