module Teamwork
  TEAMWORK_URL = "https://theironyard.teamwork.com"
  JOURNALS_ID = 135182

  class Error < StandardError ; end
  class AuthenticationError < Error ; end

  class Client
    include HTTParty

    base_uri TEAMWORK_URL
    headers "Accept" => "application/json", "Content-Type" => "application/json"

    def initialize api_key
      @auth = { username: api_key, password: "" }
    end

    def authenticate!
      response = get "/projects/#{JOURNALS_ID}"
      if [401, 403].include? response.code
        raise AuthenticationError
      elsif response.code != 200
        raise Error
      end
    end

    def all_journals
      r = get "/projects/#{JOURNALS_ID}/messages"
      posts = r.fetch "posts"
      2.upto r.headers["x-pages"].to_i do |n|
        r = get "/projects/#{JOURNALS_ID}/messages", query: { page: n }
        posts += r.fetch "posts"
      end
      posts
    end

    def update_journal_category! remote_id, journal_data, remote_category_id
      raise unless remote_id.to_s == journal_data.fetch('id')
      response = self.class.put "/posts/#{remote_id}.json",
        body: { "post" => { "category-id" => remote_category_id } }.to_json,
        basic_auth: @auth
      unless response.code == 200
        raise "Failed to update journal: #{response} (#{response.code})"
      end
    end

    def authors
      get("/projects/#{JOURNALS_ID}/people").fetch("people")
    end

    def categories
      get("/projects/#{JOURNALS_ID}/messageCategories").fetch("categories")
    end

    def get endpoint, opts={}
      opts[:basic_auth] = @auth
      self.class.get "#{endpoint}.json", opts
    end
  end
end
