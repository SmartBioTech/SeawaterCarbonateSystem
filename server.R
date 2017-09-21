
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(plotrix)
library(seacarb)
library(shiny)

shinyServer(function(input, output) {
   DIC <- reactive({
      carb(21, input$pco2, input$pH, input$salinity, input$temp)
   })
   output$DIC.forms <- renderUI({
      HTML(paste0(
         'Dissolved <b>CO<sub>2</sub></b> concentration is <b>',
         round(DIC()$CO2*1e6, digits = 1),
         ' umol/kg</b> [',
         round(DIC()$CO2/DIC()$DIC*100, digits = 1),
         '%, ',
         round(DIC()$CO2 * 44.01 * 1000, digits = 1),
         'mg(C)/kg(H<sub>2</sub>O])] <br/>',
         '<i>Bicarbonate</i> (<b>HCO<sub>3</sub><sup>-</sup></b>) concentration is <b>',
         round(DIC()$HCO3*1e6, digits = 1),
         ' umol/kg</b> (',
         round(DIC()$HCO3/DIC()$DIC*100, digits = 1),
         '%, ',
         round(DIC()$HCO3 * 61.02 * 1000, digits = 1),
         'mg(C)/kg(H<sub>2</sub>O])] <br/>',
         '<i>Carbonate</i> (<b>CO<sub>3</sub><sup>2-</sup></b>) concentration is <b>',
         round(DIC()$CO3*1e6, digits = 1),
         ' umol/kg</b> (',
         round(DIC()$CO3/DIC()$DIC*100, digits = 1),
         '%, ',
         round(DIC()$HCO3 * 60.01 * 1000, digits = 1),
         'mg(C)/kg(H<sub>2</sub>O])] <br/>',
         'Total dissolved inorganic carbon (<b>DIC</b>) concentration is <b>',
         round(DIC()$DIC*1e6, digits = 1),
         ' umol/kg</b>'
      ))
   })
   output$DIC.plot <- renderPlot({
      cs <- data.frame(dCO2 = 0, HCO3 = 0, CO3 = 0, DIC = 0)
      i <- 1
      pH <- seq(2,12,1/3)
      for (j in pH){
         cs[i, ] <- carb(21,input$pco2, j, input$salinity, input$temp)[c("CO2","HCO3","CO3","DIC")]
         i <- i + 1
      }
      y <- log10(cs$DIC)
      twoord.plot(
         lx = pH,
         ly = cs$dCO2 / cs$DIC,
         rx = pH,
         ry = y,
         xlab = 'pH',
         ylab = 'Relative distribution of DIC forms, -',
         rylab = 'Total DIC, log10(umol/kg)',
         rpch = 1
      )
      lines(pH, cs$HCO3 / cs$DIC, lty = 2)
      lines(pH, cs$CO3 / cs$DIC, lty = 3)
      legend(2, 0.6, c("dCO2", "HCO3", "CO3"), lty = c(1,2,3))
   })
})