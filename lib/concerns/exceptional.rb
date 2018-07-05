# Module Exceptional creates and raise errors
module Exceptional
  extend ActiveSupport::Concern

  def add_error(attribute, translation, options = {})
    errors.add(attribute, I18n.t(translation, options))
  end

  def add_error!(attribute, translation, options = {})
    add_error(attribute, translation, options)
    raise Exceptions::Model.build(self)
  end

  def add_error_with_message(attribute, message)
    errors.add(attribute, message)
  end

  def add_error_with_message!(attribute, message)
    errors.add(attribute, message)
    raise Exceptions::Model.build(self)
  end

  def add_with_error!(error)
    errors.add(error.attribute, error.message)
    raise Exceptions::Model.build(self)
  end

  def raise_on_error
    raise Exceptions::Model.build(self) if errors.any?
  end

  # Module Exceptional creates and raise errors
  module ClassMethods
    def raise_simple(field, translation)
      raise Exceptions::Simple.build(message: I18n.t(translation), field: field)
    end

    def raise_model(attribute, translation)
      new.add_error!(attribute, translation)
    end

    def raise_model!(error)
      new.add_with_error!(BaseError.new(error))
    end
  end

  # Simple base error
  class BaseError
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def attribute
      error.first
    end

    def message
      error.last
    end
  end
end
