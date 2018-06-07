# frozen_string_literal: true

module ActiveRecordEncryption
  class Type < ActiveRecord::Type::Value
    using(ActiveRecordEncryption::SerializerWithCast)

    delegate :type, :cast, to: :subtype

    def initialize(subtype: ActiveRecord::Type.default_value, **options)
      # Lookup encryptor from options[:encryption]
      encryption_options = options.delete(:encryption) || ActiveRecordEncryption.default_encryption.clone
      encryptor = encryption_options.delete(:encryptor)
      @encryptor = ActiveRecordEncryption::Encryptor.lookup(encryptor, **encryption_options)

      subtype = ActiveRecord::Type.lookup(subtype, **options) if subtype.is_a?(Symbol)
      @subtype = subtype
      @binary = ActiveRecord::Type.lookup(:binary)
    end

    def deserialize(value)
      deserialized = binary.deserialize(value)
      subtype.deserialize(encryptor.decrypt(deserialized)) unless deserialized.nil?
    end

    def serialize(value)
      serialized = subtype.serialize(value)
      binary.serialize(encryptor.encrypt(serialized)) unless serialized.nil?
    end

    private

    attr_reader :subtype, :binary, :encryptor
  end
end
