Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'small_cafes' => 'application#small_cafes'
  get 'categories' => 'application#categories'
end
