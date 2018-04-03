require 'http'
require 'json'

rc = HTTP.post("https://slack.com/api/api.test")
puts JSON.pretty_generate(JSON.parse(rc.body))

rc = HTTP.post("https://slack.com/api/auth.test", params:{ token: ENV['SLACK_API_TOKEN'] })
puts JSON.pretty_generate(JSON.parse(rc.body))


rc = HTTP.post("https://slack.com/api/chat.postMessage", params: { 
  token: ENV['SLACK_API_TOKEN'], 
  channel: '#random',
  text: 'TEST',
  as_user: true
})

# rc = HTTP.post("https://slack.com/api/chat.postMessage", params: {
#   token: ENV['SLACK_API_TOKEN'],
#   channel: '#general',
#   text: 'zzzz'
# })

puts JSON.pretty_generate(JSON.parse(rc.body))