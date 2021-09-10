class User < Base
  key :tg_id, String
  key :tg_username, String

  key :created_at, DateTime
  key :updated_at, DateTime
end
