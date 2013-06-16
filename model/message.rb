class Message
  include Mongoid::Document
  
  field :message, type: String
  field :to, type: String
  field :from, type: String
end