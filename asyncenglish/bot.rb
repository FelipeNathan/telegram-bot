require 'telegram/bot'
require 'net/http'
require 'openssl'
require 'json'
require 'uri'

require_relative 'environment'
require_relative 'events'
require_relative 'word_api'
require_relative 'commands'

module AsyncEnglish
  class Bot

    def self.run
      new.run
    end

    def run
      Telegram::Bot::Client.run(AsyncEnglish::TELEGRAM_TOKEN) do | bot |

        @bot = bot
        @bot.listen do |message|
          listen_commands message
          listen_new_members message
        end
      end
    end

    def listen_new_members(message)

      new_chat_members = message&.new_chat_members.select { |member| !member.is_bot }
      return if new_chat_members&.empty?

      AsyncEnglish::Events.on_new_members(new_chat_members) do |reply|
        @bot.api.send_message(chat_id: message.chat.id, text: reply, parse_mode: 'Html')
      end
    end
    
    def listen_commands(message)
      return unless message&.text&.start_with?("/")
      AsyncEnglish::Events.on_command(message.text, message.from) do |reply|
        puts "Bot reply: #{reply}"
        @bot.api.send_message(chat_id: message.chat.id, text: reply, parse_mode: 'Html')
      end
    end
  end

end