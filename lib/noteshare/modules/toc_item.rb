require 'json'
require_relative '../modules/tools'
include Noteshare::Tools

module Noteshare



  TOCItem = Struct.new(:id, :title, :identifier, :has_subdocs) do

    def encode
      self.to_h.to_json
    end

    def self.from_hash(hash)
      # hash = Noteshare::Tools.symbolize_keys(hash)
      keys = hash.keys
      return if keys.count == 0
      if keys[0].class.name == 'Symbol'
        self.new(hash[:id], hash[:title], hash[:identifier], hash[:subdocs])
      else
        self.new(hash['id'], hash['title'], hash['identifier'], hash['subdocs'])
      end
    end

    def self.decode(str)
      hash = JSON.parse str
      self.new(hash['id'], hash['title'], hash['identifier'], hash['subdocs'])
    end

    def self.decode2(str)
      hash = JSON.parse str
      self.from_hash(hash)
    end

    def display
      out = ""
      out << "id: " << id.to_s << ", "
      out << "title: " << title << "\n"
    end

  end


  ObjectItem = Struct.new(:id, :title) do

    def encode
      self.to_h.to_json
    end

    def self.from_hash(hash)
      # hash = Noteshare::Tools.symbolize_keys(hash)
      keys = hash.keys
      return if keys.count == 0
      if keys[0].class.name == 'Symbol'
        self.new(hash[:id], hash[:title])
      else
        self.new(hash['id'], hash['title'])
      end
    end

    def self.decode(str)
      hash = JSON.parse str
      self.new(hash['id'], hash['title'])
    end

    def self.decode2(str)
      hash = JSON.parse str
      self.from_hash(hash)
    end

    def to_h
      { id: id, title: title }
    end

    def display
      out = ""
      out << "id: " << id.to_s << ", "
      out << "title: " << title << "\n"
    end

  end

  class ObjectItemList

    attr_reader :obj_item_array

    def initialize(array)

      @table = []

      array.each do |item|
        obj_item =  ObjectItem.from_hash(item)
        @table << obj_item
      end
    end

    def to_hash_array
      @table.map{ |x| x.to_h }
    end

    def encode
      to_hash_array.to_json
    end

    def self.decode(str)
      ObjectItemList.new(JSON.parse(str))
    end

    def display
      str = "\n-------\nTABLE:\n"
      @table.each do |item|
        str << item.display
      end
      str << "-------\n#{@table.count}\n"
    end

    def table
      @table
    end

    def save
      # new_table = table.map{ |item| item.to_h}
      # @document.toc = new_table
    end

    def save!
      # save
      # DocumentRepository.update @document
    end

    def insert(k, toc_item)
      @table.insert(k, toc_item)
    end

    # Return the toc item with given id
    def get(id)
      target = nil
      table.each do |item|
        if item.id == id
          target = item
          break
        end
      end
      target
    end

    def get_title(id)
      get(id).title
    end

    def change_title(id, new_title)
      target = nil
      table.each do |item|
        if item.id == id
          target = item
          target.title = new_title
          break
        end
      end
      target
    end


  end

end