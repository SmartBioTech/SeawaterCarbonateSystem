
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(plotrix)
library(seacarb)
library(shiny)

shinyUI(fluidPage(
  
  # Application title
  tags$head(includeScript('google-analytics.js')),
  titlePanel("Seawater Carbonate System"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput('pH',"pH", value = 8.1, min = 0, max = 14, step = 0.01),
      numericInput('pco2',"pCO2, ppm", value = 400, min = 0, max = 5000000, step = 1),
      numericInput('temp',HTML("Temperature, &#8451;"), value = 25, min = 5, max = 40, step = 0.5),
      numericInput('salinity',"Salinity, g/kg", value = 35, min = 5, max = 44, step = 0.5),
      selectInput('k1k2',
                  "Parameter set for k1 and k2:",
                  c("Lueker et al. (2000)" = "x",
                    "Millero et al. (2006)" = "m06",
                    "Millero (2010)" = "m10",
                    "Waters et al. (2014)" = "w14",
                    "Roy et al. (1993)" = "r"),
                  selected = "x"),
      tags$hr(),
      p(
         "@author CzechGlobe - Department of Adaptive Biotechnologies (JaCe)"
      ),
      p(
         "@email cerveny.j@czechglobe.cz"
      )
    ),
    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput('DIC.forms'),
      textOutput('dCO2'),
      textOutput('HCO3'),
      textOutput('CO3'),
      textOutput('DIC'),
      plotOutput('DIC.plot', width = '90%'),
      a(
        href="http://www.obs-vlfr.fr/~gattuso/seacarb.php",
        "Based on Seacarb R package."
      )
    )
  )
))
