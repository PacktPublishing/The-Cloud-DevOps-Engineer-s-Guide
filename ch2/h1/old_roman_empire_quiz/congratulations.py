import pygame
import sys
from settings import screen, BG_COLOR, FONT_COLOR, TITLE_FONT, RETRY_PROMPT_FONT, WIDTH, HEIGHT
from utils import draw_text, draw_border

def congratulations_screen():
    while True:
        screen.fill(BG_COLOR)
        
        draw_text('Congratulations! :D', TITLE_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 3, WIDTH, 20, center=True)
        
        draw_text('Press Enter to Retry', RETRY_PROMPT_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 2 + 50, WIDTH, 20, center=True)
        draw_text('Or press ESC to Quit', RETRY_PROMPT_FONT, FONT_COLOR, screen, WIDTH // 2, HEIGHT // 2 + 100, WIDTH, 20, center=True)
        
        draw_border()
        pygame.display.update()
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            elif event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    return True
                elif event.key == pygame.K_ESCAPE:
                    pygame.quit()
                    sys.exit()