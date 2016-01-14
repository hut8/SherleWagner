require 'english'
require 'paperclip_stub.rb'
require 'csv'
require 'find'

class FileUploadManager
  extend ImageFilePath

  def initialize file
    @file = file
  end

  def upload
    new_upload_product_file @file
  end

  def new_upload_product_file(file)
    CSV.foreach(file.path, encoding: "MacRoman", col_sep: ',', headers: true) do |row|
      data_row = DataRow.new(row)


      if data_row.normal_product? || data_row.compilation?
        begin

         # style = data_row.get_style
         # filters = data_row.get_filters
         # genres= data_row.get_genres
         # product_configuration = data_row.get_product_configuration 
          product = Product.new(data_row.product_args)

          product.styles.concat data_row.get_style
          product.filter_values.concat data_row.get_filters
          product.genres.concat data_row.get_genres
          product.product_configurations.concat data_row.get_product_configuration

          product.save if product.valid?
        rescue
          binding.pry
        end

      elsif data_row.configuration?
        product = data_row.product
        product.add_configuration data_row.get_product_configuration
        product.save

      end

    end
    set_compilations file

  end

  def set_compilations(file)
    current_compilation = NullObject.new
    CSV.foreach(file.path, encoding: "MacRoman", col_sep: ',', headers: true) do |row|
      data_row = DataRow.new row
      if data_row.compilation?
        current_compilation = data_row.product
      elsif data_row.normal_product?
        current_compilation = NullObject.new
      elsif data_row.component?
        component = data_row.component
        if !component.nil? && !current_compilation.nil?
          current_compilation.components << component
          current_compilation.save
        end
      end
    end
  end

end
