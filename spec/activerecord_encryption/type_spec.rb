# frozen_string_literal: true

RSpec.describe ActiverecordEncryption::Type do
  describe '#cast' do
    subject { instance.cast(value) }

    let(:instance) { described_class.new(:name, subtype_instance, db_type_instance) }
    let(:subtype_instance) { ActiveRecord::Type.lookup(subtype) }
    let(:db_type_instance) { ActiveRecord::Type.lookup(:string) }

    context 'when db_type is integer' do
      let(:subtype) { :integer }

      context 'given 1' do
        let(:value) { 1 }
        it { is_expected.to eq(1) }
      end

      context 'given "1"' do
        let(:value) { '1' }
        it { is_expected.to eq(1) }
      end
    end

    context 'when db_type is datetime' do
      let(:subtype) { :datetime }

      context 'given "2018-01-01"' do
        let(:value) { '2018-01-01' }
        it { is_expected.to eq(Time.utc(2018, 1, 1).utc) }
      end

      context 'given ""' do
        let(:value) { '' }
        it { is_expected.to be_nil }
      end
    end
  end

  describe '#deserialize' do
    subject { instance.cast(value) }

    let(:instance) { described_class.new(:name, subtype_instance, db_type_instance) }
    let(:subtype_instance) { ActiveRecord::Type.lookup(subtype) }
    let(:db_type_instance) { ActiveRecord::Type.lookup(:string) }

    context 'when db_type is integer' do
      let(:subtype) { :integer }

      context 'given 1' do
        let(:value) { 1 }
        it { is_expected.to eq(1) }
      end

      context 'given "1"' do
        let(:value) { '1' }
        it { is_expected.to eq(1) }
      end
    end
  end
end