# frozen_string_literal: true

require 'telegram/bot'

token = 'token'

puts 'Start'
# Telegram::Bot::Client.run(token) do |bot|
  # bot.listen do |message|
    # case message.text
    # when '/start'
      # bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    # end
  # end
# end

require 'mongo_mapper'

MongoMapper.connection = Mongo::Client.new('mongodb://mongo:27017')

class User
  include ::MongoMapper::Document

  key :name, String
  key :age,  Integer

end
user = User.new(:name => 'Brandon')
user.save!

puts User.where(:name => 'Brandon').first
puts 'Success'
