import sys
import pygame
from settings import screen, BG_COLOR, FONT_COLOR, TITLE_FONT, PROMPT_FONT
from utils import draw_text, draw_border

def intro_screen():
    while True:
        screen.fill(BG_COLOR)
        draw_text('Old Roman Empire Quiz', TITLE_FONT, FONT_COLOR, screen, screen.get_width() // 2, screen.get_height() // 3, screen.get_width(), 20, center=True)
        draw_text('Press Enter to Start', PROMPT_FONT, FONT_COLOR, screen, screen.get_width() // 2, screen.get_height() // 2 + 50, screen.get_width(), 20, center=True)
        draw_border()
        pygame.display.update()
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_RETURN:
                    return