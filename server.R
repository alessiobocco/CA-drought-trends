
library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(wesanderson)

######## Enter Data
# Download Califorina data from Google Trend, sourse: https://www.google.com/trends/explore#q=Climate%20Change%2C%20Xeriscaping%2C%20water%20use%2C%20pool%20party%2C%20dog%20days&geo=US-CA&cmpt=q&tz=Etc%2FGMT%2B7
google_trend <- read.csv("/Users/colleennell/Documents/R/Group 1//google_trend.csv")
google_trend2 <- read.csv("/Users/colleennell/Documents/R/Group 1/google_trend2.csv")
google_trend3 <- read.csv("/Users/colleennell/Documents/R/Group 1/pdsidate-2.csv")


# Make new data frame
gt = data.frame(start_of_week = as.Date(google_trend[1:637,1]))

# Save the google interest per word search:
gt$water_conservation = as.numeric(as.character(google_trend[1:637,3]))
gt$drought = as.numeric(as.character(google_trend[1:637,4]))
gt$drought_in_california = as.numeric(as.character(google_trend[1:637,5]))
gt$climate_change = as.numeric(as.character(google_trend2[1:637,3]))
gt$xeriscaping = as.numeric(as.character(google_trend2[1:637,4]))
gt$water_use = as.numeric(as.character(google_trend2[1:637,5]))
gt$pool_party = as.numeric(as.character(google_trend2[1:637,6]))
gt$dog_days = as.numeric(as.character(google_trend2[1:637,7]))
gt$Palmer_Drought_INDEX = (as.numeric(as.character(google_trend3[1:637,9])))

###### State of emergency
# Governour declare state of emergency on January 17, 2014
Emergency = as.Date("2014-01-17")
emerge = as.Date("2013-11-15")

###### Water Use
water_use <- read.csv("/Users/colleennell/Documents/R/Group 1/drought_water_use.csv")
wu = data.frame(date = as.Date(water_use[,2]))
wu$water_use = water_use[,3]

shinyServer(function(input, output) {
  gtReactive <- reactive({
  trend <- input$google_trend
  })
  
    output$google.plot <- renderPlot({
      # Create long form subset of the data
      gtsub = gt[,c("start_of_week","Palmer_Drought_INDEX",gtReactive())]
      gtmelt = melt(gtsub,id = "start_of_week")
      gtmelt <- gtmelt %>% filter(start_of_week > input$date_input)
      
      if (!input$Palmer_Drought_INDEX){
        gtmelt <- gtmelt %>% filter(variable != "Palmer_Drought_INDEX")
      }
    
      ggplot(gtmelt,aes_string(x="start_of_week",y="value"))+
        geom_line(size=1, aes(color = variable))+
        geom_vline(xintercept = as.numeric(Emergency),size=1.7,linetype=3)+
        annotate("text",x=emerge,y=75,label="Drought Emergency",angle=90,size=5)+
        labs(x= "Time", y = "Relative Search Frequency")+
        geom_text(aes(x= Emergency, label="", y = 100), colour="black", hjust = 1.2)+
        theme_bw()+
        theme(text=element_text(size=18),legend.position="bottom", panel.grid.major = element_blank(),panel.grid.minor = element_blank(),panel.border = element_blank())+
        scale_color_brewer(palette="Set1")
      })
    
    output$water_use.plot <- renderPlot({
      ggplot(wu,aes_string(x="date",y="water_use"))+
      geom_line(size=1)+
      labs(x= "Time", y = "Total Water Use (MGal/month) ")+
      geom_vline(xintercept = as.numeric(Emergency),linetype=4)+
      theme_bw()+
      theme(text=element_text(size=18),legend.position="bottom", panel.grid.major = element_blank(),panel.grid.minor = element_blank(),panel.border = element_blank())
    })
})