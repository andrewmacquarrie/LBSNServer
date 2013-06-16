class Person
  include Mongoid::Document
  include Mongoid::Spacial::Document
  
  field :location, type: Array, spacial: true
  field :email, type: String
  field :password, type: String
  field :photo, type: String
  
  spacial_index :location
  
  def closest(limit)
    Person.geo_near(self.location, :unit => :m, :num => limit, :spherical => true)
  end
  
  def update_location(long, lat)
    self.location = {:lat => lat, :lng => long}
    self.save
  end
end