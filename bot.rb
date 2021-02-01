require 'telegram_bot'
require 'net/http'
require 'json'

token = ENV['TELEGRAM_TOKEN']
bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
    puts "@#{message.from.username}: #{message.text}"
    command = message.get_command_for(bot)
  
    message.reply do |reply|
      case command
      when /start/i
        reply.text = "All I can do is say hello. Try the /greet command."
      when /word/i

        begin
          resp = Net::HTTP.get_response 'https://wordsapiv1.p.mashape.com/words/home/definitions'
          # json = JSON.parse(resp.body, object_class: OpenStruct) if resp.is_a Net::HTTPSuccess
          definition = resp.is_a Net::HTTPSuccess ? "Hey.. success!" : "Not found..."
        rescue
          definition = "Oops! failed to load"
        end

        reply.text = definition
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

