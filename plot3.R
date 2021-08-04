## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## load ggplot library
library(ggplot2)

## find total emissions in Baltimore city according to source type
baltimore_data <- aggregate(Emissions ~ year + type, 
                            data = subset(NEI, fips == "24510"), 
                            sum)

## plot histogram
png("plot3.png")

ggplot(baltimore_data, aes(x = factor(year), y = Emissions, fill=type)) +
        geom_bar(stat="identity") +
        guides(fill=FALSE) +
        facet_grid(.~type,scales = "free",space="free") +
        geom_text(label = round(baltimore_data$Emissions), vjust = -.3, size =3) +
        labs(x = "Year", y = "PM2.5 Emissions in Kilotons", title = "Total PM2.5 Emissions in Baltimore City over Years by Source Type")

dev.off()
