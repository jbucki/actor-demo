require './wallpaper_fetcher.rb'
require './image_downloader.rb'

sync_directory = ARGV[0]
url = ARGV[1]
pool_size = ARGV[2] ? ARGV[2].to_i : 0
start_time = Time.now
fetcher = WallpaperFetcher.new

unless sync_directory && url
  puts "Please provide a sync directory and at least 1 URL."
  exit
end

Dir.mkdir(sync_directory) unless Dir.exists?(sync_directory)

if pool_size > 0
  downloader_pool = ImageDownloader.pool(size: pool_size)
  total_saved = fetcher.fetch_async(url, sync_directory, downloader_pool)
else
  total_saved = fetcher.fetch(url, sync_directory)
end

puts "\n*************************************************************************************************\n"
puts " #{total_saved} images fetched and stored at #{sync_directory}"
puts ""
puts "Total time: #{Time.now - start_time} seconds\n\n"
puts "*************************************************************************************************\n"
