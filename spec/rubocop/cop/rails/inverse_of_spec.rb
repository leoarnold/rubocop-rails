# frozen_string_literal: true

describe RuboCop::Cop::Rails::InverseOf do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  context 'with scope' do
    it 'registers an offense when not specifying `:inverse_of`' do
      expect_offense(<<-RUBY.strip_indent)
      class Person
        has_one :foo, -> () { where(bar: true) }
        ^^^^^^^ Specify an `:inverse_of` option.
      end
      RUBY
    end

    it 'does not register an offense when specifying `:inverse_of`' do
      expect_no_offenses(
        'has_many :foo, -> () { where(bar: true) }, inverse_of: false'
      )
    end
  end

  context 'with option preventing automatic inverse' do
    it 'registers an offense when not specifying `:inverse_of`' do
      expect_offense(<<-RUBY.strip_indent)
      class Person
        belongs_to :foo, foreign_key: 'foo_id'
        ^^^^^^^^^^ Specify an `:inverse_of` option.
      end
      RUBY
    end

    it 'does not register an offense when specifying `:inverse_of`' do
      expect_no_offenses(
        "has_one :foo, foreign_key: 'foo_id', inverse_of: :bar"
      )
    end

    it 'does not register an offense with `:inverse_of` as first option' do
      expect_no_offenses(
        "has_one :foo, inverse_of: :bar, foreign_key: 'foo_id'"
      )
    end

    it 'registers an offense with other option and `:inverse_of` unset' do
      expect_offense(<<-RUBY.strip_indent)
      class Person
        has_many :foo, class_name: "Bar", foreign_key: 'foo_id'
        ^^^^^^^^ Specify an `:inverse_of` option.
      end
      RUBY
    end
  end

  context 'with scope and options' do
    it 'registers an offense when not specifying `:inverse_of`' do
      expect_offense(<<-RUBY.strip_indent)
      class Person
        has_many :foo, -> { group 'x' }, through: :bar
        ^^^^^^^^ Specify an `:inverse_of` option.
      end
      RUBY
    end

    it 'does not register an offense when specifying `:inverse_of`' do
      expect_no_offenses(
        "has_many :foo, -> { group 'x' }, through: :bar, inverse_of: :baz"
      )
    end
  end

  context '`:polymorphic` option' do
    context 'Rails < 5.2', :rails5 do
      it 'registers an offense when not specifying `:inverse_of`' do
        expect_offense(<<-RUBY.strip_indent)
        class Person
          belongs_to :foo, polymorphic: true
          ^^^^^^^^^^ Specify an `:inverse_of` option.
        end
        RUBY
      end
    end

    context 'Rails >= 5.2', :config do
      let(:rails_version) { 5.2 }

      it 'does not register an offense when not specifying `:inverse_of`' do
        expect_no_offenses(
          'belongs_to :foo, polymorphic: true'
        )
      end
    end
  end

  context 'with no options' do
    it 'does not register an offense' do
      expect_no_offenses('has_one :foo')
    end
  end

  context 'with other options' do
    it 'does not register an offense' do
      expect_no_offenses('has_one :foo, dependent: :nullify')
    end
  end
end
