require 'telegram/bot'
require 'net/http'
require 'json'

require_relative 'environment'
require_relative 'commands'

module AsyncEnglish
  class Bot

    def self.run
      new.run
    end

    def run
      Telegram::Bot::Client.run(AsyncEnglish::TELEGRAM_TOKEN) do | bot |

        bot.listen do |message|
          puts "@#{message.from.username}: #{message}"
          listen_commands bot, message
          listen_new_members bot, message
        end
      end
    end


    def listen_new_members(bot, message)
      return if !message.new_chat_members || message.new_chat_members.empty?
      members = message.new_chat_members.map { |user| "@#{user.username}" }.join(", ")

      welcome = "Welcome #{members}, please introduce yourself with your name, age and where do you live\n" +
      "Feel free to tell what do you do at your free time and/or what is your job\n" +
      "We encourage you to send audio if you're confortable, but if not, use text as well ^^" +
      "We dont have any professor, teacher, sensei or similar haha but we're free to correct our typos, grammar, pronounces and more..\n" +
      "Please, dont be offended, we're all learning and helping each other. \n\n" +
      "Enjoy!".strip

      bot.api.send_message(chat_id: message.chat.id, text: welcome)
    end
    
    def listen_commands(bot, message)
    
      return unless message.text && message.text.start_with?("/")
    
      puts "User command: #{message.text}"
      reply = AsyncEnglish::Commands.get_message message
    
      puts "Bot reply: #{reply}"
      bot.api.send_message(chat_id: message.chat.id, text: reply)
    end
  end

end