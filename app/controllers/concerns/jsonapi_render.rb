# frozen_string_literal: true

module JSONAPIRender
  extend ActiveSupport::Concern

  def render_resource_collection(resources, options = {})
    if resources.instance_of?(Array) && options[:each_serializer].blank?
      raise ArgumentError,
            'must_have :each_serializer options for Array collection'
    end

    serializer_options, render_options = extract_options(options:)
    serializer_class = render_options[:each_serializer] || default_resource_collection_serializer_class(resources:)

    render json: serializer_class.render(resources, serializer_options), status: render_options[:status] || :ok
  end

  def render_resource(resource, options = {})
    serializer_options, render_options = extract_options(options:)
    serializer_class = render_options[:serializer] || default_resource_serializer_class(resource:)

    render json: serializer_class.render(resource, serializer_options), status: render_options[:status] || :ok
  end

  def render_resource_errors(errors:, options: {})
    api_error = APIError::RecordInvalidError.new(errors)

    render json: api_error, status: options[:status] || api_error.status
  end

  private

  def default_resource_collection_serializer_class(resources:)
    "#{resources.klass}Serializer".constantize
  end

  def default_resource_serializer_class(resource:)
    "#{resource.class}Serializer".constantize
  end

  def extract_options(options:)
    sopts = options.except(*render_options_keys)
    ropts = options.slice(*render_options_keys)

    [sopts, ropts]
  end

  def render_options_keys
    %i[serializer each_serializer status]
  end
end
