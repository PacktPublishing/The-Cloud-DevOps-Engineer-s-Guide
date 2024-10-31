import os
import pygame

# Initialize Pygame
pygame.init()

# Get the directory of the current file
BASE_DIR = os.path.dirname(__file__)
FONTS_DIR = os.path.join(BASE_DIR, 'fonts')

# Constants
WIDTH, HEIGHT = 800, 600
BG_COLOR = (156, 160, 76)
FONT_COLOR = (0, 0, 0)
FPS = 60
BORDER_COLOR = (0, 0, 0)
BORDER_WIDTH = 10

# Font Sizes
TITLE_FONT_SIZE = 34
POINTS_FONT_SIZE = 24
PROMPT_FONT_SIZE = 24
QUESTION_FONT_SIZE = 18
ANSWER_FONT_SIZE = 20
GAME_OVER_FONT_SIZE = 34
RETRY_PROMPT_FONT_SIZE = 24

# Load fonts
TITLE_FONT = pygame.font.Font(os.path.join(FONTS_DIR, '8-bit-pusab.ttf'), TITLE_FONT_SIZE)
POINTS_FONT = pygame.font.Font(os.path.join(FONTS_DIR, 'PixelOperator8.ttf'), POINTS_FONT_SIZE)
PROMPT_FONT = pygame.font.Font(os.path.join(FONTS_DIR, 'PixelOperator8.ttf'), PROMPT_FONT_SIZE)
QUESTION_FONT = pygame.font.Font(os.path.join(FONTS_DIR, '8-bit-pusab.ttf'), QUESTION_FONT_SIZE)
ANSWER_FONT = pygame.font.Font(os.path.join(FONTS_DIR, 'PixelOperator8.ttf'), ANSWER_FONT_SIZE)
GAME_OVER_FONT = pygame.font.Font(os.path.join(FONTS_DIR, '8-bit-pusab.ttf'), GAME_OVER_FONT_SIZE)
RETRY_PROMPT_FONT = pygame.font.Font(os.path.join(FONTS_DIR, 'PixelOperator8.ttf'), RETRY_PROMPT_FONT_SIZE)

# Screen setup
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption('OLD ROMAN EMPIRE QUIZ')

# Clock setup
clock = pygame.time.Clock()