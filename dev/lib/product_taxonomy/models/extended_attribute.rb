# frozen_string_literal: true

module ProductTaxonomy
  class ExtendedAttribute < Attribute
    class << self
      def localizations
        superclass.localizations # Extended attribute localizations are defined in the same place as attributes
      end
    end

    validate :values_from_valid?

    attr_reader :values_from

    alias_method :base_attribute, :values_from

    # @param name [String] The name of the attribute.
    # @param handle [String] The handle of the attribute.
    # @param description [String] The description of the attribute.
    # @param friendly_id [String] The friendly ID of the attribute.
    # @param values_from [Attribute, String] A resolved {Attribute} object. When resolving fails, pass the friendly ID
    #   instead.
    def initialize(name:, handle:, description:, friendly_id:, values_from:)
      @values_from = values_from
      values_from.add_extended_attribute(self) if values_from.is_a?(Attribute)
      super(
        id: values_from.try(:id),
        name:,
        handle:,
        description:,
        friendly_id:,
        values: values_from.try(:values),
        is_manually_sorted: values_from.try(:manually_sorted?) || false,
      )
    end

    private

    def values_from_valid?
      errors.add(
        :base_attribute,
        :not_found,
        message: "not found for friendly ID \"#{values_from}\"",
      ) unless values_from.is_a?(Attribute)
    end
  end
end
