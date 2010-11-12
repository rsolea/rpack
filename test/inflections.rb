# some portuguese inflections here
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural    /(ao)$/i  , 'oes'
  inflect.singular  /oes$/i   , 'ao'
end
