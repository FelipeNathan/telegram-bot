module AsyncEnglish
    class Commands 
        class << self
          def start; "All I can do is say hello. Try the /greet command."; end 
          def greet(first_name) "Hello, #{first_name}. 🤖"; end

          def word(word_to_search = 'home')
            begin
              puts "Word to search: #{word_to_search}"
              reply = AsyncEnglish::WordAPI.get_definition_of(word_to_search)
            rescue AsyncEnglish::Exceptions::WordAPIException => e
              reply = "Oops! failed to get a word definition: " + e.message
            rescue StandardError => e
              reply = "Oops! Something went wrong, contact the administrators to check it out"
              puts e.to_s
            end
      
            reply
          end 

          def qod 
            begin
              AsyncEnglish::QuoteAPI.get_quote 
            rescue AsyncEnglish::Exceptions::QuoteAPIException => e
              reply = "Oops! failed to get quote: " + e.message
            rescue StandardError => e
              reply = "Oops! Something went wrong, contact the administrators to check it out"
              puts e.to_s
            end
          end

          def help 
            [
              "Hello dear, we have some commands to help you interact with me 🤖",
              "/start => I'll say hello",
              "/greet => I'll say hello for you",
              "/word [word] => Find definitions of the given word in WordAPI",
              "/qod => Give a random quote of the day",
              "/help => Show this help"
            ].join("\n")
          end
          
          def get_message(command, from) 
              case command
                when /start/i then start
                when /greet/i then greet(from.first_name)
                when /word/i 
                  word_to_search = command.split(" ")
                  return "Please, write just 1 word" if word_to_search.length != 2
                  word word_to_search[1]
                when /qod/i then qod
                when /help/i then help
                else "I have no idea what #{command} means."
              end
          end
        end
    end
end
