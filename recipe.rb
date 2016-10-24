class Recipe
  attr_accessor(:title, :serving_size, :ingredients)
  
  def initialize(title="Default Recipe Title", serving_size=1, ingredients=[])
    @title = title
    @serving_size = serving_size
    @ingredients = ingredients
  end
end
