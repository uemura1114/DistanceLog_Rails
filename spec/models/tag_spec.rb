require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Association' do
    let(:association) { described_class.reflect_on_association(target) }
    
    context 'distance_tag_relations' do
      let(:target) { :distance_tag_relations }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.options).to eq :dependent => :delete_all }
      it { expect(association.class_name).to eq 'DistanceTagRelation'}
    end

    context 'distances' do
      let(:target) { :distances }
      it { expect(association.macro).to eq :has_many }
      it { expect(association.options).to eq :through => :distance_tag_relations }
      it { expect(association.class_name).to eq 'Distance'}
    end
  end
end
