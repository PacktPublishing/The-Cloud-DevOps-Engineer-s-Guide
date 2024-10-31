import pygame
from settings import BORDER_COLOR, BORDER_WIDTH, WIDTH, HEIGHT, screen

def draw_text(text, font, color, surface, x, y, max_width, line_spacing, center=False):
    words = text.split(' ')
    lines = []
    current_line = words[0]
    
    for word in words[1:]:
        if font.size(current_line + ' ' + word)[0] < max_width:
            current_line += ' ' + word
        else:
            lines.append(current_line)
            current_line = word
            
    lines.append(current_line)
    
    for i, line in enumerate(lines):
        textobj = font.render(line, True, color)
        textrect = textobj.get_rect()
        if center:
            textrect.centerx = x
        else:
            textrect.x = x
        textrect.y = y + i * (font.get_linesize() + line_spacing)
        surface.blit(textobj, textrect)

def draw_border():
    pygame.draw.rect(screen, BORDER_COLOR, (0, 0, WIDTH, HEIGHT), BORDER_WIDTH)