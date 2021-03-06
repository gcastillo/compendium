require 'spec_helper'
require 'compendium/presenters/table'

describe Compendium::Presenters::Table do
  let(:template) { double('Template') }
  let(:results) { double('Results', records: [{ one: 1, two: 2 }, { one: 3, two: 4 }], keys: [:one, :two]) }
  let(:query) { double('Query', results: results, options: {}) }
  let(:table) { described_class.new(template, query) }

  context 'settings' do
    subject { table.settings }

    context 'default settings' do
      its(:number_format) { should == '%0.2f' }
      its(:table_class) { should == 'results' }
      its(:header_class) { should == 'headings' }
      its(:row_class) { should == 'data' }
      its(:totals_class) { should == 'totals' }
      its(:display_nil_as) { should be_nil }
    end

    context 'overriding settings' do
      let(:table) do
        described_class.new(nil, query) do |t|
          t.number_format '%0.1f'
          t.table_class 'report_table'
          t.header_class 'report_heading'
          t.display_nil_as 'N/A'
        end
      end

      its(:number_format) { should == '%0.1f' }
      its(:table_class) { should == 'report_table' }
      its(:header_class) { should == 'report_heading' }
      its(:display_nil_as) { should == 'N/A' }
    end
  end

  context 'render' do
    before do
      template.stub(:content_tag) { |element, *, &block| block.nil? ? element : table.instance_exec(&block) }
      template.stub(:t) { |key| key }
    end

    it 'should use the table class given in settings' do
      table.settings.table_class 'report_table'

      template.should_receive(:content_tag).with(:table, class: 'report_table')
      table.render
    end

    it 'should use the default table class if not overridden' do
      template.should_receive(:content_tag).with(:table, class: 'results')
      table.render
    end

    it 'should build the heading row' do
      template.should_receive(:content_tag).with(:tr, class: 'headings')
      template.should_receive(:content_tag).with(:th, :one)
      template.should_receive(:content_tag).with(:th, :two)
      table.render
    end

    it 'should use the overridden heading class if given' do
      table.settings.header_class 'report_header'

      template.should_receive(:content_tag).with(:tr, class: 'report_header')
      table.render
    end

    it 'should build data rows' do
      template.should_receive(:content_tag).with(:tr, class: 'data').twice
      table.render
    end

    it 'should use the overridden row class if given' do
      table.settings.row_class 'report_row'

      template.should_receive(:content_tag).with(:tr, class: 'report_row').twice
      table.render
    end

    it 'should add a totals row if the query has totals: true set' do
      query.options[:totals] = true

      template.should_receive(:content_tag).with(:tr, class: 'totals')
      table.render
    end

    it 'should not add a totals row if the query has totals: false set' do
      query.options[:totals] = false

      template.should_not_receive(:content_tag).with(:tr, class: 'totals')
      table.render
    end

    it 'should not add a totals row if the query does not have :totals set' do
      query.options.delete(:totals)

      template.should_not_receive(:content_tag).with(:tr, class: 'totals')
      table.render
    end

    it 'should use the totals class if that setting is overridden' do
      query.options[:totals] = true
      table.settings.totals_class 'report_totals'

      template.should_receive(:content_tag).with(:tr, class: 'report_totals')
      table.render
    end
  end
end