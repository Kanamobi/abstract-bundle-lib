# Buildable is a module to create and validate new inserts and updates
module Buildable
  extend ActiveSupport::Concern

  # build a complete update of the object
  def build_update(params)
    unless update_attributes(params)
      error = errors.first
      add_error_with_message!(error.first, error.last)
    end
    self
  end

  # build a complete update of the object and return changes
  def build_update_with_changes(params)
    related_changes = {}
    self.attributes = params
    valid? ? save_with_changes : raise_update_error
  end

  def save_with_changes
    current = changes.clone
    save
    current
  end

  def raise_update_error
    error = errors.first
    add_error_with_message!(error.first, error.last)
  end


  def default_status
    return unless respond_to?(:status)
    cur_status = respond_to?(:active!) ? 'active' : 0
    self.status = cur_status if status.blank?
  end

  # build a new user with params, raise if has errors in validation
  module ClassMethods
    def build(params)
      object = new(params)
      object.default_status
      commit?(object) ? object : raise_model!(object.errors.first) 
    end

    def commit?(object)
      transaction { exec_commit(object) } if ancestors.map(&:name).include?("ActiveRecord::Base")
      exec_commit(object)
    end

    def exec_commit(object)
      object.save if object.valid?
    end

  end
end
