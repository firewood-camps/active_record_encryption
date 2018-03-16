# frozen_string_literal: true

module ActiverecordEncryption
  class Type < ActiveRecord::Type::Value
    delegate :type, to: :subtype

    attr_reader :name, :subtype, :db_type

    def initialize(name, subtype, db_type)
      @name = name
      @subtype = subtype
      @db_type = db_type
    end

    def cast(value)
      subtype.cast(value)
    end

    def deserialize(value)
      decrypt(value) if value
    end

    def serialize(value)
      encrypt(value) if value
    end

    private

    def decrypt(value)
      value
    end

    def encrypt(value)
      value
    end
  end
end