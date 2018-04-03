require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'
require 'sinatra'

Thread.new do
  EM.run do
  end
end

get '/' do
  if params.key?('code')
    rc = JSON.parse(HTTP.post('https://slack.com/api/oauth.access', params: {
      client_id: ENV['SLACK_CLIENT_ID'],
      client_secret: ENV['SLACK_CLIENT_SECRET'],
      code: params['code']
    }))

    token = rc['bot']['bot_access_token']

    rc = HTTP.post("https://slack.com/api/rtm.start", params: { 
      token: token, 
    })
    rc = JSON.parse(rc.body)

    url = rc['url']

    EM.run do 
      ws = Faye::WebSocket::Client.new(url)
      
      ws.on :open do
        p [:open]
      end

      ws.on :message do |event|
        data = JSON.parse(event.data)
        
        if data['text'] == 'hi'
          ws.send({
            type:'message',
            text: "hi <@#{data['user']}>", 
            channel: data['channel'] 
          }.to_json)
        end  
        
        p [:message, JSON.parse(event.data)]  
      end

      ws.on :close do
        p [:close, event.code, event.reason]
        EM.stop
      end  
    end
    "Team Successfully Registered"
  else  
    "Hello World"
  end  
end
