require './environment'

set :run, true

get '/' do
end

get '/people/?' do
  person = Person.find(params["guid"])
  person.update_location(params["long"], params["lat"])
  people = person.closest(20)
  content_type :json
  people.to_json
end

post '/images/?' do
  im = ImageData.new
  im.create_from_base64(params[:imageData])
  im.save
  content_type :json
  { "_id" => im.id.to_s }.to_json
end

get '/images/?:id.jpg' do |id|
  content_type 'image/jpeg'
  params[:thumb] ? ImageData.find(id).thumb_image : ImageData.find(id).full_image
end

post '/people/update/photo/?' do
  person = Person.find(params["pguid"])
  person.photo = params["pictureId"]
  person.save
  ""
end

post '/people/update/apid/?' do
  person = Person.find(params["pguid"])
  person.apid = params["apid"]
  person.save
  ""
end
      
get '/messages/?' do
  if params["for"]
    msgs = Message.any_of( { :to => params["for"] }, { from: params["for"] } ).and(:_id.gt => params["latest"])
    content_type :json
    return msgs.to_json
  end
  m = Message.create(message: params["message"], to: params["to"], from: params["from"])
  Pusher[params["to"]].trigger!('new_message', {:id => m.id})
  content_type :json
  { "_id" => m.id.to_s }.to_json
end

get '/people/signup/?' do
  if Person.where(:email => params["email"]).first
    status 409
    content_type :json
    return { "error" => "Already exists" }.to_json
  end
  p = Person.create(password: params["password"], email: params["email"], location: {:lat => 51.597548, :lng => 0.021973})
  content_type :json
  { "_id" => p.id.to_s }.to_json
end
