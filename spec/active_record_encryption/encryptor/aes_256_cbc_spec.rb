# frozen_string_literal: true

RSpec.describe ActiveRecordEncryption::Encryptor::Aes256Cbc do
  describe 'InstanceMethods' do
    describe '#encrypt/decrypt' do
      def build_instance(**options)
        key = SecureRandom.random_bytes(32)
        described_class.new(key: key, **options)
      end

      let(:value) { 'hello world' }

      context 'with :encoding options' do
        it 'encodes result' do
          instance = build_instance(encoding: Encoding::BINARY)
          encrypted = instance.encrypt(value)
          decrypted = instance.decrypt(encrypted)

          expect(decrypted.encoding).to eq(Encoding::BINARY)
        end
      end

      context 'when key is same' do
        it 'encrypts/decrypts value' do
          instance = build_instance
          encrypted = instance.encrypt(value)

          expect(encrypted).to_not eq(value)

          decrypted = instance.decrypt(encrypted)
          expect(decrypted).to eq(value)
        end

        it 'generates different result' do
          instance = build_instance

          encrypted_1 = instance.encrypt(value)
          encrypted_2 = instance.encrypt(value)

          expect(encrypted_1).to_not eq(encrypted_2)
        end
      end

      context 'when key is changed' do
        it "doesn't decrypt value" do
          instance_1 = build_instance
          instance_2 = build_instance

          encrypted = instance_1.encrypt(value)

          expect { instance_2.decrypt(encrypted) }.to raise_error(OpenSSL::Cipher::CipherError)
        end
      end
    end
  end
end
