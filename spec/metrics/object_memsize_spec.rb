require 'spec_helper'

RSpec.describe 'Metrics::ObjectMemsize' do
  let(:object) { [] }
  let(:other) { [] }
  let(:metric) { Mnemonic::Metric::ObjectMemsize.new(object: object) }

  it 'has the correct name' do
    expect(metric.name).to eq "Memsize(#{object.inspect})"
  end

  it 'has the correct kind' do
    expect(metric.kind).to eq :bytes
  end

  it 'measures memory diff of its object' do
    start = object.clone

    metric.start!
    10.times { object << "foo" }
    metric.refresh!

    expect(metric.diff).to eq ObjectSpace.memsize_of(object) - ObjectSpace.memsize_of(start)
  end

  it 'ignores differences of the other objects' do
    metric.start!
    10.times { other << "foo" }
    metric.refresh!

    expect(metric.diff).to eq 0
  end
end
