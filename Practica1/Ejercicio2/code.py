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
        return summary

###########################################################################################
## 4. Codigo cliente
###########################################################################################

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

LLM = BasicLLM
result = LLM.generate_summary(LLM, TEXTO, "en", "es", MODEL_LLM)

print(result)