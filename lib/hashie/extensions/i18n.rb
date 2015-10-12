require "hashie/extensions/i18n/version"

module Hashie
  module Extensions
    module I18n
      
      module Dash
        def self.included base
          # make sure we have coercion
          base.send :include, Hashie::Extensions::Coercion
          base.extend ClassMethods
        end


        module ClassMethods

          def localizable_property property_name, options = {}
            # remove :coerce option, use custom coercion instead
            into = options.delete(:coerce)
            # set the :default option to be an empty Hash
            options[:default] = ::Hash.new
            # define the property the usual way
            property property_name, options
            # value must be a Hash of {locale: value}
            # keys are coerced to Symbols
            # and values are coerced as specified by options[:coerce]
            if into.nil?
              coerce_key property_name, Hash[Symbol => Object]
            else
              coerce_key property_name, Hash[Symbol => into]
            end
            # define a localized accessor
            define_method "localized_#{property_name}" do |*locales|
              # get the property value (Hash or nil)
              res = self.[](property_name)
              return nil if res.nil? || res.empty?
              # ensure locales is a flat Array
              locales = [locales].flatten
              # if no locale is provided, default to I18n.locale
              locales = [::I18n.locale] if locales.empty?
              # add the fallbacks of the provided locales
              if ::I18n.respond_to?(:fallbacks)
                locales.concat(locales.map{|l|
                  ::I18n.fallbacks[l].drop(1)}.flatten)
              end
              # symbolize locales
              locales.map!{|l| l.to_s.downcase.to_sym}
              # try the specified locales in order
              locales.each do |l|
                return res[l] if res.has_key?(l)
              end
              # translation not found: return nil
              nil
            end
          end
        end

      end
    end
  end
end
