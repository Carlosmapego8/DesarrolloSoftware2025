import requests
import yaml
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from abc import ABC, abstractmethod
import time

# Definición del patrón Strategy
class ScraperStrategy(ABC):
    @abstractmethod
    def scrape(self, url):
        pass

# Estrategia con BeautifulSoup
class BeautifulSoupScraper(ScraperStrategy):
    def scrape(self, url):
        response = requests.get(url)
        if response.status_code != 200:
            print(f"Error al acceder a {url}")
            return []
        
        soup = BeautifulSoup(response.text, "html.parser")
        return self.extract_quotes(soup)

    def extract_quotes(self, soup):
        quotes_data = []
        quotes = soup.find_all("div", class_="quote")

        for quote in quotes:
            text = quote.find("span", class_="text").text
            author = quote.find("small", class_="author").text
            tags = [tag.text for tag in quote.find_all("a", class_="tag")]
            
            quotes_data.append({
                "text": text,
                "author": author,
                "tags": tags
            })

        return quotes_data

# Estrategia con Selenium
class SeleniumScraper(ScraperStrategy):
    def __init__(self):
        options = Options()
        options.add_argument("--headless")  # Ejecutar en modo sin interfaz gráfica
        options.add_argument("--disable-gpu")
        options.add_argument("--no-sandbox")
        self.driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    def scrape(self, url):
        self.driver.get(url)
        time.sleep(2)  # Espera para asegurar la carga de la página
        soup = BeautifulSoup(self.driver.page_source, "html.parser")
        return self.extract_quotes(soup)

    def extract_quotes(self, soup):
        quotes_data = []
        quotes = soup.find_all("div", class_="quote")

        for quote in quotes:
            text = quote.find("span", class_="text").text
            author = quote.find("small", class_="author").text
            tags = [tag.text for tag in quote.find_all("a", class_="tag")]

            quotes_data.append({
                "text": text,
                "author": author,
                "tags": tags
            })

        return quotes_data

    def close(self):
        self.driver.quit()

# Contexto que usa una estrategia de scraping
class ScraperContext:
    def __init__(self, strategy: ScraperStrategy):
        self.strategy = strategy

    def set_strategy(self, strategy: ScraperStrategy):
        self.strategy = strategy

    def scrape_pages(self, base_url, num_pages=5):
        all_quotes = []
        for page in range(1, num_pages + 1):
            url = f"{base_url}/page/{page}/"
            print(f"Scraping: {url}")
            quotes = self.strategy.scrape(url)
            all_quotes.extend(quotes)

        return all_quotes

# Guardar los datos en un archivo YAML
def save_to_yaml(data, filename="quotes.yaml"):
    with open(filename, "w", encoding="utf-8") as file:
        yaml.dump(data, file, allow_unicode=True, default_flow_style=False)
    print(f"Datos guardados en {filename}")

# Función principal con interacción del usuario
def main():
    BASE_URL = "https://quotes.toscrape.com"

    while True:
        print("\nSelecciona el método de scraping:")
        print("[S] Selenium")
        print("[B] BeautifulSoup")
        print("[Q] Salir")
        choice = input("Opción: ").strip().lower()

        if choice == 'q':
            print("Saliendo del programa...")
            break
        elif choice == 's':
            strategy = SeleniumScraper()
        elif choice == 'b':
            strategy = BeautifulSoupScraper()
        else:
            print("Opción no válida. Inténtalo de nuevo.")
            continue

        scraper = ScraperContext(strategy)
        quotes = scraper.scrape_pages(BASE_URL)

        # Guardar y mostrar los resultados
        save_to_yaml(quotes)
        print("\nDatos extraídos:")
        for quote in quotes[:5]:  # Mostrar solo los primeros 5
            print(f"- {quote['text']} ({quote['author']})")

        # Cerrar Selenium si se usó
        if choice == 's':
            strategy.close()

if __name__ == "__main__":
    main()
