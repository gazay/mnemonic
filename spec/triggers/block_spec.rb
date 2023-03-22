# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'trigger with block' do
  let(:mnemonic) { Mnemonic.new { |c| c.objects_count(:T_ARRAY) } }
  let(:output) { StringIO.new }
  let(:data) { JSON.parse(output.string) }

  it 'counts changes inside the block' do
    mnemonic.attach_json(output)
    [].tap do |list|
      mnemonic.trigger! { list << [] }
      2.times { list << [] } # these changes are ignored
      mnemonic.trigger! { 4.times { list << [] } }
    end
    mnemonic.detach_all

    expect(data).to eq([{ 'Count(:T_ARRAY)' => 1 }, { 'Count(:T_ARRAY)' => 5 }])
  end
end
