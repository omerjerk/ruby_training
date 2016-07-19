class Dice
  def initialize
  end

  def self.roll
    1 + rand(6)
  end
end

class Greed
  def initialize(num_players)
    @num_players = num_players
    #which player's turn it is
    @turn_player = 0
    #total score for each player
    @total_score = Array.new(num_players, 0)
    @final_round = false
    @player_index = 0
    @turn_index = 1
  end

  #turn specific to each player
  def play
    begin
      num_dices = 5
      print_turn
      if @final_round == false
        turn_score = 0
        begin
          score, num_dices = round(num_dices, @player_index)
          if score == 0
            turn_score = 0
            print_score(score, @total_score[@player_index] + turn_score)
            break
          end
          turn_score += score
          print_score(score, @total_score[@player_index] + turn_score)

          if @total_score[@player_index] + turn_score >= 3000
            @final_round = true
            break
          end
          
        end while continue_rolling?(num_dices)
        @total_score[@player_index] += turn_score
        puts ""
      end

      if @final_round == true
        play_final_round
        break
      end
      
      @player_index += 1
      @player_index %= @num_players
    end while true
  end

  #each player can have multiple turns
  private
  def round(num_dices, player_index)
    rolls = Array.new(num_dices)
    num_dices.times do |i|
      rolls[i] = Dice::roll
    end
    score, non_scoring = calc_score(num_dices, rolls)
    print_rolls(player_index, rolls)
    return score, non_scoring
  end

  private
  def continue_rolling?(num_dices)
    return false if num_dices == 0
    print "Do you want to roll the non-scoring #{num_dices} dice? (y/n): "
    return gets.chomp == "y"
  end

  private
  def play_final_round
    @player_index = 0
    print_turn
    while @player_index < @num_players do
      score, num_dices = round(5, @player_index)
      @total_score[@player_index] += score
      print_score(score, @total_score[@player_index])
      puts ""
      @player_index += 1
    end
  end

  private 
  def print_rolls(player_index, rolls = [])
    puts "Player #{player_index} rolls: #{rolls * ', '}"
  end

  private
  def calc_score(num_dices, rolls = [])
    score = 0
    non_scoring = num_dices
    count = Array.new(7, 0)
    rolls.each {|x| count[x] += 1}

    for i in 1..6
      if count[i] >= 3
        i == 1 ? score += 1000 : score += i * 100
        count[i] -= 3
        non_scoring -= 3
      end
    end

    if count[1] >= 0
      score += 100 * count[1]
      non_scoring -= count[1]
    end

    if count[5] >= 0
      score += 50 * count[5]
      non_scoring -= count[5]
    end

    return score, non_scoring
  end

  private
  def print_turn()
    if @final_round == true
      puts "Final round"
    else
      puts "Turn #{@turn_index}"
    end
    puts "----------------"
    @turn_index += 1
  end

  def print_score(score, total_score)
    puts "Score in this round: #{score}"
    puts "Total score: #{total_score}"
  end
  
end

print "Enter number of players: "
n = gets.chomp.to_i
greed = Greed.new(n)
greed.play
