require 'open-uri'
require 'net/http'

def wget(args)
  urls = args.split(",")

  FileUtils::mkdir_p 'wget' if !Dir.exists?('./wget')
  begin
    Thread.new do 
      urls.map do |url|
        open(url.to_s, "User-Agent" => "Ruby/#{RUBY_VERSION}") { |f|
          response = Net::HTTP.get_response(URI.parse(url))

          print "\nDownloading [%s] - %s - [%s]" % [File.basename(url), (response['content-length'].to_i.to_filesize).to_s.green, f.content_type]

          File.open("wget/#{File.basename(URI.encode(url))}", 'wb') { |ff| ff << open(url).read }

          print " [OK]"
        }
      end.each(&:join)
    end
  rescue OpenURI::HTTPError => e
    handle_error "wget: #{e}"
  rescue SocketError, Errno::EINVAL, Errno::ECONNRESET, Errno::ETIMEDOUT, Net::ReadTimeout
    retry
  end
end
