import json
from huggingface_hub import InferenceClient
from abc import ABC, abstractmethod

###########################################################################################
## 1. Clase base e interfaz LLM
###########################################################################################

class LLM(ABC):
    
    @abstractmethod
    def generate_summary(self, text: str, input_lang: str, output_lang: str, model: str) -> str:
        """
        Método que debe implementar cada LLM para generar un resumen.

        :param text: El texto a resumir.
        :param input_lang: El idioma del texto de entrada (p. ej., "en", "es").
        :param output_lang: El idioma de salida (p. ej., "en", "es").
        :param model: El modelo LLM a utilizar (p. ej., "facebook/bart-large-cnn").
        :return: El resumen generado.
        """
        pass

###########################################################################################
## 2. Clase BasicLLM
###########################################################################################

class BasicLLM(LLM):
    
    def generate_summary(self, text: str, input_lang: str, output_lang: str, model: str) -> str:
        summary = client.summarization(
            text = text,
            model = model
        )
        return summary.summary_text

###########################################################################################
## 3. Decoradores
###########################################################################################

class DecoratorLLM(LLM, ABC):

    _LLM: LLM = None

    def __init__(self, _LLM: LLM):
        self._LLM = _LLM

    @abstractmethod
    def generate_summary(self, text: str, input_lang: str, output_lang: str, model: str) -> str:
        pass

# Decorador 1: Traducción
class TranslationDecorator(DecoratorLLM):
   

    def generate_summary(self, text: str, input_lang: str, output_lang: str, model: str) -> str:
        summary = self._LLM.generate_summary(text, input_lang, output_lang, model)
        translation = client.translation(
            text = summary,
            model = MODEL_TRANSLATION
        )

        return translation.translation_text
    
# Decorador 2: Expansión
class ExpansionDecorator(DecoratorLLM):
   

    def generate_summary(self, text: str, input_lang: str, output_lang: str, model: str) -> str:
        summary = self._LLM.generate_summary(text, input_lang, output_lang, model)
        expansion = client.text_generation(
            prompt = summary[:250],
            model = MODEL_EXPANSION
        )

        return expansion

###########################################################################################
## 4. Codigo cliente
###########################################################################################
if __name__ == "__main__":
    # Leer el archivo config.json
    with open("config.json") as config_file:
        config = json.load(config_file)

    TEXTO = config["texto"]
    INPUT_LANG = config["input_lang"]
    OUTPUT_LANG = config["output_lang"]
    MODEL_LLM = config["model_llm"]
    MODEL_TRANSLATION = config["model_translation"]
    MODEL_EXPANSION = config["model_expansion"]
    API_TOKEN = config["token"]

    client = InferenceClient(
        provider="hf-inference",
        api_key=API_TOKEN
    )

    #LLamamos al resumen básico


    LLM = BasicLLM()
    summary = LLM.generate_summary(TEXTO, "en", "es", MODEL_LLM)

    print("Resumen básico: " + summary + "\n")

    translation_decorator = TranslationDecorator(LLM)
    translation = translation_decorator.generate_summary(TEXTO, "en", "es", MODEL_LLM)
    print("Resumen traducido: " + translation + "\n")

    expansion_decorator = ExpansionDecorator(LLM)
    expansion = expansion_decorator.generate_summary(TEXTO, "en", "es", MODEL_LLM)
    print("Expansión del resumen: " + expansion + "\n")

    #Traducimos y expandimos
    double_decorator = ExpansionDecorator(TranslationDecorator(LLM))
    double_decoration = double_decorator.generate_summary(TEXTO, "en", "es", MODEL_LLM)
    print("Resumen expandido y traducido: " + double_decoration + "\n")