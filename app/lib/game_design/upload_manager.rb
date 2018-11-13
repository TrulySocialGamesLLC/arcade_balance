require 'bigdecimal'
require 'csv'

module GameDesign
  class UploadManager

    module Sheets
      TESTS = 'test'
    end

    #  Creates new game design entities.
    #
    class CreateStrategy

      #  Processes the data.
      #
      def process!(current_table, attributes)
        model = ::GameDesign::UploadManager::TABLES[ current_table ].dup
        model.attributes = attributes

        model.save!
      end

      def finalize!
      end

    end

    #  Memoizes changes against current game design.
    #
    class DiffStrategy

      attr_accessor :configuration

      attr_accessor :changed

      attr_accessor :added

      attr_accessor :scopes

      def initialize
        self.changed  = []
        self.added    = []
        self.scopes   = {}
      end

      #  Processes the data.
      #
      def process!(current_table, attributes)
        model = ::GameDesign::UploadManager::TABLES[ current_table ]

        scope_attributes = attributes.with_indifferent_access.slice( *model.scope_attributes )
        scope_attributes[:table_name] = model.table_name if model.respond_to?(:table_name) && model.table_name.present?
        scope_attributes[:table_name] = attributes[:table_name] if attributes.has_key?(:table_name)

        unless self.scopes.has_key?( model.class )
          self.scopes[ model.class ] = model.class.where(configuration_id: self.configuration.id).load.index_by(&:id)
        end

        existing = model.class.where(configuration_id: self.configuration.id).where( scope_attributes ).load

        if existing.size == 0
          self.added << model.dup.tap { |m| m.attributes = attributes }
        else
          existing.each do |e|
            e.attributes = attributes
            self.scopes[ model.class ].delete( e.id )
          end

          self.changed += existing.select(&:changed?) if existing.any?(&:changed?)
        end
      end

      #  Returns models not seen by the import.
      #
      def removed
        self.scopes.values.flatten.map(&:values).flatten
      end

      def finalize!
      end

    end

    #  Memoizes changes against current game design.
    #
    class UpdateStrategy

      attr_accessor :configuration

      attr_accessor :scopes

      def initialize
        self.scopes   = {}
      end

      #  Processes the data.
      #
      def process!(current_table, attributes)
        model = ::GameDesign::UploadManager::TABLES[ current_table ]

        scope_attributes = attributes.with_indifferent_access.slice( *model.scope_attributes )
        scope_attributes[:table_name] = model.table_name if model.respond_to?(:table_name) && model.table_name.present?
        scope_attributes[:table_name] = attributes[:table_name] if attributes.has_key?(:table_name)

        unless self.scopes.has_key?( model.class )
          self.scopes[ model.class ] = model.class.where(configuration_id: self.configuration.id).load.index_by(&:id)
        end

        existing = model.class.where(configuration_id: self.configuration.id).where( scope_attributes ).load

        if existing.size == 0
          ::GameDesign::UploadManager::TABLES[ current_table ].dup.update_attributes!( attributes.merge( configuration_id: self.configuration.id ) )
        else
          existing.each do |e|
            e.update_attributes!( attributes )
            self.scopes[ model.class ].delete( e.id )
          end
        end
      end

      def finalize!
        self.scopes.values.flatten.map(&:values).flatten.each &:destroy
      end

    end

    SHEETS = [Sheets::TESTS]

    TABLES = {
        # Test
        hud_ab_tests:                      Tests::HudAbTest.new
    }

    REQUIRES_SEPARATION = []

    FILTER_KEYS = ['id', 'configuration_id', 'created_at', 'updated_at']

    REGEXP_NAMES_MAP = {
        /^resources:\s?(\w+)$/  => (-> (value) { /^resources:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^resource:\s?(\w+)$/   => (-> (value) { /^resource:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^perfect:\s?(\w+)$/    => (-> (value) { 'perfect_' + /^perfect:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^good:\s?(\w+)$/       => (-> (value) { 'good_' + /^good:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^bad:\s?(\w+)$/        => (-> (value) { 'bad_' + /^bad:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^cards:\s?(\w+)$/      => (-> (value) { 'cards_' + /^cards:\s?(\w+)$/.match(value).captures.last.underscore }),
        /^delivery:\s?(\w+)$/   => (-> (value) { 'delivery_' + /^delivery:\s?(\w+)$/.match(value).captures.last.underscore })
    }

    COLUMN_NAMES_MAP = {
        'cars_info' => {
            'id' => 'car_id'
        },

        'game_tips' => {
            'id' => 'game_tip_id'
        },

        'cross_links_info' => {
            'id' => 'link_id'
        }
    }

    COLUMN_NAMES_MAP_REVERSE = COLUMN_NAMES_MAP.select {|key, value| !value.is_a?(Hash)}.invert.merge(
        COLUMN_NAMES_MAP.select {|key, value| value.is_a?(Hash)}.inject({}) {|h, (k,v)| h[k] = v.invert; h}
    )

    DURATIONS = [
        24 * 60 * 60, # days
        60 * 60,      # hours
        60,           # minutes
        1             # seconds
    ]

    attr_accessor :configuration

    attr_accessor :strategy

    class << self

      #  Omnoms configuration
      #
      def consume!(configuration)
        raise 'OmNom can not eat dis!' if configuration.blank? || configuration.new_record?

        omnom = self.new(configuration)
        omnom.strategy = CreateStrategy.new

        omnom.omnom!
      end

      #  Omnoms configuration
      #
      def diff!(configuration, file)
        raise 'OmNom can not eat dis!' if configuration.blank? || configuration.new_record?

        omnom = self.new(configuration)
        omnom.strategy = DiffStrategy.new
        omnom.strategy.configuration = configuration

        omnom.omnom!( file )

        omnom.strategy
      end

      #  Omnoms configuration
      #
      def update!(configuration, file)
        raise 'OmNom can not eat dis!' if configuration.blank? || configuration.new_record?

        omnom = self.new(configuration)
        omnom.strategy = UpdateStrategy.new
        omnom.strategy.configuration = configuration

        omnom.omnom!( file )
        omnom.strategy.finalize!

        configuration.update_attributes!(files: [file])
        Rails.cache.delete("game-design-configuration-#{configuration.id}")

        omnom.strategy
      end

      #  Serializes given configuration to CSV formated string
      #
      def dump!(configuration)
        omnom = self.new(configuration)
        omnom.dump!
      end
    end

    #  Initializes OmNom
    #
    def initialize(configuration)
      self.configuration = configuration
    end

    # Omnoms
    #
    def omnom!(file = nil)
      puts "OnNom uses #{ self.strategy } strategy"

      ::ApplicationRecord.transaction do
        url = file.try(:data).try(:url) || ((Rails.env.test? || Rails.env.development?) ? @configuration.file.data.path : @configuration.file.data.url)
        doc = Roo::Spreadsheet.open(open(url).path, extension: :xlsx)

        SHEETS.each do |sheet_name|
          sheet = doc.sheet(sheet_name).to_matrix.to_a

          state         = :search_table
          current_table = nil
          column_names  = nil

          sheet.each do |row|

            # Skipping empty rows
            if row.compact.empty?
              state = :search_table
              next
            end

            # Table name row
            if (state == :search_table || state == :data) && row.index('Table')
              current_table = row[row.index('Table') + 1].to_sym
              state = :header

              next
            end

            # Header row
            if state == :header
              column_names  = row.compact
              state = :data

              next
            end

            # Data row
            if state == :data
              default_attributes = ::GameDesign::UploadManager::TABLES[ current_table ].dup.attributes.with_indifferent_access.except(:id, :created_at, :updated_at, :rewards)

              attributes = default_attributes.merge( column_names.each_with_index.inject({}) do |memo, (column_name, index)|
                normalized_name                    = normalize_name(column_name, current_table)
                normalized_name, normalized_value  = normalize_value(normalized_name, row[index])

                raise 1 if normalized_name.to_s == "0"

                memo[normalized_name] = normalized_value
                memo
              end.merge(configuration_id: self.configuration.id).with_indifferent_access )

              attributes.delete('id') # remove primary_key (id) if exist in config file

              if current_table == :decoration_buildings
                attributes[:table_name] = "decoration_buildings_#{ attributes[:building_id] }"

                self.strategy.process!( :building_info,         attributes.slice(*%w(configuration_id table_name building_id model_class table_name size_x size_z buildable soft_cost hard_cost sorting_id construct_type)) )
                self.strategy.process!( :decoration_buildings,  attributes.slice(*%w(configuration_id table_name upgrade_duration experience conditions unlocks)).merge("level" => 1) )
              else
                self.strategy.process!( current_table, attributes )
              end
            end
          end
        end
      end
    end

    #  Returns remapped to database column name
    #
    def normalize_name(name, table_name = nil)
      key = REGEXP_NAMES_MAP.keys.detect { |key| key.match(name.to_s) }
      return REGEXP_NAMES_MAP[key].call(name.to_s) if key

      COLUMN_NAMES_MAP[name.to_s] || COLUMN_NAMES_MAP[table_name.to_s].try(:[], name) || name
    end

    #  Returns normalized xls column name for the output
    #
    def normalize_column_name_reverse(name, table_name = nil)
      if (name.include?('perfect_') || name.include?('good_') || name.include?('bad_')) && (!name.include?('tokens_amount'))
        prefix = /^(perfect_|good_|bad_).+/.match(name).captures.first
        resource_name = name.gsub(prefix, "").camelize
        prefix = prefix.gsub('_', '').classify

        return "#{prefix}:#{resource_name}"
      end

      if name.include?('cards_') && table_name != :level_object_info
        return "cards:#{name.gsub("cards_", "").camelize}"
      end

      if Finance::ResourceTransaction::NON_CURRENCY_RESOURCES.include?(name.to_sym) || name.include?('universal')
        return "resources:#{name.camelize}"
      end

      COLUMN_NAMES_MAP_REVERSE[name.to_s] || COLUMN_NAMES_MAP_REVERSE[table_name.to_s].try(:[], name) || name
    end

    def normalize_value(name, value)
      if name.to_s == 'upgrade_duration' || name.to_s == 'clear_duration' || name.to_s == 'delivery_time' || name.to_s == 'delivery_duration' || name.to_s == 'availability_duration' || name.to_s == 'duration' || name.to_s == 'refresh_time' || name.to_s == 'recycling_time' || name.to_s == 'cooling_time'
        return [name, value.to_s.split(":").map(&:to_i).each_with_index.map { |value, index| value * DURATIONS[index] }.select{|value| value != 0}.inject(:+) || 0]
      end

      if name.to_s == 'screens_sequence'
        return [name, value.to_s.split(" | ").map(&:to_i).join(" | ")]
      end

      if name.to_s == 'min_won_reward' || name.to_s == 'max_won_reward' || name.to_s == 'min_lost_reward' || name.to_s == 'max_lost_reward' || name.to_s == 'min_cost' || name.to_s == 'max_cost'
        return [name, value.to_s.split(" | ")]
      end

      if name.to_s == 'won_weights' || name.to_s == 'lost_weights' || name.to_s == "cooldowns"
        return [name, value.to_s.split(" | ").map(&:to_i)]
      end

      if name.to_s == 'locked_by'
        return [name, value.to_s.split(" | ").map(&:to_s)]
      end

      if name.to_s == 'price_label'
        return ['price', (BigDecimal.new(/(\d{1,3}\.\d{1,2})/.match(value.to_s).captures.last.to_f, 4) * 100).to_i ]
      end

      if (name.to_s == 'unlocks' || name.to_s == 'conditions')
        values = value.gsub(" ", "").split('|') rescue []
        return [name, values]
      end

      if name.to_s == 'valid_for'
        return [name, value.to_i]
      end

      if name.to_s == 'meta'
        return [name, JSON.parse(value.blank? ? "{}" : value)]
      end

      if (name.to_s == 'parent_name') && value && !value.empty?
        value = value.gsub(/\s+/, "")
        value = nil if value.blank?

        return [name, value]
      end

      if ['coal', 'shovel', 'black_sand', 'builder_hats', 'tools'].include?(name) && value.blank?
        return [name, 0]
      end

      if name.to_s == 'cost' && value.blank?
        return ["soft_cost", 0]
      end

      if name.to_s == 'cost' && value.include?(':')
        values = value.split(':')
        return [values.first.underscore + '_cost', values.last.to_i]
      end

      [name, value]
    end


  end
end
