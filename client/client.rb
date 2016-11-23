# encoding: utf-8

require 'json_api_client'
require 'byebug'

class Base < JsonApiClient::Resource
  self.site = "http://192.168.33.133:4567"
end

class Post < Base
end
