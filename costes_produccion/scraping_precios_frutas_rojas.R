library(rvest)
library(httr)
library(xml2)
library(tidyverse)
library(janitor)

url <- "https://www.mapa.gob.es/es/agricultura/estadisticas/precios-semanales-frutas.aspx"

pagina <- read_html(url)
tablas <- html_table(pagina, fill = TRUE)
tabla_frutas <- tablas[[1]]

tabla_limpia <- tabla_frutas %>%
  clean_names() %>%
  rename(producto = 1, precio = 2) %>%
  filter(!is.na(precio)) %>%
  mutate(precio = as.numeric(str_replace(precio, ",", ".")))

write_csv(tabla_limpia, "precios_frutas_rojas.csv")

ggplot(tabla_limpia, aes(x = reorder(producto, -precio), y = precio)) +
  geom_col(fill = "#A02D58") +
  labs(
    title = "Precios semanales de frutas rojas",
    subtitle = "Fuente: Ministerio de Agricultura de España",
    x = "Producto",
    y = "Precio medio (€/kg)"
  ) +
  theme_minimal(base_size = 13) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
