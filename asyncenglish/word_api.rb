module AsyncEnglish
    class WordAPI
        class << self

            def get_definition_of(word)
                url = URI("https://wordsapiv1.p.rapidapi.com/words/#{word}/definitions")

                http = Net::HTTP.new(url.host, url.port)
                http.use_ssl = true
                http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                request = Net::HTTP::Get.new(url)
                request["x-rapidapi-key"] = AsyncEnglish::RAPID_API_KEY
                request["x-rapidapi-host"] = AsyncEnglish::RAPID_API_HOST

                response = http.request(request)
                raise AsyncEnglish::Exceptions::WordAPIException.new response.message unless response.is_a? Net::HTTPSuccess

                json = JSON.parse(response.read_body, object_class: OpenStruct)

                format_reply json
            end

            private
                def format_reply(json)

                    definitions = json&.definitions&.map do | d | 
                        format = "<b>Definition</b>: #{d.definition}\n"
                        format += "<b>Part of speech</b>: #{d.partOfSpeech}" unless d.partOfSpeech.nil?
                        format
                    end

                    reply = "<b>Word</b>: #{json&.word}\n\n"
                    reply += definitions&.join("\n\n")
                    reply
                end
        end
    end
end