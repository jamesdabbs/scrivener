module Teamwork
  TEAMWORK_URL = "https://theironyard.teamwork.com"
  JOURNALS_ID = 135182

  class Client
    include HTTParty

    base_uri TEAMWORK_URL
    headers "Accept" => "application/json", "Content-Type" => "application/json"

    def initialize api_key
      @auth = { username: api_key, password: "" }
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
