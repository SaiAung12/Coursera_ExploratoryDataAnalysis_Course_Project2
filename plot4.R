## download and unzip dataset
if(!file.exists("./dataset")){dir.create("./dataset")}

downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(downloadUrl, destfile = "./dataset/download.zip")

unzip(zipfile = "./dataset/download.zip", exdir = "./dataset")

## read data
NEI <- readRDS("./dataset/summarySCC_PM25.rds")
SCC <- readRDS("./dataset/Source_Classification_Code.rds")

## find Coal related total emissions in US according to years
coal_data_index <- data.frame()

# select all observations that inlude "Coal" phrase
for (column in names(SCC)){
        output <- data.frame(SCC[grepl("Coal", SCC[,column], ignore.case=TRUE), 1])
        coal_data_index <- rbind(coal_data_index, output)
} 

# take out unique SSCs
coal_data_index <- data.frame(unique(coal_data_index[,1]))

# find total emissions
coal_emission_data <- aggregate(Emissions ~ year,
                                data = NEI[NEI$SCC %in% coal_data_index[,1], ],
                                FUN = sum)

##plot histogram
png("plot4.png")

plot4 <- barplot(
        coal_emission_data$Emissions/1000,
        names.arg=coal_emission_data$year,
        xlab="Year",
        ylab="PM2.5 Emissions in Kilotons",
        main="Coal related PM2.5 Emissions in US over Years",
        ylim= c(0,(1.1*max(coal_emission_data$Emissions))/1000),
        col=coal_emission_data$year
)

text(x = plot4, y=round(coal_emission_data$Emissions)/1000,
     labels = round(coal_emission_data$Emissions)/1000,
     pos = 3)

dev.off()