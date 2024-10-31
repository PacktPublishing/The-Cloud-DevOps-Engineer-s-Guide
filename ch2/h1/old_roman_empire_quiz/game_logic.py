import sys
import random
import pygame
from settings import (WIDTH, HEIGHT, BG_COLOR, FONT_COLOR, FPS, BORDER_COLOR, BORDER_WIDTH,
                      POINTS_FONT, QUESTION_FONT, ANSWER_FONT, TITLE_FONT, PROMPT_FONT, GAME_OVER_FONT, 
                      RETRY_PROMPT_FONT, screen, clock)
from utils import draw_text, draw_border
from game_over_screen import game_over_screen
from congratulations import congratulations_screen

QUESTION_FONT_PATH = 'fonts/8-bit-pusab.ttf'

questions = [
    ("Who was the first Roman Emperor?", ["Augustus", "Julius Caesar", "Nero", "Tiberius", "Caligula"], 0, 2, -1),
    ("Which emperor built a massive wall across Britain?", ["Hadrian", "Trajan", "Claudius", "Augustus", "Marcus Aurelius"], 0, 3, -2),
    ("What was the Pax Romana?", ["A period of peace and stability", "A famous Roman temple", "A peace treaty with Carthage", "A military alliance", "A famous gladiator"], 0, 4, -3),
    ("Which structure was completed during the reign of Emperor Vespasian and his son Titus?", ["The Colosseum", "The Pantheon", "The Forum", "The Circus Maximus", "The Appian Way"], 0, 5, -3),
    ("Which Roman emperor is known for his philosophical writings?", ["Marcus Aurelius", "Caligula", "Nero", "Augustus", "Tiberius"], 0, 3, -2),
    ("Who was the last emperor of the Julio-Claudian dynasty?", ["Nero", "Augustus", "Caligula", "Tiberius", "Claudius"], 0, 4, -3),
    ("What was the primary language of the Roman Empire?", ["Latin", "Greek", "Aramaic", "Hebrew", "Persian"], 0, 2, -1),
    ("Which emperor divided the Roman Empire into Eastern and Western regions?", ["Diocletian", "Constantine", "Augustus", "Nero", "Hadrian"], 0, 3, -2),
    ("Which Roman general played a critical role in the conquest of Gaul?", ["Julius Caesar", "Augustus", "Pompey", "Crassus", "Marc Antony"], 0, 5, -3),
    ("What was the main purpose of Roman aqueducts?", ["Water supply", "Defense", "Transportation", "Communication", "Agriculture"], 0, 2, -1),
    ("Which Roman Emperor famously fiddled while Rome burned?", ["Caligula", "Nero", "Augustus", "Tiberius", "Hadrian"], 1, 3, -2),
    ("What was the primary purpose of the Roman Senate?", ["Military command", "Religious ceremonies", "Advising the emperor", "Building infrastructure", "Collecting taxes"], 2, 4, -3),
    ("Who was the first emperor to convert to Christianity?", ["Constantine", "Diocletian", "Augustus", "Trajan", "Hadrian"], 0, 5, -3),
    ("Which emperor is known for his construction of a massive network of roads?", ["Augustus", "Nero", "Trajan", "Claudius", "Vespasian"], 2, 3, -2),
    ("Which Roman festival was held in December to honor Saturn?", ["Lupercalia", "Saturnalia", "Feriae Latinae", "Consualia", "Vulcanalia"], 1, 2, -1),
    ("Which battle marked the end of Mark Antony and Cleopatra's forces?", ["Battle of Actium", "Battle of Zama", "Battle of Pharsalus", "Battle of Cannae", "Battle of Carrhae"], 0, 4, -3),
    ("What was the primary function of a Roman forum?", ["Worship", "Trade and public speaking", "Military training", "Burial grounds", "Sporting events"], 1, 3, -2),
    ("Which emperor famously declared himself a god?", ["Augustus", "Caligula", "Nero", "Trajan", "Claudius"], 1, 5, -3),
    ("Who led the slave revolt against Rome in 73-71 BC?", ["Spartacus", "Hannibal", "Vercingetorix", "Jugurtha", "Mithridates"], 0, 4, -3),
    ("Which architectural feature is characteristic of Roman engineering?", ["Flying buttresses", "Doric columns", "Arches", "Timber framing", "Gothic vaults"], 2, 3, -2)
]

POINTS_POS = (20, 20)

def get_text_height(text, font, max_width):
    words = text.split()
    lines = []
    while words:
        line = ''
        while words and font.size(line + words[0])[0] <= max_width:
            line += (words.pop(0) + ' ')
        lines.append(line)
    return len(lines) * font.size('Tg')[1]  # 'Tg' to get height

def main_game():
    while True:  # Loop to handle retries
        points = 0
        selected_questions = random.sample(questions, 10)  # Select 10 random questions
        
        for question, options, correct_index, correct_points, wrong_points in selected_questions:
            # Shuffle the options and update the correct answer index
            options = options[:]
            correct_answer = options[correct_index]
            random.shuffle(options)
            new_correct_index = options.index(correct_answer)
            
            answered = False
            
            while not answered:
                screen.fill(BG_COLOR)
                draw_text(f'Points: {points}', POINTS_FONT, FONT_COLOR, screen, *POINTS_POS, WIDTH - 40, 0)
                
                # Start with the initial font size
                question_font_size = QUESTION_FONT.get_height()
                question_font = pygame.font.Font(QUESTION_FONT_PATH, question_font_size)
                
                # Check if the question fits within two lines
                question_height = get_text_height(question, question_font, WIDTH - 100)
                max_line_height = 2 * question_font.size('Tg')[1]  # Height for two lines
                
                if question_height > max_line_height:  # If question spans more than two lines
                    # Reduce font size until the question fits within two lines
                    while question_height > max_line_height and question_font_size > 10:  # Ensure font size doesn't go below 10
                        question_font_size -= 2
                        question_font = pygame.font.Font(QUESTION_FONT_PATH, question_font_size)
                        question_height = get_text_height(question, question_font, WIDTH - 100)
                
                draw_text(question, question_font, FONT_COLOR, screen, 50, 100, WIDTH - 100, 10)
                
                answer_start_y = 100 + question_height + 50  # Space below the question
                for i, option in enumerate(options):
                    draw_text(f"{i + 1}. {option}", ANSWER_FONT, FONT_COLOR, screen, 50, answer_start_y + i * 60, WIDTH - 100, 10)
                
                draw_border()
                pygame.display.update()
                
                for event in pygame.event.get():
                    if event.type == pygame.QUIT:
                        pygame.quit()
                        sys.exit()
                    if event.type == pygame.KEYDOWN:
                        if event.key == pygame.K_ESCAPE:
                            if game_over_screen() == False:
                                return
                        if pygame.K_1 <= event.key <= pygame.K_5:
                            index = event.key - pygame.K_1
                            if index == new_correct_index:
                                points += correct_points
                            else:
                                points += wrong_points
                            answered = True
                
                if points < 0:
                    if game_over_screen() == False:
                        return
        
            clock.tick(FPS)
        
        if congratulations_screen() == False:
            return

if __name__ == "__main__":
    main_game()