require 'telegram_bot'
require 'mime-types'
require 'netrc'
require 'http-cookie'
require 'http-accept'
require 'rest-client'

token = 'TOKEN'
bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)
  
    message.reply do |reply|
      case command
      when /start/i
        reply.text = "All I can do is say hello. Try the /greet command."
      when /word/i
        resp = RestClient.get 'https://wordsapiv1.p.mashape.com/words/home/definitions', {accept: :json}
        if resp.code == 200
          reply.text = "Hey.. success!"
        else
          reply.text = "Not found..."
        end
      when /qod/i
        reply.text = "Quote of the day here..."
      when /greet/i
        reply.text = "Hello, #{message.from.first_name}. 🤖"
      else
        reply.text = "I have no idea what #{command.inspect} means."
      end
      puts "sending #{reply.text.inspect} to @#{message.from.username}"
      reply.send_with(bot)
    end
  end

