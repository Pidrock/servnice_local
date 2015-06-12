require 'sinatra'
require 'mini_magick'
require 'base64'
require 'json'
require 'securerandom'

class App < Sinatra::Base
  class NotAuthorized  < StandardError; end

  configure do
    set :port, ENV['PORT'] || 9384
  end

  FORCED_WIDTH  = 1920
  FORCED_HEIGHT = 1080

  configure :development do
   # register Sinatra::Reloader

   # set :raise_errors,    false
   # set :show_exceptions, false
   # set :dump_errors,     false
  end

  get '/favicon.ico' do
    fav = <<-EOF
      AAABAAEAEBAQAAAAAAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAgAAAAAAAAAAAAAAAEAAA
      AAAAAACUaAkA6+jhANZ3CwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAACIiIiIiIiIAIiIiIiIiIgAgAAAAAAACACAQEBAQEQIAIAAAAA
      AAAgAiIiIiIiIiACIiIiIiIiIAIiIiIiIiIgAgAAAiAAACACARECIBEQIAIBAQIgEBAgAgERAiAR
      ECACAAACIAAAIAIiIiIiIiIgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    EOF

    file = Base64.decode64(fav)
    cache_control :public, :max_age => 3600 * 24 * 365 # 1 year

    content_type "image/x-icon"
    file
  end

  get '/' do
    error(404, "go away")
  end

  get '/:domain/:image*' do
    content_type "image/png"

    image = params[:image].chomp(File.extname(params[:image]))
    uuid, width, aspect_x, aspect_y, x1, y1, crop_width = image.split('-')

    if (aspect_x.nil? || aspect_y.nil? || x1.nil? || y1.nil? || crop_width.nil?) && !width.nil?
      width  = width
      height = ( (FORCED_HEIGHT / FORCED_WIDTH.to_f) * width.to_i ).to_i
    elsif width.nil?
      width, height = [FORCED_WIDTH, FORCED_HEIGHT]
    else
      width  = width
      height = ( ( aspect_y.to_f / aspect_x.to_i) * width.to_i ).to_i
    end

    generate_image(width, height)
  end

  post '/:domain' do
    require_api_key

    random_uuid = SecureRandom.urlsafe_base64(16, false).gsub('-','a').gsub('_','b').downcase
    {uuid: random_uuid, width: FORCED_WIDTH, height: FORCED_HEIGHT, mimetype: "image/jpeg"}.to_json
  end

  delete '/:domain/:uuid' do
    require_api_key
    {uuid: params[:uuid], status: "deleted"}.to_json
  end

  def error(statuscode, message)
    content_type :json
    status statuscode.to_i
    {:error => message}.to_json
  end

  error NotAuthorized do
    e = env['sinatra.error']
    error(401, e.message)
  end

 private
  def require_api_key
    api_key = params[:api_key] || request.env['HTTP_API_KEY']
    raise NotAuthorized, 'API-key wrong or missing' if api_key.nil?
  end

  def generate_image(width, height)
    original_image = MiniMagick::Image.open( File.expand_path(File.join(File.dirname(__FILE__), "assets/1x1.png") ))

    original_image.combine_options do |c|
      c.quality(80)
      c.resize("#{width}x#{height}!")
      c.fill(random_rgb)
      c.draw("rectangle 0,0 #{width},#{height}")
    end

    original_image.to_blob
  end

  def random_rgb
    @hexs ||= ["#b2996e","#65ab7c","#a5a391","#0a5f38","#9bb53c","#afa88b","#ccad60","#983fb2","#c48efd","#fffd78","#fffa86","#7e4071","#1d5dec","#054907","#b5ce08","#8fb67b","#6832e3","#fdb147","#c7ac7d","#f2ab15","#ac4f06","#875f42","#fd8d49","#698339","#7f8f4e","#63a950","#2138ab","#fefcaf","#fcf679","#cb6843","#ffffb6","#86a17d","#13bbaf","#20f986","#01c08d","#ac7434","#8e7618","#fdff63","#ba9e88","#23c48b","#9d0216","#fd5956","#d6fffa","#54ac68","#fc86aa","#030764","#fe86a4","#d5174e","#680018","#fedf08","#fe420f","#ca0147","#1b2431","#beae8a","#5d21d0","#feb209","#4e518b","#85a3b2","#005f6a","#0c1793","#ffff81","#fc824a","#71aa34","#ffc512","#750851","#fd798f","#647d8e","#d725de","#a87dc2","#fff9d0","#758da3","#77a1b5","#8756e4","#9f8303","#1e9167","#b5c306","#1ef876","#bbf90f","#a484ac","#ffa62b","#01b44c","#ff6cb5","#76ff7b","#730039","#6ecb3c","#d94ff5","#c8fd3d","#4e5481","#9cef43","#18d17b","#6258c4","#8f8ce7","#24bca8","#cbf85f","#f1da7a","#a8a495","#ffff7e","#ef4026","#3c9992","#fef69e","#cfaf7b","#9b5fc0","#0f9b8e","#742802","#a4bf20","#ada587","#a2653e","#77ab56","#464196","#af6f09","#bf9b0c","#7bc8f6","#f5bf03","#536267","#5a06ef","#cf0234","#03012d","#770001","#990f4b","#8f7303","#acbb0d","#828344","#ab1239","#ef1de7","#fbdd7e","#fd4659","#920a4e","#9a3001","#befdb7","#c1fd95","#fb2943","#b66325","#ffffcb","#bd6c48","#ac1db8","#c69c04","#f4d054","#c9ae74","#c69f59","#042e60","#985e2b","#a6814c","#9d7651","#feffca","#98568d","#9e003a","#ff7855","#c5c9c7","#feb308","#f4320c","#a13905","#2b5d34","#2976bb","#a87900","#7f5f00","#8a6e45","#c0fa8b","#faee66","#7b002c","#017b92","#fcc006","#738595","#f29e8e","#fdff52","#de0c62","#ffb16d","#5539cc","#017a79","#0b5509","#2000b1","#94568c","#c44240","#90b134","#b26400","#7f5e00","#ffffd4","#3b638c","#05472a","#3d0734","#4a0100","#735c12","#9c6d57","#b66a50","#1fa774","#01a049","#82cafc","#c875c4","#b00149","#ff9408","#e17701","#343837","#6a79f7","#3d1c02","#be0119","#a9561e","#ca6641","#5cac2d","#769958","#a2a415","#d46a7e","#1e488f","#80013f","#069af3","#6c3461","#40a368","#fc5a50","#ffffc2","#a03623","#87ae73","#ffffff","#380835","#a5a502","#ed0dd9","#8c000f","#bf9005","#0485d1","#a83c09","#516572","#fac205","#80f9ad","#a57e52","#e2ca76","#9ffeb0","#c1f80a","#b9a281","#aaa662","#610023","#580f41","#dbb40c","#01153e","#04d8b2","#cf6275","#ceb301","#380282","#aaff32","#8e82fe","#ffb07c","#000000","#cea2fd","#e6daa6","#ff796c","#6e750e","#650021","#ae7181","#13eac9","#00ffff","#d1b26f","#c79fef","#06c2ac","#9a0eea","#929591","#ffff14","#c20078","#f97306","#029386","#e50000","#653700","#ff81c0","#0343df","#15b01a","#7e1e9c"]
    @hexs.sample
  end
end

App.run!
