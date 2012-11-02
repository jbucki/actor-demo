require 'celluloid'
require 'open-uri'
require 'nokogiri'

class WallpaperFetcher
  include Celluloid

  attr_reader :image_count

  def initialize(downloader_pool)
    @image_count = 0
    @downloader_pool = downloader_pool
  end

  def fetch(url, sync_directory)
    puts "Fetching wallpapers at #{url}"

    doc = Nokogiri::HTML(open(url))

    future_images = doc.xpath('//img').collect do |img|
      image_src = img.attr("src")
      @downloader_pool.future(:file, image_src, sync_directory)
    end

    total_saved = future_images.inject(0) do |sum, future_image|
      future_image.value ? sum + 1 : sum
    end

    puts "Total images for #{url}: #{total_saved}"

    total_saved
  end
end

