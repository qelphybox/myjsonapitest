# encoding: utf-8

require 'sinatra'
require 'jsonapi-serializers'
require 'jsonapi/parser'
require 'faker'
require 'json'
require 'byebug'

module JSONAPI
  module Parser
    class Document
      def self.parse_attributes!(attrs)
          ensure!(attrs.is_a?(Hash),
            'The value of the attributes key MUST be an object.')
          attrs
      end
    end
  end
end

## MODEL
class Post
  attr_accessor :title, :content, :id
  def initialize(id, title, content)
    @id, @title, @content = id, title, content
  end
end

## DB :)
$counter = 0
$posts = []

def new_id
  $counter += 1
end

def post(id)
  $posts.find { |p| p.id == id }
end

def new_post
  $posts << Post.new(new_id, Faker::Hipster.word, Faker::Hipster.sentence)
end

10.times { new_post }

## SERIALIZER
class PostSerializer
  include JSONAPI::Serializer
  attributes :title, :content
end

## SINATRA CONFIG

configure do
  mime_type :json_api, 'application/vnd.api+json'
end

## SINATRA API

get '/posts', provides: :json_api do
  JSONAPI::Serializer.serialize($posts, is_collection: true).to_json
end

get '/posts/:id', provides: :json_api do
  JSONAPI::Serializer.serialize(post(params[:id].to_i)).to_json
end

post '/posts', provides: :json_api do
  hash = JSON.parse(request.body.read)
  p JSONAPI.parse_resource!(hash)
  status 201
end

patch '/posts/:id', provides: :json_api do
  puts "PARAMS #{params.inspect}"
  puts "REQUEST #{request.inspect}"
  status 200
end
