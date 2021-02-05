module AsyncEnglish
    class Commands 
        class << self
          def start; "All I can do is say hello. Try the /greet command."; end 
          def greet(first_name) "Hello, #{first_name}. 🤖"; end

          def word(wordToSearch = 'home')
            begin
              puts "Word to search: #{wordToSearch}"
              reply = AsyncEnglish::WordAPI.get_definition_of(wordToSearch)
            rescue StandardError => e
              reply = "Oops! failed to load: " + e.to_s
            end
      
            reply
          end 

          def qod; "Quote of the day here..." end

          def help 
            [
              "Hello dear, we have some commands to help you interact with me 🤖",
              "/start => I'll say hello",
              "/greet => I'll say hello for you",
              "/word <word> => Find definitions of the given word in WordAPI",
              "/qod => Give a random quote of the day",
              "/help => Show this help"
            ].join("\n")
          end
          
          def get_message(command, from) 
              case command
                when /start/i then start
                when /greet/i then greet(from.first_name)
                when /word/i 
                  wordToSearch = command.split(" ")
                  return "Please, write just 1 word" if wordToSearch.length != 2
                  word wordToSearch[1]
                when /qod/i then qod
                when /help/i then help
                else "I have no idea what #{command} means."
              end
          end
        end
    end
end
