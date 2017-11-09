require 'sinatra'

LETTERS = Array('a'..'z')

def generate_short_url
  Array.new(6){LETTERS.sample}.join
  p Array.new(6){LETTERS.sample}.join
end

get '/:url' do
  redirect "http://#{ShortURL.read(params[:url])}"
end

get '/' do
  "Send a POST request to register a new url"
end

post '/' do
  ShortURL.save(generate_short_url, params[:url])
  "New URL added: localhost:4567/#{generate_short_url} \n"
end


class ShortURL
  require "pstore"

  def self.save(code, original)
    store.transaction do |t|
       t[code] = original
       t.commit
       p "saved #{t[code]}"
     end
  end
  def self.read(code)
    p "inside read using #{code}"
    p "#{store[code]}"
    store.transaction{|t| t[code]}
  end

  def self.store
    @store ||= PStore.new("short_urls.pstore")
  end
end

