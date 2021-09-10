class Birthday < Base
  key :user_id, ObjectId

  key :name, String
  key :telegram_login, String

  key :date, DateTime
  key :created_at, DateTime
  key :updated_at, DateTime
end
