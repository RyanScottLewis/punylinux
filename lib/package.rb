require 'yaml'
require 'json'
require 'package/dsl'
require 'package/list'
require 'package/specification'
require 'package/load_result'
require 'package/load_results'

module Package
  class << self

    def all
      @all ||= List.new
    end

    # TODO: Abstract into a loader class

    def load_ruby(path)
      load_file(path) do
        DSL.load(path)
      end
    end

    def load_yaml(path)
      load_file(path) do
        YAML.load_file(path)
      end
    end

    def load_json(path)
      load_file(path) do
        data = File.read(path) # TODO: JSON.load_file ffs...
        JSON.load(data)
      end
    end

    def load_directory(directory)
      load_results = find_by_ext(directory, '{rb,yml,yaml,json}').map do |path|
        case File.extname(path).downcase[1..-1]
        when 'rb'          then load_ruby(path)
        when 'yml', 'yaml' then load_yaml(path)
        when 'json'        then load_json(path)
        end
      end
      load_results = LoadResults.new(load_results)

      all.push(*load_results.to_structs)

      load_results
    end

    protected

    def find_by_ext(directory, extension)
      pattern = File.join(directory, '**', "*.#{extension}")

      Dir.glob(pattern, File::FNM_CASEFOLD) # FNM_CASEFOLD = case-insensitive
    end

    def load_file(path)
      data          = yield
      specification = Specification.call(data)

      LoadResult.new(path, specification, nil)
    rescue => error
      LoadResult.new(path, nil, error)
    end

  end
end

