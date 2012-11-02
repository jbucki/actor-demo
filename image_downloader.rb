require 'celluloid'
require 'open-uri'

class ImageDownloader
  include Celluloid

  # Downloads image from "image_url" and stores it in the specified local directory
  def file(image_url, directory)
    return unless image_url.match("http://")

    puts "Fetching image at #{image_url}"

    remote_data = open(image_url).read # "open" is an open-uri method
    extension = File.extname(image_url)
    filename = File.basename(image_url, extension) + extension
    filepath = File.join(directory, filename)

    File.open(filepath, "w") do |local_file|
      local_file.write(remote_data)
    end

    true
  end
end

