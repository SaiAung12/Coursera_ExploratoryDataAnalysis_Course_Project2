## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## find total emissions according to years
emission_sum <- aggregate(Emissions ~ year, data = NEI, FUN=sum)

## plot histogram
png("plot1.png")

plot1 <- barplot(
        emission_sum$Emissions/1000,
        names.arg=emission_sum$year,
        xlab="Year",
        ylab="PM2.5 Emissions in Kilotons",
        main="Total PM2.5 Emissions in US over Years",
        ylim= c(0,(1.1 * max(emission_sum$Emissions))/1000),
        col=emission_sum$year
)

text(x = plot1, y=round(emission_sum$Emissions/1000),
     labels = round(emission_sum$Emissions/1000),
     pos = 3)

dev.off()
