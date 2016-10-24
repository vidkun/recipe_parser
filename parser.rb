require_relative 'recipe'
require 'json'
require 'pry'

class Parser
  def initialize
    @line_count = 0
    @ingredients = Array.new
    @units = %w{ oz ounce ounces tbs tbl tbsp tsp cups cup lb lbs slice slices pt gal gallon gallons l liter liters quart quarts pint pints}
  end

  def parse
    # open and read each line from file
    f = File.open("recipes.txt", "r+")

    f.each_line do |line|

      # parse recipe until blank line
      unless line.nil? || line.empty?
        @line_count += 1

        case @line_count
        when 1
          @r = Recipe.new
          @r.title = line.chomp.titlecase
        when 2
          @r.serving_size = line.chomp.split.last.to_i
        else
          ingredient = Hash.new

          i = line.chomp.split

          if i.first.is_numeric?
            if @units.include? i[1]
              ingredient[:quantity] = i.first
              ingredient[:unit] = i[1]
              ingredient[:item] = i[2..-1].join(' ')
            else
              ingredient[:quantity] = i.first
              ingredient[:item] = i[1..-1].join(' ')
            end
          else
            # assume there is no quanity or unit of measure (i.e. 'lettuce' or 'salt')
            ingredient[:item] = i.join(' ')
          end
          # add ingredient to ingredients array
          @ingredients.push ingredient
        end
      end

      # reset the counter and ingredients for next recipe
      if line.empty?
        @r.ingredients = @ingredients
        # for now just print each recipe out in JSON to ensure things work
        puts @r.to_json

        @line_count = 0
        @ingredients = []
      end
    end

    f.close
  end
end

# I know it's dirty, but will have to work for now until I can clean it up
class String
  def is_numeric?
    m = self.match /^\d+(?:\D\d+)?$/
    return m.nil? ? false : true
  end

  def titlecase
    self.tr('_', ' ').
    gsub(/\s+/, ' ').
    gsub(/\b\w/){ $`[-1,1] == "'" ? $& : $&.upcase }
  end
end