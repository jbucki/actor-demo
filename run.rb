require './wallpaper_fetcher.rb'
require './image_downloader.rb'

sync_directory = ARGV[0]
urls = ARGV[1..-1].to_a

start_time = Time.now

if !sync_directory || urls.empty?
  puts "Please provide a sync directory and at least 1 URL."
  exit
end

Dir.mkdir(sync_directory) unless Dir.exists?(sync_directory)

downloader_pool = ImageDownloader.pool(size: 50)
worker_pool = WallpaperFetcher.pool(size: 5, args: [downloader_pool])

future_image_counts = urls.map do |url|
  worker_pool.future(:fetch, url, sync_directory)
end

puts "\nLook, the program is continuing execution!!!\n\n"

total_count = future_image_counts.map(&:value).inject(&:+)

puts "\n*************************************************************************************************\n"
puts " #{total_count} images fetched and stored at #{sync_directory}"
puts "*************************************************************************************************\n"
puts ""
puts "Total time: #{Time.now - start_time} seconds\n\n"
