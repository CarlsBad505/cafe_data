class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def small_cafes
    require 'csv'
    attributes = [:name, :address, :postal_code, :chairs, :category]
    csv_file = CSV.generate(headers: true) do |csv|
      csv << attributes
      cafes = StreetCafe.where("category like ?", "%small%")
      cafes.each do |cafe|
        csv << attributes.map{ |attr| cafe[attr] }
      end
    end

    respond_to do |format|
      format.csv { send_data csv_file, filename: "small_cafes.csv" }
    end
  end

  def categories
    require 'csv'
    attributes = [:category, :total_places, :total_chairs]
    csv_file = CSV.generate(headers: true) do |csv|
      csv << attributes
      categories = CategoryView.all
      categories.each do|category|
        csv << attributes.map{ |attr| category[attr] }
      end
    end

    respond_to do |format|
      format.csv { send_data csv_file, filename: "categories.csv" }
    end
  end

end
