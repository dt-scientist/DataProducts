# server.R
#Dependencies
require('rCharts')
require('shiny')
require("quantmod")
require("TTR")
require("stringr")
require('lubridate')
shinyServer(function(input, output,session) {

  
#   tsdates <- function(ts){
#     dur<-12%/%frequency(ts)
#     years<-trunc(time(ts))
#     months<-(cycle(ts)-1)*dur+1
#     yr.mn<-as.data.frame(cbind(years,months))
#     dt<-apply(yr.mn,1,function(r){paste(r[1],r[2],'01',sep='/')})
#     as.POSIXct(dt,tz='UTC')
#   }
  
#   SYM<-function (x,loc='yahoo') {
#     getSymbols(x,src=loc)
#     return(get(x))}
  
  
  output$myChart <- renderPlot({
     
     dataInput  <- function(){getSymbols(input$symb, src = "yahoo", 
    from = input$dates[1],
    to = input$dates[2],
    auto.assign = FALSE)}
    
    
#     dataInput <-function(data="BARC.L",loc='google',start.date=Sys.Date()-months(1),
#                          end.date=Sys.Date()) {
#       getSymbols(data,src=loc)
#       x<-as.data.frame(window(SYM(data,loc=loc),
#                               start=as.character(start.date),
#                               end=as.character(end.date)))
#       x$dates<-row.names(x)
#       return(return(x)) 
#     }
    
  output$value <- renderText({ input$periodicity })

data<- dataInput()
data <- data[endpoints(data, on =input$periodicity)]

  data <- data.frame(
    index(data),
    coredata(data),
    stringsAsFactors=FALSE)
  
   names(data) = gsub(".*\\.", "", names(data))
  colnames( data )[1] <- c( "Date")
 #data$Date <- format(data$Date,format= "%Y-%m-%d")
 
 if ('none' %in% input$transforms){
   data$Close <- data$Close
 }
 if ('sq' %in% input$transforms){
   data$Close <- data$Close^2
 }
 if ('sqr' %in% input$transforms){
   data$Close <- sqrt(data$Close)
 }
 if ('nlog' %in% input$transforms){ 
   data$Close <- log(data$Close)
 }
if ('clog' %in% input$transforms){   
    data$Close <- log10(data$Close)
   }
if ('rec' %in% input$transforms){
    data$Close <- 1/data$Close
    }
if ('recsqr' %in% input$transforms){
    data$Close <- 1/sqrt(data$Close)
    }
 
 require(methods)

data.ts <- filter(data$Close,filter=rep(1/input$lfperiod,input$lfperiod))
 df <- data.frame(Date=data$Date ,y=as.matrix(data.ts))
data$filter <- as.double(data.ts)



p<- ggplot(data, aes(x =Date, y =Close)) +  geom_line(aes())
# 
# if ( !is.null(input$smooths) && input$smooths!=0){
#   updateCheckboxInput(session, "linearfilter",value = 0)
#   input$smooths=0
# }
if ('ls' %in% input$smooths){
p<- p + stat_smooth(method = "lm", size = 1,colour = "blue",aes(group=1))
}
if ('lwr' %in% input$smooths){
p<- p + stat_smooth(method = "loess", colour = "red" ,aes(group=1))
}
if ('poly2' %in% input$smooths){
p<- p + stat_smooth(method="lm", se=TRUE, fill=NA,
                      formula=y ~ poly(x, 2, raw=TRUE),colour="green",aes(group=1))
    }
if ('poly5' %in% input$smooths){
  p<- p + stat_smooth(method="lm", se=TRUE, fill=NA,
                      formula=y ~ poly(x, 5, raw=TRUE),colour="orange",aes(group=1))
}
if ('gam' %in% input$smooths){
#   p<- p + stat_smooth(formula = y ~ s(x),colour="orange",aes(group=1))
#   model <- dyn$lm( Close ~ lag(Close,-1) + lag(Close,-2), data )
#   p<- p+model
  p<- p + stat_smooth(method = "gam", formula = y ~ s(x),colour="orange",aes(group=1))
}
if (input$linearfilter!=0){
  
#   data.ts <- filter(data$Close,filter=rep(1/input$lfperiod,input$lfperiod))
#   df <- data.frame(Date=tsdates(data.ts),y=as.matrix(data.ts))
# p<- p+geom_line(data = df,aes(x = Date, y =y))
  
 # data.ts <- filter(data$Close,filter=rep(1/input$lfperiod,input$lfperiod))
#  df <- data.frame(Date=data$Date ,y=as.matrix(data.ts))
 # data$filter <- as.double(data.ts)
#   df <- data.frame(tsdates(data.ts),y=as.matrix(data.ts))
 # df <- data.frame(Date=tsdates(data.ts),y=as.matrix(data.ts))
#   q<-qplot(tsdates(data.ts),data.ts,geom='line')
  # p<- p+geom_line(data = df,aes(x = Date, y =y))

# updateTextInput(session, "smooths", value = " ")     
# updateTextInput(session, "smooths", value = " ")    


#data[is.na(data)] <- 0

#rows<-colSums(is.na(data[,6]))
# rows<- apply(data, 2, function(x) length(which(!is.na(x))))
#rows<-nrow(data[1])
# output$text1 <- renderText({ 
#   paste("val", data$filter)
# })

# ggplot(data,aes(data[,1]))+geom_line(aes(y=data[,3]))
#p<-ggplot(data,aes(x=Date))+geom_line(aes(y=Close))+geom_line(aes(y=filter))
p<-p+geom_line(aes(y=filter))


}
#p<-p+scale_x_continuous(breaks = c(2000,2002,2004,2013,2014)) 
#model <- dyn$lm( y ~ lag(y,-1) + lag(y,-2), train )
print(p)





})

# observe({
#   if (  input$showfile != 0) {
#     file.show("Understanding_SP_Rating_Definitions.pdf")
#   }
# })

} )