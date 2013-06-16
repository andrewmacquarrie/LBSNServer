class ImageData
  include Mongoid::Document
  
  field :image, type: String
  
  def create_from_base64(image_data)
    image = Magick::Image.read_inline(image_data)[0]
    image.resize_to_fill! 200
    self.image = Base64.encode64(image.to_blob)
  end
  
  def thumb_image
    image = Magick::Image.read_inline(self.image)[0]
    image.resize_to_fill! 75
    image.to_blob
  end
  
  def full_image
    Base64.decode64(self.image)
  end
end