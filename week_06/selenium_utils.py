from googletrans import Translator
from number2words import Number2Words
from time import sleep

log_errors_file_path = "./errors.txt"


def resuelve_captcha(driver, model):
    _words = driver.find_element_by_css_selector("p.p0").text.split(": ")
    words = [w for w in _words if w != ""]

    word = driver.find_element_by_css_selector("p.p2").text[112:]

    print(word)
    print(words)
    
    counter_errors = 0
    while True:
        try:
            solution = _resuelve_captcha(model, word, words)
        except:
            counter_errors += 1
            if counter_errors == 5:
                error_string = f"UNABLE {word:25}{words}"
                print(error_string)
                with open(log_errors_file_path, 'a') as f:
                    f.write(f'{error_string} \n')
                raise
        else:
            print(f'Solución: {solution}')
            return solution
    
def _resuelve_captcha(model, word, words):
    if is_number_expression(word):
        # print("number expression")
        sol = get_spanish_number_written(is_number_expression(word))
    else:
        # print("normal word")
        sol = get_most_similar_spanish(word, words, model)
        
    return sol


def get_most_similar_spanish(word, word_list, model):
    t = Translator()
    word_eng = t.translate(word, src="es", dest="en").text.split()[0]
    # print(word_eng)
    words_eng = [t.translate(www, src="es", dest="en").text.split()[0] for www in word_list]
    # print(words_eng)
    
    return word_list[get_most_similar(word_eng, words_eng, model)]

def get_most_similar(word, word_list, model):

    vector = model[word.lower()]
    vectors = [model[w.lower()] for w in word_list]

    similarities = model.cosine_similarities(
        vector, 
        vectors
    )

    winner_index = similarities.argmax()
    
    # print(winner_index)
    return winner_index

def get_spanish_number_written(number):
    # Turns 11 to "Once"
    number_word = Number2Words(number).convert()[:-5]
    # print(number_word)
    translator = Translator()
    number_text = translator.translate(number_word, src='en', dest='es').text
    
    if len(number_text.split()) == 2:
        # print("dos palabras...")
        number_text = number_text.split()[1]
    
    # print(number_text)
    
    return number_text

def is_number_expression(word):
    word = word.replace("x", "*")
    try:
        number = eval(word)
    except:
        return False
    else:
        return number

    
    
    
    
    




def accede_formulario(driver, url):
    driver.get(url)
    sleep(1)
    driver.find_element_by_css_selector("div div div input").click()
    sleep(1)
    
def rellena_campos(driver):
    driver.find_element_by_name("nombreApellidos").send_keys("PEDRO RAMÍREZ")

    driver.find_element_by_name("tipo").send_keys("N")

    driver.find_element_by_name("numeroDocumento").send_keys("12345678A")

    driver.find_element_by_name("telefono").send_keys("602345678")

    driver.find_element_by_name("eMail").send_keys("pedrito69tkm@gmail.com")

    driver.find_element_by_id("radioProvincia").click()

    driver.find_element_by_name("provincia").send_keys("m")

def rellena_captcha_y_siguiente(driver, solution):
    # print(f'rellenando... {solution}')
    driver.find_element_by_name("ARQ.CAPTCHA").send_keys(solution)

    driver.find_element_by_name("SPM.ACC.SIGUIENTE").click()

def pensiones_click_and_next(driver):
    driver.find_element_by_id("335").click()

    driver.find_element_by_name("SPM.ACC.CONTINUAR_TRAS_SELECCIONAR_SERVICIO").click()
    
def is_paso_2(driver):
    try:
        titulo = driver.find_element_by_css_selector("div span strong")
    except:
        return False
    else:
        return titulo.text == "Paso 2 de 4. Selección de Servicio."
    
    
    
    
def proceso_total():

    accede_formulario(driver, url_ss)
    
    rellena_campos(driver)

    solution = resuelve_captcha(driver, model)
    
    rellena_captcha_y_siguiente(driver, solution)
    sleep(.5)
    
    pensiones_click_and_next(driver)
    sleep(.5)
    
    if not is_paso_2(driver):
        return True

while True:
    sleep(5)
    try:
        if proceso_total():
            print("VAMOS!")
            effect.play(loops=30)
            
            break
        else:
            print("NO HAY CITA")
    except:
        print("ERROR")
        pass
    
    print("\n"
          
          
          #### Load word vectors

I need a mapping word --> vector

import gensim

%%time
model = gensim.models.KeyedVectors.load_word2vec_format('../../../Documents/coding/selenium/word2vec.300d.W.pos.vectors', binary=False)