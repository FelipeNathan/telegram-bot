module AsyncEnglish
    class Events
        class << self
            def on_new_members(new_chat_members, &block)
                members = new_chat_members.map { |user| "@#{user.username}" }.join(", ")
                welcome = "Welcome #{members}, please introduce yourself with your name, age and where do you live\n" +
                "Feel free to tell what do you do at your free time and/or what is your job\n" +
                "We encourage you to send audio if you're confortable, but if not, use text as well ^^" +
                "We dont have any professor, teacher, sensei or similar haha but we're free to correct our typos, grammar, pronounces and more..\n" +
                "Please, dont be offended, we're all learning and helping each other. \n\n" +
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