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

    User.create!(
      tg_id: tg_id,
      tg_username: username,
      created_at: Time.current,
      updated_at: Time.current
    )
  end

  def add_birthday(user_id:, name:, telegram_login:, date:)
    bd = Birthday.find_by_user_id_and_telegram_login_and_date(
      user_id,
      telegram_login,
      date
    )

    return if bd

    Birthday.create!(
      user_id: user_id,
      name: name,
      telegram_login: telegram_login,
      date: Date.parse(date),
      created_at: Time.current,
      updated_at: Time.current
    )
  end
end

Telegram::Bot::Client.run(token) do |bot|
  repo = Repo.new

  bot.listen do |message|
    user = repo.register_user(
      tg_id: message.chat.id,
      username: message.from.first_name
    )

    case message.text
    when '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hello, #{message.from.first_name}"
      )

    when '/list'
      bds = Birthday.where(user_id: user.id).map do |bd|
        "#{bd.name} #{bd.date}"
      end.join("\n")

      bot.api.send_message(
        chat_id: message.chat.id,
        text: bds
      )
    else
      name, telegram_login, date = message.text.split(',')

      puts user.id
      bd = repo.add_birthday(user_id: user.id, name: name, telegram_login: telegram_login, date: date)

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "#{name} #{telegram_login} #{date} ##{bd.id}"
      )
    end
  end
end
