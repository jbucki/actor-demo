require './wallpaper_fetcher.rb'
require './image_downloader.rb'

sync_directory = ARGV[0]
urls = ARGV[1..-1].to_a
start_time = Time.now
fetcher = WallpaperFetcher.new
downloader_pool = ImageDownloader.pool(size: 50)

if !sync_directory || urls.empty?
  puts "Please provide a sync directory and at least 1 URL."
  exit
end

Dir.mkdir(sync_directory) unless Dir.exists?(sync_directory)

if urls.last.match("^-a")
  async = true
  urls.pop # remove last URL since its actually our async flag
else
  async = false
end

# Fetch images (keeping track of total count) for each URL
total_count = urls.inject(0) do |sum, url|
  if async
    total_saved = fetcher.fetch_async(url, sync_directory, downloader_pool)
  else
    total_saved = fetcher.fetch(url, sync_directory)
  end

  puts "\n\nTotal images for #{url}: #{total_saved}\n\n"
  sum + total_saved
end

puts "\n*************************************************************************************************\n"
puts " #{total_count} images fetched and stored at #{sync_directory}"
puts ""
puts "Total time: #{Time.now - start_time} seconds\n\n"
puts "*************************************************************************************************\n"
