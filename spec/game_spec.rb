require 'spec_helper'

describe 'Game class' do
  let (:g) { Game.new(6) }

  context 'starting a new game,' do
    it 'randomly selects a secret word between 5 & 12 characters long' do
      answer = g.instance_eval {@answer}
      expect(answer.length).to be >= 5
      expect(answer.length).to be <= 12
    end
  end

  context 'giving player feedback on letter guess,' do
    let (:pineapple_game) { Game.new(6, 'pineapple') }

    it 'displays which correct letters are chosen, & where they are in word' do
      pineapple_game.send(:get_player_guess, 'p')
      expect(pineapple_game.player_guess).to eq ['p','','','','','p','p','','']
    end
    it 'displays how many more incorrect guesses before game is over' do
      pineapple_game.send(:get_player_guess, 'z')
      expect(pineapple_game.wrong_letters_remaining).to eq 5
    end
    it 'display which incorrect letters are chosen' do
      pineapple_game.send(:get_player_guess, 'z')
      pineapple_game.send(:get_player_guess, 'g')
      expect(pineapple_game.incorrect_letters).to eq ['g', 'z']
    end
  end

end
