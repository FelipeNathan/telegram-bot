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
                json = JSON.parse(response.read_body, object_class: OpenStruct)

                resolve json
            end

            def resolve(json)

                definitions = json&.definitions&.map do | d | 
                    resolve = "<b>Definition</b>: #{d.definition}\n"
                    resolve += "<b>Part of speech</b>: #{d.partOfSpeech}" unless d.partOfSpeech.nil?
                    resolve
                end

                reply = "<b>Word</b>: #{json&.word}\n\n"
                reply += definitions&.join("\n\n")
                reply
            end
        end
    end
end