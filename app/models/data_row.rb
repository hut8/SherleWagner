require 'find'
class DataRow
  extend ImageFilePath

 IMAGES_PATH = "/Users/ph1am/Desktop/SW website/images1"
  # IMAGES_PATH = "/Users/wake/Documents/Work/SherleWagner/images"
   # IMAGES_PATH = image_file_path


  attr_reader :component_number, :compilation_number

  def initialize row
    @row = row
    @generic_name = get_generic_name
    @generic_number = get_generic_number
    @image_name = get_image_name
    @specific_number = get_specific_number
    @product_type = get_product_type
    @product_sub_type = get_product_sub_type
    @image = get_image
    @style = get_style
    @genres = get_genres
    @compilation_number = @specific_number
    @component_number = get_component_number
    
  end

 
  def normal_product?
    !@image_name.blank? &&
      !compilation? &&
      !configuration?
  end

  def compilation?
    @generic_number == "TITLE-XX"
  end


  def component?
    @image_name.blank? && !@component_number.blank?
    
  end

  def configuration?
    Product.exists?(number: @generic_number) && 
      @generic_name != "TITLE-XX" &&
      !@image_name.blank?
  end

  
  def product_args
    args = { name: @generic_name,
      number: @generic_number,
      product_type: @product_type,
      product_sub_type: @product_sub_type,
      image: @image

    }
    if compilation?
      args[:number] = @specific_number
    end
    args
  end

  def product
    if compilation?
      Product.where(number: @specific_number).where(name: @generic_name).first
    else
      Product.find_by(number: @generic_number)
    end
  end

  def component
    ebps_id = ProductSubType.find_by(name: "Elongated Back Plate Systems").id
    Product.
      where.not(product_sub_type: ebps_id). 
      where('number like ?' , "#{@component_number}%").first
  end

  def get_generic_name
    @row["GENERIC PRODUCT NAME _ Revised"] || ""
  end

  def get_generic_number
    @row["Generic Product Number"] || ""
  end

  def get_image_name
    name = @row["IMAGE FILE"] || ""
    name = name + ".jpg" if !name.blank?
    name
  end

  def get_specific_number
    @row["IMAGE FILE"] || ""
  end

  def get_product_type
    ProductType.get_arg @row
  end

  def get_product_sub_type
    ProductSubType.get_arg @row
  end

  def get_filters
    FilterValue.get_arg @row
  end

  def get_product_configuration
    ProductConfiguration.get_arg @row
  end

  def get_image
    image_file = NullObject.new
    
    Find.find(IMAGES_PATH) do |filepath|
      if File.basename(filepath) == @image_name
        image_file = File.new(filepath) || NullObject.new
      end
    end
    image_file
        
  end

  def get_style
    Style.get_arg @row
  end

  def get_genres
    Genre.get_arg @row
  end

  def get_component_number
    @row["CODE under Product Name"] || ""
  end

end

