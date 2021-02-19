module AsyncEnglish
    class QuoteAPI
        class << self

            def get_quote    
                params = {}
                params[:language] = "en"
                params[:category] = random_category
            
                response = rest_request("/qod", params)
                raise AsyncEnglish::Exceptions::QuoteAPIException.new response.message unless response.is_a? Net::HTTPSuccess

                json = JSON.parse(response.read_body, object_class: OpenStruct)
                format_quote_reply json
            end

            private
                BASE_PATH = "https://quotes.rest"

                def rest_request(uri, params = {})
                    url = URI("#{BASE_PATH}#{uri}")
                    url.query = URI.encode_www_form(params)

                    puts url

                    http = Net::HTTP.new(url.host, url.port)
                    http.use_ssl = true
                    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

                    request = Net::HTTP::Get.new(url)
                    request["accept"] = "application/json"

                    http.request(request)
                end

                def random_category
                    %w(inspire management sports life funny love art students).sample
                end

                def format_quote_reply(json)
                    
                    quote_info = json.contents&.quotes[0]

                    category = quote_info[:category]
                    author = quote_info[:author]
                    quote = quote_info[:quote]
                    link = quote_info[:permalink]

                    reply = "Quote of the day about <b>#{category}</b>\n\n"
                    reply += "\"#{quote}\" (#{author}) \n\n"
                    reply += "<a href=\"#{link}\">Link to quote</a>"
                    reply
                end
        end
    end
end