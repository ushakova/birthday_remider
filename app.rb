# frozen_string_literal: true

require 'dotenv/load'
require 'telegram/bot'

require 'mongo_mapper'
MongoMapper.connection = Mongo::Client.new('mongodb://mongo:27017')

require './models/base'
require './models/birthday'
require './models/user'

token = ENV['TOKEN']

puts 'Start'

class Repo
  def register_user(tg_id:, username:)
    puts "tg_id: #{tg_id}, username: #{username}"
    user = User.find_by_tg_id(tg_id: tg_id)
    return if user

    ::User.create!(
      tg_id: tg_id,
      tg_username: username,
      created_at: Time.current,
      updated_at: Time.current
    )
  end
end

Telegram::Bot::Client.run(token) do |bot|
  repo = Repo.new

  bot.listen do |message|
    case message.text
    when '/start'
      repo.register_user(
        tg_id: message.chat.id,
        username: message.from.first_name
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hello, #{message.from.first_name}"
      )
    end
  end
end
