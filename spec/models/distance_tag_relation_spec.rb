require 'rails_helper'

RSpec.describe DistanceTagRelation, type: :model do
  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }

    context 'distance' do
      let(:target) { :distance }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Distance'}
    end

    context 'tag' do
      let(:target) { :tag }
      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Tag'}
    end
  end
end
