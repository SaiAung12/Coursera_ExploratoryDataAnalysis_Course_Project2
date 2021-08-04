## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## find Motor Vehicle related emissions in Baltimore city according to years
motor_data_index <- data.frame()

# select all observations that inlude "motor" or "vehicle" phrase
for (column in names(SCC)){
        output <- data.frame(SCC[grepl("motor|vehicle", SCC[,column], ignore.case=TRUE), 1])
        motor_data_index <- rbind(motor_data_index, output)
} 

# take out unique SSCs
motor_data_index <- data.frame(unique(motor_data_index[,1]))

# find total emissions in Baltimore City
motor_emission_data <- aggregate(Emissions ~ year,
                                data = subset(NEI[NEI$SCC %in% motor_data_index[,1],], fips == "24510"), 
                                FUN = sum)

## plot histogram
png("plot5.png")

plot5 <- barplot(
        motor_emission_data$Emissions,
        names.arg=motor_emission_data$year,
        xlab="Year",
        ylab="PM2.5 Emissions in Tons",
        main="Motor Vehicle related PM2.5 Emissions in Baltimore City over Years",
        ylim= c(0,(1.1*max(motor_emission_data$Emissions))),
        col=motor_emission_data$year
)

text(x = plot5,
     y=round(motor_emission_data$Emissions),
     labels = round(motor_emission_data$Emissions),
     pos = 3)

dev.off()