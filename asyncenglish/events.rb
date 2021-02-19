module AsyncEnglish
    class Events
        class << self
            def on_new_members(new_chat_members, &block)
                members = new_chat_members.map { |user| "@#{user.username}" }.join(", ")
                welcome = "Welcome, #{members}. Please introduce yourself with your name, age, and where you live." +
                "Feel free to tell us what you do in your free time, and/or what your job is. \n\n" +
                "We encourage you to send audio messages if you feel comfortable doing so, but otherwise, use text. ^^ \n\n" +
                "We don't have any professors, teachers, sensei, or similar. haha But everyone is encouraged to correct each other's typos, grammar, pronunciation, etc." +
                "We ask that you don't feel offended if corrected - we're all here to learn and help each other.\n\n" +
                "Enjoy!".strip
                yield welcome
            end

            def on_command(cmd, from, &block)
                puts "@#{from.username}: #{cmd}"
                reply = AsyncEnglish::Commands.get_message cmd, from
                yield reply
            end
        end
    end
end