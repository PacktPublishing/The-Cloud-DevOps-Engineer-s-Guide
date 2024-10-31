import pygame
import sys
from settings import screen, BG_COLOR, FONT_COLOR, GAME_OVER_FONT, RETRY_PROMPT_FONT, WIDTH, HEIGHT
from utils import draw_text, draw_border

def game_over_screen():
    while True:
        screen.fill(BG_COLOR)
        
        # Draw the game over message
        draw_text('Game Over :-(', GAME_OVER_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 3, WIDTH, 20, center=True)
        
        # Draw the retry prompt
        draw_text('Press Enter to Retry', RETRY_PROMPT_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 2 + 50, WIDTH, 20, center=True)
        
        # Draw the quit prompt
        draw_text('Or press ESC to Quit', RETRY_PROMPT_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 2 + 100, WIDTH, 20, center=True)
        
        draw_border()
        pygame.display.update()
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    return True  # Return True to indicate that the game should restart
                if event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()  # Quit the game if ESC is pressed