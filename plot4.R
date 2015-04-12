##
# plot4.R
##

##
# First I manualy downloaded the dataset.
# Next I unziped it in the working directory which also contains the plot*.R-scripts.
# The R-script below starts by reading the dataset, next it filters the relevant records (observations).
# Having the correct data, I create a function that creates the plot on a screen. Finally I create
# the PNG file using this function. To run this code you have to make sure the unzipped dataset is
# in the same directory as this script.
##

##
# I call the dataset 'hpc' which stands for 'household power consumption'.
# In this dataset missing values are coded as ?, that's why I use na.strings.
# household_power_consumption_Top10.txt
##
hpc <- read.table('household_power_consumption.txt'
                  , header = TRUE
                  , sep = ";"
                  , na.strings = "?"
                  , stringsAsFactors = FALSE
                  )
summary(hpc)
# Please note column Date and Time are characters. All other columns are numeric..
nrow(hpc)
# [1] 2075259

##
# Restrict the data to "2007-02-01" and "2007-02-02". According to the 
# code book, Date is of the form "dd/mm/yyyy". This is not correct !
# In reality it is "d/m/yyyy". So Februry 1st and second looks like
# 1/2/2007, 2/2/2007. You can verify this using
##
unique(hpc$Date)[48:49]

hpc <- subset(hpc, hpc$Date %in% c( "1/2/2007", "2/2/2007" ))
summary(hpc)
View(hpc)
# As you can see, there is no need to convert Date :-)

##
# Now I have to create the PNG file. I start by creating a function
# createScreenPlot3 that creates the plot on the screen. When I am satified
# I use this function to create the PNG file.
#
# Plot 4 must contain four graph, this means I have to use par() with
# mfrow or mfcol. I choose for mfcol. This way the first two graphs
# are plot 2 and 3 I already made.
# 
# Graph datetime ~ voltage
# x:      Date and Time: I use paste0() to paste Date and Time together,
#           next I use strptime() to convert this character into a 
#           date-time-value, with GMT as TimeZone (tz).
# y:      Voltage
# xlabel: datetime
# ylabel: Voltage
# type:   l (for line)
# 
# Graph datetime ~ Global_reactive_power
# x:      Date and Time: I use paste0() to paste Date and Time together,
#           next I use strptime() to convert this character into a 
#           date-time-value, with GMT as TimeZone (tz).
# y:      Global_reactive_power
# xlabel: datetime
# ylabel: Global_reactive_power
# type:   l (for line)
#
# size:   480x480 (this appears to be default for png())
##

##
# Please note the names of the days of the week depend your local settings.
# To get Thus ... Sat I change my locale
##
# Back up my LC_TIME
myLC_TIME <- Sys.getlocale( category = "LC_TIME" ) # "Dutch_Netherlands.1252"
# Switch to English
Sys.setlocale(category = "LC_TIME", locale = "English")

##
# This plot contains three graphs. I start by making an empty plot using type = n.
# Next I add the three graphs to this empty plot. And I finish with the legend in
# the top right corner.
##
createScreenPlot4 <- function(){
    par( mfcol = c(2, 2) )
    # Graph Global Active Power
    plot(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Global_active_power
           , xlab = ""
           , ylab = "Global Active Power"
           , type = "l"
    )
    
    # Graph Energy sub metering
    plot(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
         , hpc$Sub_metering_1
         , xlab = ""
         , ylab = "Energy sub metering"
         , type = "n"
         )
    points(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Sub_metering_1
           , type = "l"
           , col = "black"
    )
    points(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Sub_metering_2
           , type = "l"
           , col = "red"
    )
    points(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Sub_metering_3
           , type = "l"
           , col = "blue"
    )
    legend( "topright"
            , pch = "-"
            , col = c( "black", "red", "blue" )
            , legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3" )
    )
    
    # Graph Voltage
    plot(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Voltage
           , xlab = "datetime"
           , ylab = "Voltage"
           , type = "l"
    )
    
    # Graph Global Reactive Power
    plot(  strptime( paste0( hpc$Date, "-", hpc$Time ), "%d/%m/%Y-%H:%M:%S", tz = "GMT" )
           , hpc$Global_reactive_power
           , xlab = "datetime"
           , ylab = "Global_reactive_power"
           , type = "l"
    )
}
# Check plot on screen
createScreenPlot4()
# Finally create PNG
png(filename = "plot4.png"
    , width  = 480
    , height = 480
    )
    createScreenPlot4()
dev.off()
# RStudioGD 
#         2 

# Restore my LC_TIME
Sys.setlocale(category = "LC_TIME", locale = myLC_TIME)
