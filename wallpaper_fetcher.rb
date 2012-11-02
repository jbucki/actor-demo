require 'celluloid'
require 'open-uri'
require 'nokogiri'

class WallpaperFetcher
  include Celluloid

  def fetch(url, directory)
    doc = Nokogiri::HTML(open(url))
    downloader = ImageDownloader.new

    total_saved = doc.xpath('//img').inject(0) do |sum, img|
      image_src = img.attr("src")
      downloader.file(image_src, directory)
      sum + 1
    end
  end

  def fetch_async(url, directory, downloader_pool)
    doc = Nokogiri::HTML(open(url))

    future_images = doc.xpath('//img').collect do |img|
      image_src = img.attr("src")
      downloader_pool.future(:file, image_src, directory)
    end

    future_images.inject(0) do |sum, future_image|
      future_image.value ? sum + 1 : sum
    end
  end
end

