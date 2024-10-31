import pygame
from intro_screen import intro_screen
from game_logic import main_game

# Initialize Pygame
pygame.init()

# Run the game
intro_screen()
main_game()
pygame.quit()